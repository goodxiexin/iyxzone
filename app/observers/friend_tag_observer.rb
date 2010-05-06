class FriendTagObserver < ActiveRecord::Observer

  def after_create tag
    # increment counter
    tag.taggable.raw_increment :tags_count
  
    # issue notices and emails if necessary
    eval("after_#{tag.taggable_type.underscore}_tag_create(tag)")
  end

  def after_blog_tag_create tag
    blog = tag.taggable

    if !blog.draft and !blog.is_owner_privilege? and blog.poster != tag.tagged_user
      tag.notices.create(:user_id => tag.tagged_user_id)
      TagMailer.deliver_blog_tag tag if tag.tagged_user.mail_setting.tag_me_in_blog == 1
    end
  end

  def after_video_tag_create tag
    video = tag.taggable

    if !video.is_owner_privilege? and video.poster != tag.tagged_user
      tag.notices.create(:user_id => tag.tagged_user_id) 
      TagMailer.deliver_video_tag tag if tag.tagged_user.mail_setting.tag_me_in_video == 1
    end
  end

  def after_destroy tag
    tag.taggable.raw_decrement :tags_count
  end

end
