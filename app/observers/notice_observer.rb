class NoticeObserver < ActiveRecord::Observer

  def after_create notice
    notice.user.raw_increment :notices_count
    notice.user.raw_increment :unread_notices_count unless notice.read
  end

  def after_update notice
    if !notice.read_was and notice.read
      notices = notice.unread_relative_notices # notices doesnt contain notice
      notice.user.raw_decrement :unread_notices_count, notices.count + 1
      # this doesnt trigger observer, thus no infinite loop
      Notice.update_all("notices.read = 1", {:id => notices.map(&:id)})
    end
  end

  def after_destroy notice
    notice.user.raw_decrement :notices_count
    notice.user.raw_decrement :unread_notices_count unless notice.read
  end

end
