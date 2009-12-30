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

	def after_create(participation)
		event = participation.event
		participant = participation.participant
		if participation.status == Participation::Invitation
			# invitation created
			participant.raw_increment :invitations_count
			event.raw_increment :invitees_count	
			EventMailer.deliver_invitation event, participant if participant.mail_setting.invite_me_to_event
			participant.increment! :invitations_count
		elsif participation.status == Participation::ConfirmRequest or participation.status == Participation::MaybeRequest
			# request created
			event.poster.raw_increment :requests_count
			event.raw_increment :requestors_count
			EventMailer.deliver_request event, participant if participant.mail_setting.request_to_attend_my_event
		elsif participation.status == Participation::Confirmed
			event.raw_increment :confirmed_count
			event.poster.raw_increment :upcoming_events_count
		end	
	end

	def after_update(participation)
		event = participation.event
		participant = participation.participant
		if participation.status_was == 0 and [3,4,5].include? participation.status
			# invitation accepted
			participant.raw_decrement :invitations_count
			participant.raw_increment :upcoming_events_count
			event.raw_decrement :invitees_count
			event.poster.notifications.create(:data => "#{profile_link participant}接受了你的邀请，加入活动#{event_link event}")
		elsif [1,2].include? participation.status_was and [3,4,5].include? participation.status
			# request accepted
			event.poster.raw_decrement :requests_count
			participant.raw_increment :upcoming_events_count
			event.raw_decrement :requestors_count
			participant.notifications.create(:data => "#{profile_link event.poster}同意了你加入活动#{event_link event}的请求")
		elsif [3,4,5].include? participation.status_was and [3,4,5].include? participation.status
			# participant changes status
			# TODO: 是否有必要让poster知道
			event.raw_decrement field(participation.status_was)
		end
		event.raw_increment field(participation.status)		
	end

	def after_destroy(participation)
		event = participation.event
		participant = participation.participant
		if participation.status_was == 0
			# invitation expired
			participant.raw_decrement :invitations_count
			event.raw_decrement :invitees_count	
		elsif [1,2].include? participation.status_was
			# request declined or expired
			event.poster.raw_decrement :requests_count
			event.raw_decrement :requestors_count
			participant.notifications.create(:data => "#{profile_link event.poster}拒绝了你加入活动#{event_link event}的请求")
		end
	end

end
