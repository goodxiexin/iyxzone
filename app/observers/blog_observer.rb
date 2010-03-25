class BlogObserver < ActiveRecord::Observer

  def after_create blog
    # update counter
    if blog.draft
      blog.poster.raw_increment "drafts_count"
    else
      blog.poster.raw_increment "blogs_count#{blog.privilege}"
    end

    # issue feeds
    return if blog.draft
    return unless blog.poster.application_setting.emit_blog_feed
    return if blog.is_owner_privilege? # only for myself

    recipients = [].concat blog.poster.guilds
    recipients.concat blog.poster.friends.find_all{|f| f.application_setting.recv_blog_feed}
    blog.deliver_feeds :recipients => recipients
  end

  def before_update blog 
    if blog.title_changed? or blog.content_changed? # only title or content changed must update column 'verified'
      blog.verified = 0
    end
  end
  
  def after_update blog
    # update counter if necessary
    if blog.draft_was
      if !blog.draft
			  blog.poster.raw_increment "blogs_count#{blog.privilege}"
			  blog.poster.raw_decrement :drafts_count
		  end
    else
      blog.poster.raw_decrement "blogs_count#{blog.privilege_was}"
      blog.poster.raw_increment "blogs_count#{blog.privilege}"
    end
    
    # issue feeds if necessary
    return if blog.draft

    if (blog.draft_was and blog.privilege != 4) or (blog.privilege_was == 4 and blog.privilege != 4)
      return unless blog.poster.application_setting.emit_blog_feed
      recipients = [].concat blog.poster.guilds
      recipients.concat blog.poster.friends.find_all{|f| f.application_setting.recv_blog_feed}
      blog.deliver_feeds :recipients => recipients
    else
      blog.destroy_feeds if blog.is_owner_privilege? and blog.privilege_was != 4
    end 
  end

	def after_destroy blog
    if blog.draft
      blog.poster.raw_decrement "drafts_count"
    else
      blog.poster.raw_decrement "blogs_count#{blog.privilege}"
    end
	end
	
end
