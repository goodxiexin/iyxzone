require 'app/mailer/event_mailer'

class ParticipationObserver < ActiveRecord::Observer

	def field status
		if status == Participation::Confirmed
			"confirmed_count"
		elsif status == Participation::Maybe
			"maybe_count"
		elsif status == Participation::Declined
			"declined_count"
		end
	end

	def after_create participation
		event = participation.event
		participant = participation.participant
		if participation.is_invitation?
			participant.raw_increment :event_invitations_count
			event.raw_increment :invitees_count	
			EventMailer.deliver_invitation event, participant if participant.mail_setting.invite_me_to_event
		elsif participation.is_request?
			event.poster.raw_increment :event_requests_count
			event.raw_increment :requestors_count
			EventMailer.deliver_request event, participant if event.poster.mail_setting.request_to_attend_my_event
    elsif participation.is_confirmed?
      event.raw_increment :confirmed_count
      if event.poster != participation.participant
        participation.participant.raw_increment :upcoming_events_count
      end
		end	
	end

	def after_update participation
    # update user's counter and event's counter
		event = participation.event
		participant = participation.participant
    if participation.was_invitation? and participation.is_authorized?
			participant.raw_decrement :event_invitations_count
			participant.raw_increment :upcoming_events_count
			event.raw_decrement :invitees_count
      event.raw_increment field(participation.status)
      # TODO: 如果是拒绝的话，咋办
			participation.notifications.create(:user_id =>event.poster_id, :data => "#{profile_link participant}接受了你的邀请，加入活动#{event_link event}")
		elsif participation.was_request? and participation.is_authorized?
			event.poster.raw_decrement :event_requests_count
			participant.raw_increment :upcoming_events_count
			event.raw_decrement :requestors_count
      event.raw_increment field(participation.status)
			participation.notifications.create(:user_id => participant.id, :data => "#{profile_link event.poster}同意了你加入活动#{event_link event}的请求")
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

	def after_destroy(participation)
		event = participation.event
		participant = participation.participant
		if participation.is_invitation?
			# invitation expired
			participant.raw_decrement :event_invitations_count
			event.raw_decrement :invitees_count	
		elsif participation.is_request?
			# request declined or expired
			event.poster.raw_decrement :event_requests_count
			event.raw_decrement :requestors_count
      if event.start_time > Time.now
			  participant.notifications.create(:data => "#{profile_link event.poster}拒绝了你加入活动#{event_link event}的请求")
		  end
    elsif participation.is_authorized?
      # event is cancelled
      participant.notifications.create(:data => "#{profile_link event.poster}取消了活动#{event_link event}")
      event.raw_decrement field(participation.status)
      if participant != event.poster
        participant.raw_decrement :upcoming_events_count
        EventMailer.deliver_event_cancel(event, participant) if participant.mail_setting.cancel_event 
      end
    end
	end

end
