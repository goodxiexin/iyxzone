class PostCounterObserver < ActiveRecord::Observer

	observe :post
	
	def after_create post
		post.forum.increment! :posts_count
	end

end
