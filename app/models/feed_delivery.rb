class FeedDelivery < ActiveRecord::Base

	belongs_to :feed_item

	belongs_to :recipient, :polymorphic => true

	def before_create
		expired_at = 1.week.from_now
	end

end
