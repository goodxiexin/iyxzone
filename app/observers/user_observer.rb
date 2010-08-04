require 'app/mailer/user_mailer'

class UserObserver < ActiveRecord::Observer

  # 这个如果写到db/migrate/create_users的话，以后修改mail_setting的默认值也不会对后来创建的用户产生变化
  def before_create user
    user.mail_setting = MailSetting.default
    user.privacy_setting = PrivacySetting.default
    user.application_setting = ApplicationSetting.default
  end
 
	def after_create user
    Profile.create(:user_id => user.id, :login => user.login, :gender => user.gender)
    user.create_avatar_album
    UserMailer.deliver_signup_notification user
  end
  
  def after_save user
    if user.recently_activated?
      # deliver mail
      UserMailer.deliver_activation user

      # add friend if necessary
      token = user.invitee_code
      if token
        invitor = SignupInvitation.find_sender(token) || User.find_by_invite_code(token) || User.find_by_invite_fan_code(token) || User.find_by_qq_invite_code(token) || User.find_by_msn_invite_code(token)
        if !invitor.blank?
          if token == invitor.invite_fan_code
            Fanship.create :fan_id => user.id, :idol_id => invitor.id
          else
            user.friendships.create(:friend_id => invitor.id)
            invitor.friendships.create(:friend_id => user.id)
          end
        end
      end

      # create suggestions
=begin
			user.create_friend_suggestions
太慢了，所以先听了
			user.servers.each do |s|
				user.create_comrade_suggestions s
			end
=end
    end
    
    UserMailer.deliver_forgot_password user if user.recently_forgot_password?
    UserMailer.deliver_reset_password user if user.recently_reset_password?
  end

end
