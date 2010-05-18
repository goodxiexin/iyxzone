class TopicObserver < ActiveRecord::Observer

  def before_create topic
    topic.auto_verify
  end

  def after_create topic
    topic.forum.raw_increment :topics_count
  end

  def after_update topic
    if topic.recently_unverified
      topic.forum.raw_decrement :topics_count
      topic.forum.raw_decrement :posts_count, topic.posts_count
      Topic.update_all("posts_count = 0", {:id => topic.id})
      Post.unverify_all(:topic_id => topic.id)
    elsif topic.recently_recovered
      topic.forum.raw_increment :topics_count
      topic.forum.raw_increment :posts_count, topic.posts_count
      Topic.update_all("posts_count = #{topic.posts.count}", {:id => topic.id})
      Post.verify_all(:topic_id => topic.id)
    end
  end

  def after_destroy topic
    if !topic.rejected?
      topic.forum.raw_decrement :topics_count
    end
  end

end
