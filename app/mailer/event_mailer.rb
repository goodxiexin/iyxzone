class EventMailer < ActionMailer::Base

  layout 'mail'
  
  def time_change event, participant 
    setup_email	participant
    subject			"17Gaming.com(一起游戏网) - 活动'#{event.title}'的时间改了"
    body				:event => event, :user => participant, :url => "#{SITE_URL}/events/#{event.id}"
  end
  
  def event_cancel event, participant 
    setup_email	participant
		subject			"17Gaming.com(一起游戏网) - 活动'#{event.title}'取消了"
		body				:event => event, :user => participant, :poster => event.poster
  end

  def approaching_notification event, participant 
    setup_email	participant
    subject			"17Gaming.com(一起游戏网) - 活动'#{event.title}'马上就要开始了"
    body				:event => event, :user => participant, :url => "#{SITE_URL}/events/#{event.id}"
  end

	def invitation event, invitation
		setup_email invitation.participant
		subject			"17Gaming.com(一起游戏网) - 你的游戏角色 #{invitation.character.name} 被邀请加入活动'#{event.title}'"
		body				:event => event, :user => invitation.participant, :character => invitation.character, :url => "#{SITE_URL}/events/#{event.id}"
	end

	def request event, request
		setup_email event.poster
		subject			"17Gaming.com(一起游戏网) - #{request.participant.login}请求让游戏角色 #{request.character.name} 加入活动'#{event.title}'"
		body				:event => event, :user => event.poster, :character => request.character, :url => "#{SITE_URL}/events/#{event.id}"
	end

protected

  def setup_email participant
		recipients	participant.email
		from				SITE_MAIL
		sent_on			Time.now
  end

end
