class Notice < ActiveRecord::Base

	belongs_to :producer, :polymorphic => true # only for comment, and tag

	belongs_to :user

	named_scope :unread, :conditions => {:read => false}

	def has_same_source? notice
		return false if producer_type != notice.producer_type
		if producer_type == 'Comment'
			(producer.commentable_id == notice.producer.commentable_id) and (producer.commentable_type == notice.producer.commentable_type)
		elsif producer_type == 'FriendTag'
			(producer.taggable_id == notice.producer.taggable_id) and (producer.taggable_type == notice.producer.taggable_type)
		elsif producer_type == 'PhotoTag'
			(producer.photo_id == notice.producer.photo_id)
		end
	end

end
