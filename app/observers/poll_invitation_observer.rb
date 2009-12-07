require 'app/mailer/poll_mailer'

class PollInvitationObserver < ActiveRecord::Observer

	def after_create invitation
		PollMailer.deliver_invitation invitation.poll, invitation.user if invitation.user.mail_setting.invite_me_to_poll
		invitation.user.raw_increment :invitations_count
	end

	def after_destroy invitation
		invitation.user.raw_decrement :invitations_count
	end

end
