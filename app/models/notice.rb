# comment, photo_tag, friend_tag会产生一些notice
# 这些notice会显示在主页上
class Notice < ActiveRecord::Base

	belongs_to :producer, :polymorphic => true # only for comment, and tag

	belongs_to :user

	named_scope :unread, :conditions => {:read => false}

  # 把所有same source的通知都标记为以读
  def read_by user, single=false
    if single
      update_attribute('read', '1')
      user.raw_decrement :unread_notices_count, 1
    else
      notices = user.notices.unread.find_all {|n| self.relative_to? n}
      Notice.update_all("notices.read = 1", {:id => notices.map(&:id)})
      user.raw_decrement :unread_notices_count, notices.count
    end
  end

protected

  def relative_to? notice
    if self.producer_type != notice.producer_type
      false
    else
      proc = self.producer.class.notice_opts[:relative] || lambda {}
      proc.call(self.producer) == proc.call(notice.producer)
    end
  end
  
end
