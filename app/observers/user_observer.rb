require 'app/mailer/user_mailer'

class UserObserver < ActiveRecord::Observer
  
	def after_create(user)
    user.create_profile(:gender => user.gender)
    user.create_avatar_album(:privilege => 2, :poster_id => user.id, :title => "头像相册") # avatar album has a default privilege of 2
    #UserMailer.deliver_signup_notification(user)
  end

  def after_save(user)
    #UserMailer.deliver_activation(user) if user.recently_activated?
    UserMailer.deliver_forgot_password(user) if user.recently_forgot_password?
    UserMailer.deliver_reset_password(user) if user.recently_reset_password?
  end

end
