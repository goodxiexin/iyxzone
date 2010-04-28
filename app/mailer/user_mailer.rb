class UserMailer < ActionMailer::Base

  layout 'mail', :only => [:activation, :forgot_password, :reset_password]

  def long_time_no_seen user
    setup_email user
    subject     "17Gaming(一起游戏网) - 你已经一周以上没有上线了"
    body        :user => user, :url => "#{SITE_URL}/home"
  end

  def signup_notification user, token
    setup_email	user
    subject			"17Gaming(一起游戏网) - 激活您的帐号"
		content_type	"utf-8"
		content_type	"text/html"
    if token.blank?
      body			:user => user, :url => "#{SITE_URL}/activate/#{user.activation_code}"
    else
      body      :user => user, :url => "#{SITE_URL}/activate/#{user.activation_code}?invite_token=#{token}"
    end
  end

  def signup_invitation invitation
    recipients  invitation.recipient_email
    from        SITE_MAIL
    sent_on     Time.now
    subject     "17Gaming(一起游戏网) - #{invitation.sender.login} 邀请您加入"
    body        :user => invitation.sender, :url => "#{SITE_URL}/invite?token=#{invitation.token}"
  end

  def activation user
    setup_email	user
    subject			"17Gaming(一起游戏网) - 您的帐号已经激活"
    body				:user => user, :url => "#{SITE_URL}/profiles/#{user.profile.id}"
  end

  def forgot_password user
    setup_email	user
    subject			"17Gaming(一起游戏网) - 申请重新设置您的密码"
    body				:user => user, :url => "#{SITE_URL}/reset_password/#{user.password_reset_code}"
  end

  def reset_password user
    setup_email	user
    subject			"17Gaming(一起游戏网) - 您的密码已经重新设置了"
    body				:user => user
  end

protected
  
  def setup_email user
    recipients	user.email
    from				SITE_MAIL
    sent_on			Time.now
  end

end
