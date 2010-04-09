class GuestbookMailer < ActionMailer::Base

  layout 'mail'

  def reply user, text
    setup_email user
    subject     "17Gaming(一起游戏网) - 您汇报的错误我们已经关注"
    body        :user => user, :reply => text
  end

protected
  
  def setup_email user
    recipients  user.email
    from        SITE_MAIL
    sent_on     Time.now
  end

end
