class BlogCounterObserver < ActiveRecord::Observer

  observe :blog

  def after_create(blog)
		if blog.draft
			blog.poster.raw_increment :drafts_count
		else
			blog.poster.raw_increment :blogs_count
		end
	end

  def after_update(blog)
		if blog.draft_was and !blog.draft # from draft to blog
			blog.poster.raw_increment :blogs_count
			blog.poster.raw_decrement :drafts_count
		end
  end

	def after_destroy blog
		if blog.draft
			blog.poster.raw_decrement :drafts_count
		else
			blog.poster.raw_decrement :blogs_count
		end
	end
	
end
