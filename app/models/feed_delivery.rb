class FeedDelivery < ActiveRecord::Base

	belongs_to :feed_item

	belongs_to :recipient, :polymorphic => true

  def is_deleteable_by? user
    recipient.is_feed_deleteable_by? user, self
  end

  def validate
    if recipient_id.blank? or recipient_type.blank?
      errors.add_to_base("没有接收者")
      return
    elsif recipient_type.constantize.find(:first, :conditions => {:id => recipient_id}).blank?
      errors.add_to_base("接收者不存在")
      return
    end

    if item_type.blank?
      errors.add_to_base("没有新鲜事类型")
      return
    end

    if feed_item_id.blank?
      errors.add_to_base("没有feed_item id")
      return
    end
  end

end
