require 'app/mailer/tag_mailer'

class BlogObserver < ActiveRecord::Observer

  def before_create blog
    blog.auto_verify
  end

  def after_create blog
    # update counter
    if blog.draft
      blog.poster.raw_increment "drafts_count"
    else
      blog.poster.raw_increment "blogs_count#{blog.privilege}"
    end

    # check tasks
    # 不管该博客是什么权限的，只要不是草稿就可以
    if !blog.draft
      blog.poster.user_tasks.each { |t| t.notify_create blog }
    end

    # issue feeds
    if !blog.draft and blog.poster.application_setting.emit_blog_feed? and !blog.is_owner_privilege?
      blog.deliver_feeds
    end
  end

  def before_update blog
    blog.auto_verify
  end

  def after_update blog
    # 如果验证不通过，那需要减少计数器
    # 如果验证由不通过变成通过，那需要增加计数器
    if blog.recently_recovered
      if blog.draft
        blog.poster.raw_increment "drafts_count"
      else
        blog.poster.raw_increment "blogs_count#{blog.privilege}"
      end
      blog.deliver_feeds
    elsif blog.recently_rejected
      if blog.draft
        blog.poster.raw_decrement "drafts_count"
      else
        blog.poster.raw_decrement "blogs_count#{blog.privilege}"
      end
      blog.destroy_feeds
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

    # check tasks
    if blog.draft_was and !blog.draft
      blog.poster.user_tasks.each { |t| t.notify_create blog }
    end

    # issue feeds if necessary
    return if blog.draft
    if (blog.draft_was and !blog.is_owner_privilege?) or (blog.was_owner_privilege? and !blog.is_owner_privilege?)
      if blog.poster.application_setting.emit_blog_feed?
        blog.deliver_feeds
      end
    end

    # destroy feeds if necessary
    if !blog.was_owner_privilege? and blog.is_owner_privilege?
      blog.destroy_feeds      
    end 
  end

	def after_destroy blog
    # 如果验证没通过，计数器都不需要修改
    if !blog.rejected?    
      if blog.draft
        blog.poster.raw_decrement "drafts_count"
      else
        blog.poster.raw_decrement "blogs_count#{blog.privilege}"
      end
    end
	end
	
end
