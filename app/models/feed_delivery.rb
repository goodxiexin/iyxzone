class FeedDelivery < ActiveRecord::Base

	belongs_to :feed_item

	belongs_to :recipient, :polymorphic => true

  named_scope :category, lambda {|type|
    type = type.to_s
    if type == 'all'
      {}
    else
      {:conditions => {:item_type => type.camelize}}
    end
  } 

  def is_deleteable_by? user
    recipient.is_feed_deleteable_by? user, self
  end

end
