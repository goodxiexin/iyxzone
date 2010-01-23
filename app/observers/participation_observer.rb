require 'app/mailer/event_mailer'

class ParticipationObserver < ActiveRecord::Observer

	def field status
		if status == Participation::Confirmed
			"confirmed_count"
		elsif status == Participation::Maybe
			"maybe_count"
		end
	end

	def after_create participation
		event = participation.event
		participant = participation.participant
		
    if participation.is_invitation?
			participant.raw_increment :event_invitations_count
			event.raw_increment :invitations_count	
			EventMailer.deliver_invitation event, participation if participant.mail_setting.invite_me_to_event
		elsif participation.is_request?
			event.poster.raw_increment :event_requests_count
			event.raw_increment :requests_count
			EventMailer.deliver_request event, participation if event.poster.mail_setting.request_to_attend_my_event
    elsif participation.is_confirmed?
      event.raw_increment :confirmed_count
      #if event.poster != participation.participant
      #  participation.participant.raw_increment :upcoming_events_count
      #end
		end	
	end

	def after_update participation
    # update user's counter and event's counter
		event = participation.event
		participant = participation.participant
    
    if participation.was_invitation? and participation.is_authorized?
			event.raw_decrement :invitations_count
      event.raw_increment field(participation.status)
      participant.raw_decrement :event_invitations_count
      participant.raw_increment :upcoming_events_count if event.has_only_one_character_for? participant
			participation.notifications.create(
        :user_id => event.poster_id, 
        :data => "#{profile_link participant}接受了你的邀请: 同意让游戏角色 #{participation.character.name} 加入活动#{event_link event}")
		elsif participation.was_request? and participation.is_authorized?
			event.raw_decrement :requests_count
      event.raw_increment field(participation.status)
      event.poster.raw_decrement :event_requests_count
      participant.raw_increment :upcoming_events_count if event.has_only_one_character_for? participant
			participation.notifications.create(
        :user_id => participant.id, 
        :data => "#{profile_link event.poster} 同意了你让游戏角色 #{participation.character.name} 加入活动 #{event_link event} 的请求")
		elsif participation.was_authorized? and participation.is_authorized?
			# participant changes status
			# TODO: 是否有必要让poster知道
			event.raw_decrement field(participation.status_was)
      event.raw_increment field(participation.status)
		end

    # issue feeds if necessary
    return unless participant.application_setting.emit_event_feed
    return if participation.was_authorized? and participation.is_authorized?
    
    recipients = [participant.profile]
    recipients.concat participant.guilds
    recipients.concat participant.friends.find_all{|f| f.application_setting.recv_event_feed}
    participation.deliver_feeds :recipients => recipients
	end

	def after_destroy participation
		event = participation.event
		participant = participation.participant
    
      if participation.is_invitation?
			  # invitation is declined
			  participant.raw_decrement :event_invitations_count
			  event.raw_decrement :invitations_count
        event.poster.notifications.create(
          :data => "#{profile_link participant} 拒绝让游戏角色 #{participation.character.name} 加入你的活动 #{event_link event}")
		  elsif participation.is_request?
			  # request is declined
			  event.poster.raw_decrement :event_requests_count
			  event.raw_decrement :requests_count
			  participant.notifications.create(
          :data => "#{profile_link event.poster}拒绝了让你的游戏角色 #{participation.character.name} 加入活动#{event_link event}的请求")
      elsif participation.is_authorized?
        # paricipant is evicted
        participant.raw_decrement :upcoming_events_count unless event.has_participant? user
        event.raw_decrement field(participation.status)
        participant.notifications.create(:data => "你的游戏角色 #{participation.character.name} 被剔除出了活动 #{event_link event}")
      end
	end

end
