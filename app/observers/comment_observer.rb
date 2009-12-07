require 'app/mailer/comment_mailer'

class CommentObserver < ActiveRecord::Observer

  def after_create(comment)
    resource_type = comment.commentable_type.downcase
    eval("after_#{resource_type}_comment_create(comment)")
  end  

  def after_blog_comment_create(comment)
    blog = comment.commentable
    return if blog.privilege == 4
		poster = blog.poster
		commentor = comment.poster
		recipient = comment.recipient
		
		if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => "comment") 
			#comment.notifications.create(:data => "#{profile_link commentor}对你的博客#{blog_link blog}发表了评论", :user_id => poster.id)
      CommentMailer.deliver_blog_comment(comment, poster) if poster.mail_setting.comment_my_blog
    end
    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => "reply")
			#comment.notifications.create(:data => "#{profile_link commentor}在博客#{blog_link blog}回复了你", :user_id => recipient.id) 
      CommentMailer.deliver_blog_comment(comment, recipient) if recipient.mail_setting.comment_same_blog_after_me
    end

    blog.relative_users.each do |friend|
			if  friend != recipient and friend != poster and friend != commentor
				comment.notices.create(:user_id => friend.id, :data => 'tag')
        #comment.notifications.create(:data => "#{profile_link commentor}对和你有关的博客#{blog_link blog}进行了评论", :user_id => friend.id)
        CommentMailer.deliver_blog_comment_to_tagged_user(comment, friend) if friend.mail_setting.comment_blog_contains_me
      end
    end
  end

  def after_video_comment_create(comment)
		video = comment.commentable
    return if video.privilege == 4
    poster = video.poster
    commentor = comment.poster
    recipient = comment.recipient
    
    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      #comment.notifications.create(:data => "#{profile_link commentor}对你的视频#{video_link video}发表了评论", :user_id => poster.id)
      CommentMailer.deliver_video_comment(comment, poster) if poster.mail_setting.comment_my_video
    end
    if recipient != poster and recipient != commentor   
			comment.notices.create(:user_id => recipient.id, :data => 'reply')       
      #comment.notifications.create(:data => "#{profile_link commentor}在视频#{video_link video}回复了你", :user_id => recipient.id)
      CommentMailer.deliver_video_comment(comment, recipient) if recipient.mail_setting.comment_same_video_after_me
    end

    video.relative_users.each do |friend|
      if  friend != recipient and friend != poster and friend != commentor
				comment.notices.create(:user_id => friend.id, :data => 'tag')
        #comment.notifications.create(:data => "#{profile_link commentor}对和你有关的视频#{video_link video}进行了评论", :user_id => friend.id)
        CommentMailer.deliver_video_comment_to_tagged_user(comment, friend) if friend.mail_setting.comment_video_contains_me
      end
    end
	end

  def after_photo_comment_create(comment)
		photo = comment.commentable
    return if photo.privilege == 4
		album = photo.album
		poster = photo.poster # usually, photo poster is equal to album poster except the cases: event album, guild album
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      #comment.notifications.create(:data => "#{profile_link commentor}对照片#{photo_link photo}发表了评论", :user_id => poster.id)
      CommentMailer.deliver_photo_comment(comment, poster) if poster.mail_setting.comment_my_photo
    end
    if !recipient.nil? and recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      #comment.notifications.create(:data => "#{profile_link commentor}在照片#{photo_link photo}回复了你", :user_id => recipient.id)
      CommentMailer.deliver_photo_comment(comment, recipient) if recipient.mail_setting.comment_same_photo_after_me
    end

    photo.relative_users.each do |friend|
      if  friend != recipient and friend != poster and friend != commentor
				comment.notices.create(:user_id => friend.id, :data => 'tag')
        #comment.notifications.create(:data => "#{profile_link commentor}对和你有关的照片#{photo_link photo}进行了评论", :user_id => friend.id)
        CommentMailer.deliver_photo_comment_to_tagged_user(comment, friend) if friend.mail_setting.comment_photo_contains_me
      end
    end	
	end

	def after_album_comment_create(comment)
	  album = comment.commentable
    return if album.privilege == 4
    poster = album.poster
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor 
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      #comment.notifications.create(:data => "#{profile_link commentor}对你的相册#{album_link album}发表了评论", :user_id => poster.id)
      CommentMailer.deliver_album_comment(comment, poster) if poster.mail_setting.comment_my_album
    end
    if !recipient.nil? and recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      #comment.notifications.create(:data => "#{profile_link commentor}在相册#{album_link album}回复了你", :user_id => recipient.id)
      CommentMailer.deliver_album_comment(comment, recipient) if recipient.mail_setting.comment_same_album_after_me
    end
	end

  def after_status_comment_create(comment)
		status = comment.commentable
    poster = status.poster
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      #comment.notifications.create(:data => "#{profile_link commentor}对你的状态#{status_link status}发表了评论", :user_id => poster.id)
      CommentMailer.deliver_status_comment(comment, poster) if poster.mail_setting.comment_my_status
    end
    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      #comment.notifications.create(:data => "#{profile_link commentor}在#{profile_link poster}的状态#{status_link status}里回复了你", :user_id => recipient.id)
      CommentMailer.deliver_status_comment(comment, recipient) if recipient.mail_setting.comment_same_status_after_me
    end
	end

	def after_poll_comment_create(comment)
	  poll = comment.commentable
    poster = poll.poster
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      #poster.notifications.create(:data => "#{profile_link commentor}对你的投票#{poll_link poll}发表了评论")
      CommentMailer.deliver_poll_comment(comment, poster) if poster.mail_setting.comment_my_poll
    end
    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      #recipient.notifications.create(:data => "#{profile_link commentor}在投票#{poll_link poll}回复了你")
      CommentMailer.deliver_poll_comment(comment, recipient) if recipient.mail_setting.comment_same_poll_after_me
    end
	end

	def after_event_comment_create(comment)
	  event = comment.commentable
    poster = event.poster
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor 
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      #poster.notifications.create(:data => "#{profile_link commentor}对活动#{event_link event}里留言了")
      CommentMailer.deliver_event_comment(comment, poster) if poster.mail_setting.comment_my_event
    end
    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      #recipient.notifications.create(:data => "#{profile_link commentor}在活动#{event_link event}的留言版上回复了你")
      CommentMailer.deliver_event_comment(comment, recipient) if recipient.mail_setting.comment_same_event_after_me
    end
	end

	def after_guild_comment_create(comment)
		guild = comment.commentable
    poster = guild.president
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor and (!comment.whisper or recipient == poster)
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      #poster.notifications.create(:data => "#{profile_link commentor}在工会#{guild_link guild}里留言了")
      CommentMailer.deliver_guild_comment(comment, poster) if poster.mail_setting.comment_my_guild
    end

    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      #recipient.notifications.create(:data => "#{profile_link commentor}在工会#{guild_link guild}留言版上回复了你")
      CommentMailer.deliver_guild_comment(comment, recipient) if recipient.mail_setting.comment_same_guild_after_me
    end
	end

	def after_profile_comment_create(comment)
    profile = comment.commentable
    poster = profile.user
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      #poster.notifications.create(:data => "#{profile_link commentor}在你的#{profile_wall_link profile}里留言了")
      CommentMailer.deliver_profile_comment(comment, poster) if poster.mail_setting.comment_my_profile
    end
    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      #recipient.notifications.create(:data => "#{profile_link commentor}在#{profile_link poster}的#{guild_link guild}上回复了你")
      CommentMailer.deliver_profile_comment(comment, recipient) if recipient.mail_setting.comment_same_profile_after_me
    end
  end

	def after_game_comment_create comment
	end

end
