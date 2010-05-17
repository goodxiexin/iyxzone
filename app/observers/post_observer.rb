require 'app/mailer/guild_mailer'

class PostObserver < ActiveRecord::Observer

  # TODO: 并发的时候肯定有问题，应该从mysql的层次解决这个问题
  def before_create post
    # veirfy
    post.auto_verify

    topic = post.topic
    latest_post = topic.posts.find(:first, :order => 'floor DESC')
    if latest_post.nil?
      post.floor = 1
    else
      post.floor = latest_post.floor + 1
    end
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

  def before_update post
    post.auto_verify
  end

  def after_update post
    if post.recently_unverified
      post.topic.raw_decrement :posts_count
      post.forum.raw_decrement :posts_count
    elsif post.recently_recovered
      post.topic.raw_increment :posts_count
      post.forum.raw_increment :posts_count
    end  
  end

  def after_destroy post
    post.forum.raw_decrement :posts_count
    post.topic.raw_decrement :posts_count
  end

end
