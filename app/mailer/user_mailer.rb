class UserMailer < ActionMailer::Base

  layout 'mail', :only => [:activation, :forgot_password, :reset_password]

  add_template_helper MailerHelper

  def long_time_no_seen user, hot_users, games, photos, polls, news
    setup_email user
    subject     "17Gaming(一起游戏网) - 我们希望你再来看看！"
    body        :user => user, :hot_users => hot_users, :games => games, :photos => photos, :polls => polls, :news => news, :url => "#{SITE_URL}/home"
  end

  def mini_blog user
    setup_email user
    subject     "17Gaming(一起游戏网) - 大改版，迎来微博时代"
    body        :user => user
  end

  def signup_notification user
    setup_email	  user
    subject			  "17Gaming(一起游戏网) - 激活您的帐号"
    body			    :user => user, :url => "#{SITE_URL}/activate/#{user.activation_code}"
  end

  def signup_invitation invitation
    recipients  invitation.recipient_email
		from				"17gaming" + '<' + SITE_MAIL + '>'
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

  def mail user, title, text
    setup_email user
    subject     "17Gaming(一起游戏网) - #{title}"
    body        :user => user, :text => text    
  end

protected
  
  def setup_email user
    recipients	user.email
		from				SITE_MAIL
    sent_on			Time.now
  end

end
