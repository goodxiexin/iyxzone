require 'app/mailer/comment_mailer'

class CommentObserver < ActiveRecord::Observer

  def after_create comment
    # increment counter
    comment.commentable.raw_increment :comments_count
    
    # issue mail and notification
    eval("after_#{comment.commentable_type.underscore}_comment_create(comment)")
  end  

  def after_blog_comment_create comment
    blog = comment.commentable
    return if blog.is_owner_privilege?
		poster = blog.poster
		commentor = comment.poster
		recipient = comment.recipient
		
		if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => "comment") 
      CommentMailer.deliver_blog_comment_to_poster(comment, poster) if poster.mail_setting.comment_my_blog == 1
    end
    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => "reply")
      CommentMailer.deliver_blog_comment_to_recipient(comment, recipient) if recipient.mail_setting.comment_same_blog_after_me == 1
    end

    (blog.relative_users - [poster, commentor, recipient].uniq).each do |friend|
			if friend != recipient and friend != poster and friend != commentor
				comment.notices.create(:user_id => friend.id, :data => 'tag')
        CommentMailer.deliver_blog_comment_to_tagged_user(comment, friend) if friend.mail_setting.comment_blog_contains_me == 1
      end
    end
  end

  def after_video_comment_create(comment)
		video = comment.commentable
    return if video.is_owner_privilege?
    poster = video.poster
    commentor = comment.poster
    recipient = comment.recipient
    
    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      CommentMailer.deliver_video_comment_to_poster(comment, poster) if poster.mail_setting.comment_my_video == 1
    end
    if recipient != poster and recipient != commentor   
			comment.notices.create(:user_id => recipient.id, :data => 'reply')       
      CommentMailer.deliver_video_comment_to_recipient(comment, recipient) if recipient.mail_setting.comment_same_video_after_me == 1
    end

    (video.relative_users - [poster, commentor, recipient].uniq).each do |friend|
      if friend != recipient and friend != poster and friend != commentor
				comment.notices.create(:user_id => friend.id, :data => 'tag')
        CommentMailer.deliver_video_comment_to_tagged_user(comment, friend) if friend.mail_setting.comment_video_contains_me == 1
      end
    end
	end

  def after_avatar_comment_create comment
    after_photo_comment_create comment
  end

  def after_personal_photo_comment_create comment
    after_photo_comment_create comment
  end

  def after_event_photo_comment_create comment
    after_photo_comment_create comment
  end

  def after_guild_photo_comment_create comment
    after_photo_comment_create comment 
  end

  def after_photo_comment_create(comment)
		photo = comment.commentable
    return if photo.is_owner_privilege?
		album = photo.album
		poster = photo.poster # usually, photo poster is equal to album poster except the cases: event album, guild album
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      CommentMailer.deliver_photo_comment_to_poster(comment, poster) if poster.mail_setting.comment_my_photo == 1
    end
    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_photo_comment_to_recipient(comment, recipient) if recipient.mail_setting.comment_same_photo_after_me == 1
    end

    (photo.relative_users - [poster, commentor, recipient].uniq).each do |friend|
      if friend != recipient and friend != poster and friend != commentor
				comment.notices.create(:user_id => friend.id, :data => 'tag')
        CommentMailer.deliver_photo_comment_to_tagged_user(comment, friend) if friend.mail_setting.comment_photo_contains_me == 1
      end
    end	
	end

  def after_avatar_album_comment_create comment
    after_album_comment_create comment
  end

  def after_personal_album_comment_create comment
    after_album_comment_create comment
  end

  def after_event_album_comment_create comment
    after_album_comment_create comment
  end

  def after_guild_album_comment_create comment
    after_album_comment_create comment
  end

	def after_album_comment_create(comment)
	  album = comment.commentable
    return if album.is_owner_privilege?
    poster = album.poster
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor 
      comment.notices.create(:user_id => poster.id, :data => 'comment')
      CommentMailer.deliver_album_comment_to_poster(comment, poster) if poster.mail_setting.comment_my_album == 1
    end

    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_album_comment_to_recipient(comment, recipient) if recipient.mail_setting.comment_same_album_after_me == 1
    end
	end

  def after_status_comment_create(comment)
		status = comment.commentable
    poster = status.poster
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      CommentMailer.deliver_status_comment_to_poster(comment, poster) if poster.mail_setting.comment_my_status == 1
    end

    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_status_comment_to_recipient(comment, recipient) if recipient.mail_setting.comment_same_status_after_me == 1
    end
	end

	def after_poll_comment_create(comment)
	  poll = comment.commentable
    poster = poll.poster
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      CommentMailer.deliver_poll_comment_to_poster(comment, poster) if poster.mail_setting.comment_my_poll == 1
    end

    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_poll_comment_to_recipient(comment, recipient) if recipient.mail_setting.comment_same_poll_after_me == 1
    end
	end

	def after_event_comment_create(comment)
	  event = comment.commentable
    poster = event.poster
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor 
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      CommentMailer.deliver_event_comment_to_poster(comment, poster) if poster.mail_setting.comment_my_event == 1
    end

    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_event_comment_to_recipient(comment, recipient) if recipient.mail_setting.comment_same_event_after_me == 1
    end
	end

	def after_guild_comment_create(comment)
		guild = comment.commentable
    president = guild.president
    commentor = comment.poster
    recipient = comment.recipient
    
    if president != commentor
			comment.notices.create(:user_id => president.id, :data => 'comment')
      CommentMailer.deliver_guild_comment_to_president(comment, president) if president.mail_setting.comment_my_guild == 1
    end

    if recipient != president and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_guild_comment_to_recipient(comment, recipient) if recipient.mail_setting.comment_same_guild_after_me == 1
    end
	end

	def after_profile_comment_create(comment)
    profile = comment.commentable
    poster = profile.user
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor
			comment.notices.create(:user_id => poster.id, :data => 'comment')
      CommentMailer.deliver_profile_comment_to_poster(comment, poster) if poster.mail_setting.comment_my_profile == 1
    end

    if recipient != poster and recipient != commentor
			comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_profile_comment_to_recipient(comment, recipient) if recipient.mail_setting.comment_same_profile_after_me == 1
    end
  end

	def after_game_comment_create comment
    game = comment.commentable
    commentor = comment.poster
    recipient = comment.recipient

    if commentor != recipient and !recipient.blank?
      comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_game_comment comment, recipient if recipient.mail_setting.comment_same_game_after_me == 1
    end
	end

  def after_sharing_comment_create comment
    sharing = comment.commentable
    poster = sharing.poster
    commentor = comment.poster
    recipient = comment.recipient

    if poster != commentor
      comment.notices.create(:user_id => poster.id, :data => 'comment')
      CommentMailer.deliver_sharing_comment_to_poster comment, poster if poster.mail_setting.comment_my_sharing == 1
    end

    if recipient != poster and recipient != commentor and !recipient.blank?
      comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_sharing_comment_to_recipient comment, recipient if recipient.mail_setting.comment_same_sharing_after_me == 1
    end
  end

  def after_application_comment_create comment
    application = comment.commentable
    commentor = comment.poster
    recipient = comment.recipient

    if commentor != recipient and !recipient.blank?
      comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_application_comment comment, recipient if recipient.mail_setting.comment_same_application_after_me == 1
    end
  end

  def after_news_comment_create comment
    news = comment.commentable
    commentor = comment.poster
    recipient = comment.recipient

    if commentor != recipient and !recipient.blank?
      comment.notices.create(:user_id => recipient.id, :data => 'reply')
      CommentMailer.deliver_news_comment comment, recipient if recipient.mail_setting.comment_same_news_after_me == 1
    end
  end
  
  def after_destroy comment
    comment.commentable.raw_decrement :comments_count
  end

end
