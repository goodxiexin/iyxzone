require 'app/mailer/guild_mailer'

class PostObserver < ActiveRecord::Observer

  def before_create post
    # veirfy
    post.auto_verify

    post.forum_id = post.topic.forum_id
    post.floor = post.topic.latest_floor
  end

  def after_create post
    # change counter
    post.forum.raw_increment :posts_count
    post.topic.raw_increment :posts_count
    
    # issue notice
    poster = post.poster
    recipient = post.recipient
    owner = post.topic.poster

    if poster != owner
      post.notices.create(:user_id => owner.id, :data => "comment")
      GuildMailer.deliver_reply_post post, owner if owner.mail_setting.reply_my_post?
    end

    if recipient != poster and recipient != owner
      post.notices.create(:user_id => recipient.id, :data => "reply")
      GuildMailer.deliver_reply_post post, recipient if recipient.mail_setting.reply_my_post?
    end  
  end

  def after_update post
    if post.recently_rejected?
      post.topic.raw_decrement :posts_count
      post.forum.raw_decrement :posts_count
    elsif post.recently_recovered?
      post.topic.raw_increment :posts_count
      post.forum.raw_increment :posts_count
    end  
  end

  def after_destroy post
    if !post.rejected?
      post.forum.raw_decrement :posts_count
      post.topic.raw_decrement :posts_count
    end
  end

end
