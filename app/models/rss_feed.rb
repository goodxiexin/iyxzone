class RssFeed < ActiveRecord::Base
  belongs_to :user
  validates_numericality_of :user_id
  validate :is_rss?
  validate :has_user_id?

  #TODO
  def is_rss?
    errors.add(:link, "不是可用的rss链接") if link.blank?
  end

  def has_user_id?
    errors.add(:user_id, "不存在这个用户") unless User.find(:first, :conditions => ["id = ?",user_id])
  end

end
