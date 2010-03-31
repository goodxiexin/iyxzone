class PokeMailer < ActionMailer::Base

  layout 'mail'

  def poke delivery
    setup_email	delivery.recipient
		subject			"17Gaming.com(一起游戏网) - #{delivery.sender.login}给你打招呼了"
		body				:user => delivery.recipient, :delivery => delivery, :url => "#{SITE_URL}/pokes"
  end

protected

  def setup_email	user
		recipients	user.email
		from				SITE_MAIL
    sent_on			Time.now
  end

end
