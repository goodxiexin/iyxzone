class Post < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :forum

  belongs_to :topic, :counter_cache => true

	before_create :set_floor

protected

	def set_floor
		post = topic.posts.find(:first, :order => 'floor DESC')
		if post.nil?
			self.floor = 0
		else
			self.floor = post.floor + 1
		end
	end

end
