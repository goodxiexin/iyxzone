require 'app/mailer/tag_mailer'

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
    return if blog.poster.application_setting.emit_blog_feed == 0
    return if blog.is_owner_privilege? # only for myself
    
    recipients = [].concat blog.poster.guilds
    recipients.concat blog.poster.friends.find_all{|f| f.application_setting.recv_blog_feed == 1}
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
    
    return if blog.draft

    # issue feeds if necessary
    if (blog.draft_was and blog.privilege != 4) or (blog.privilege_was == 4 and blog.privilege != 4)
      if blog.poster.application_setting.emit_blog_feed == 1
        recipients = [].concat blog.poster.guilds
        recipients.concat blog.poster.friends.find_all{|f| f.application_setting.recv_blog_feed == 1}
        blog.deliver_feeds :recipients => recipients
      end
# TODO: 左思右想，决定这个还是不要再发送了，重复不好，而且又有开销
=begin
      blog.tags.each do |tag|
        tag.notices.create(:user_id => tag.tagged_user_id)
        TagMailer.deliver_blog_tag tag if tag.tagged_user.mail_setting.tag_me_in_blog == 1
      end
=end
    end

    # destroy feeds if necessary
    if blog.privilege_was != 4 and blog.privilege == 4
      blog.destroy_feeds      
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
