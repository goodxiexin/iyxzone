class EventMailer < ActionMailer::Base

  def place_change event, participant 
    setup_email	participant
		subject			"Dayday3 - 活动#{event.title}的地点改了"
    body				:user => participant, :url => "#{SITE_URL}/events/#{event.id}"
  end

  def time_change event, participant 
    setup_email	participant
    subject			"Dayday3 - 活动'#{event.title}'的时间改了"
    body				:user => participant, :url => "#{SITE_URL}/events/#{event.id}"
  end

  def event_cancel event, participant 
    setup_email	participant
		subject			"Dayday3 - 活动'#{event.title}'取消了"
		body				:user => participant, :poster => event.poster
  end

  def approaching_notification event, participant 
    setup_email	participant
    subject			"Dayday3 - 活动'#{event.title}'马上就要开始了"
    body				:user => participant, :url => "#{SITE_URL}/events/#{event.id}"
  end

	def invitation event, participant
		setup_email participant
		subject			"Dayday3 - 你被邀请加入活动'#{event.title}'"
		body				:user => participant, :url => "#{SITE_URL}/events/#{event.id}"
	end

	def request event, participant
		setup_email event.poster
		subject			"Dayday3 - #{participant.login}请求加入活动'#{event.title}'"
		body				:user => event.poster, :url => "#{SITE_URL}/events/#{event.id}"
	end

protected

  def setup_email participant
		recipients	participant.email
		from				SITE_MAIL
		sent_on			Time.now
  end

end
