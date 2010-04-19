require 'app/mailer/user_mailer'

class UserObserver < ActiveRecord::Observer
 
	def after_create user
    # TODO: 自从合了小样的代码，下面这句话就挂了
    #user.create_profile
    Profile.create(:user_id => user.id, :login => user.login, :gender => user.gender)
    user.create_avatar_album
    #UserMailer.deliver_signup_notification user
  end

  def after_save user
    #UserMailer.deliver_activation user if user.recently_activated?
    UserMailer.deliver_forgot_password user if user.recently_forgot_password?
    UserMailer.deliver_reset_password user if user.recently_reset_password?
  end

end
