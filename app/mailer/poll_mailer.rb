class PollMailer < ActionMailer::Base

  layout 'mail'

  def result poll, user
    setup_email	user
		subject			"17Gaming.com(一起游戏网) - 投票#{poll.name}结束了，快去看看结果"
		body				:poll => poll, :user => user, :url => "#{SITE_URL}/polls/#{poll.id}"
  end

	def invitation poll, user
		setup_email	user
		subject		 "17Gaming.com(一起游戏网) - #{poll.poster.login}邀请你参加投票#{poll.name}"
		body			 :poll => poll, :user => user, :url => "#{SITE_URL}/polls/#{poll.id}"
	end

protected

  def setup_email	user
		recipients	user.email
		from				SITE_MAIL
    sent_on			Time.now
  end

end
