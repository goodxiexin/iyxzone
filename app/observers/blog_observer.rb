require 'app/mailer/tag_mailer'

class BlogObserver < ActiveRecord::Observer

  def before_create blog
    if blog.sensitive?
      blog.verified = 0
    else
      blog.verified = 1
    end
  end

  def after_create blog
    # update counter
    if blog.draft
      blog.poster.raw_increment "drafts_count"
    else
      blog.poster.raw_increment "blogs_count#{blog.privilege}"
    end

    # issue feeds
    if !blog.draft and blog.poster.application_setting.emit_blog_feed == 1 and !blog.is_owner_privilege?
      blog.deliver_feeds
    end
  end

  def before_update blog
    if blog.sensitive_columns_changed? and blog.sensitive?
      blog.verified = 0
    end
  end

  def after_update blog
    # 如果验证不通过，那需要减少计数器
    # 如果验证由不通过变成通过，那需要增加计数器
    if blog.verified_changed?
      if blog.verified_was == 2 and blog.verified == 1
        if blog.draft
          blog.poster.raw_increment "drafts_count"
        else
          blog.poster.raw_increment "blogs_count#{blog.privilege}"
        end
        blog.deliver_feeds
      end
      if (blog.verified_was == 0 or blog.verified_was == 1) and blog.verified == 2
        if blog.draft
          blog.poster.raw_decrement "drafts_count"
        else
          blog.poster.raw_decrement "blogs_count#{blog.privilege}"
        end
        blog.destroy_feeds
      end
      return
    end

    # update counter if necessary
    if blog.draft_was
      if !blog.draft
			  blog.poster.raw_increment "blogs_count#{blog.privilege}"
			  blog.poster.raw_decrement :drafts_count
		  end
    else
      if blog.privilege_changed?
        blog.poster.raw_decrement "blogs_count#{blog.privilege_was}"
        blog.poster.raw_increment "blogs_count#{blog.privilege}"
      end
    end
    
    return if blog.draft

    # issue feeds if necessary
    if (blog.draft_was and blog.privilege != 4) or (blog.privilege_was == 4 and blog.privilege != 4)
      if blog.poster.application_setting.emit_blog_feed == 1
        blog.deliver_feeds
      end
    end

    # destroy feeds if necessary
    if blog.privilege_was != 4 and blog.privilege == 4
      blog.destroy_feeds      
    end 
  end

	def after_destroy blog
    # 如果验证没通过，计数器都不需要修改
    return if blog.verified == 2
    
    if blog.draft
      blog.poster.raw_decrement "drafts_count"
    else
      blog.poster.raw_decrement "blogs_count#{blog.privilege}"
    end
	end
	
end
