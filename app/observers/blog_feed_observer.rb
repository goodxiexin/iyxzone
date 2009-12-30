class BlogFeedObserver < ActiveRecord::Observer

	observe :blog

  def after_create(blog)
		return if blog.draft
		return unless blog.poster.application_setting.emit_blog_feed
		return if blog.privilege == 4 # only for myself
		recipients = [].concat blog.poster.guilds
		recipients.concat blog.poster.friends.find_all{|f| f.application_setting.recv_blog_feed}
		blog.deliver_feeds :recipients => recipients
	end

  def after_update(blog)
    return if blog.draft
		if blog.draft_was
      # from draft to blog
      return if blog.privilege == 4
      return unless blog.poster.application_setting.emit_blog_feed
			recipients = [].concat blog.poster.guilds
			recipients.concat blog.poster.friends.find_all{|f| f.application_setting.recv_blog_feed}
			blog.deliver_feeds :recipients => recipients
		else
      # from blog to blog
      blog.destroy_feeds if blog.privilege == 4 and blog.privilege_was != 4
    end
  end

end
