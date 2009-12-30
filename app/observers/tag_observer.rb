require 'app/mailer/tag_mailer'

class TagObserver < ActiveRecord::Observer

  observe :FriendTag, :PhotoTag

  def after_save(tag)
		if tag.class.to_s == 'PhotoTag'
			after_photo_tag_save(tag)
		else
			eval("after_#{tag.taggable_type.underscore}_tag_save(tag)")
		end
  end

  def after_photo_tag_save(tag)
    photo = tag.photo
    album = photo.album
	
		return if album.privilege == 4 # return if this album is only accessible to owner

		if tag.poster_id != tag.tagged_user_id
			tag.notices.create(:user_id => tag.tagged_user_id)
			#tag.notifications.create(:data => "#{profile_link tag.poster} 在相册 #{album_link album} 里标记了你", :user_id => tag.tagged_user_id)
			TagMailer.deliver_photo_tag tag if tag.tagged_user.mail_setting.tag_me_in_photo
    end
		if album.poster_id != tag.tagged_user_id and album.poster_id != tag.poster_id
      tag.notices.create(:user_id => album.poster_id)
			#tag.notifications.create(:data => "#{profile_link tag.poster} 标记了你的相册 #{album_link album}", :user_id => album.poster_id)
      TagMailer.deliver_photo_tag_to_owner tag if album.poster.mail_setting.tag_my_photo
    end  
  end

  def after_blog_tag_save(tag)
    return if tag.taggable.draft
		return if tag.taggable.privilege == 4 # return if this blog is only open for owner
    tag.notices.create(:user_id => tag.tagged_user_id)
		#tag.notifications.create(:data => "#{profile_link tag.poster} 在博客 #{blog_link tag.taggable} 里标记了你", :user_id => tag.tagged_user_id)
    TagMailer.deliver_blog_tag tag if tag.tagged_user.mail_setting.tag_me_in_blog
  end

  def after_video_tag_save(tag)
		return if tag.taggable.privilege == 4 # return if this video is only open for owner
		tag.notices.create(:user_id => tag.tagged_user_id)
    #tag.notifications.create(:data => "#{profile_link tag.poster} 在视频 #{video_link tag.taggable} 里标记了你", :user_id => tag.tagged_user_id)
    TagMailer.deliver_video_tag tag if tag.tagged_user.mail_setting.tag_me_in_video
  end

end
