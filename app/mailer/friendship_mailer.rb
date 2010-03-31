class FriendshipMailer < ActionMailer::Base

	def request user, friend
		setup_email friend
		subject			"17Gaming.com(一起游戏网) - #{user.login}要求加你为好友"
		body				:user => user, :friend => friend, :url => "#{SITE_URL}/requests"
	end

  def confirm user, friend
    setup_email user
    subject     "17Gaming.com(一起游戏网) - #{friend.login}同意加你为好友"
    body        :user => user, :friend => friend, :url => "#{SITE_URL}/profiles/#{friend.profile.id}"
  end

protected

	def setup_email friend
		recipients	friend.email
		from				SITE_MAIL
		sent_on			Time.now	
	end

end
