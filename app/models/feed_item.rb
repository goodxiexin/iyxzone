class FeedItem < ActiveRecord::Base

	serialize :data, Hash

	belongs_to :originator, :polymorphic => true

	has_many :deliveries, :class_name => 'FeedDelivery', :dependent => :destroy

  def validate
    if originator_type.blank? or originator_id.blank?
      errors.add_to_base("没有产生者")
    elsif originator_type.constantize.find(:first, :conditions => {:id => originator_id}).blank?
      errors.add_to_base("产生者不存在")
    end
  end  

end
