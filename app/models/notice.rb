# comment, photo_tag, friend_tag会产生一些notice
# 这些notice会显示在主页上
class Notice < ActiveRecord::Base

	belongs_to :producer, :polymorphic => true # only for comment, and tag

	belongs_to :user

	named_scope :unread, :conditions => {:read => false}

  def relative_notices
    Notice.match(:user_id => user_id).all {|n| relative_to? n}
  end

  def unread_relative_notices
    Notice.match(:user_id => user_id).unread.all {|n| n.relative_to? n}
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
