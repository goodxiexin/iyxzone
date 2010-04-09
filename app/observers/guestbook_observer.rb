require 'app/mailer/guestbook_mailer'

class GuestbookObserver < ActiveRecord::Observer

  def after_update guestbook
    if guestbook.recently_reply_to_poster
      GuestbookMailer.deliver_reply guestbook.user, guestbook.reply
    end
  end

end
