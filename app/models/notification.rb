class Notification < ActiveRecord::Base

	belongs_to :user

  named_scope :unread, :conditions => {:read => false}

  def self.read notifications, user
    return if notifications.blank?
    Notification.update_all("notifications.read = 1", {:id => notifications.map(&:id), :user_id => user.id})
    user.raw_decrement :unread_notifications_count, notifications.count
  end

  def self.read_all user
    Notification.update_all("notifications.read = 1", {:user_id => user.id})
    user.update_attribute(:unread_notifications_count, 0)
  end

  def validate
    if user_id.blank?
      errors.add_to_base("没有接受者")
      return
    end

    if data.blank?
      errors.add_to_base("没有内容")
      return
    end
    
    if category.blank?
      errors.add_to_base("没有类型")
    end
  end

end
