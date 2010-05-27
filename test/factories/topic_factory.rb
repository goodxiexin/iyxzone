class TopicFactory

  def self.create cond
    if cond[:forum_id].blank?
      forum = GuildFactory.create.forum
    else
      forum = Forum.find(cond[:forum_id])
    end

    Factory.create :topic, {:forum_id => forum.id}.merge(cond) 
  end

end

class PostFactory

  def self.create cond
    if cond[:topic_id].blank?
      topic = TopicFactory.create
    else
      topic = Topic.find(cond[:topic_id])
    end

    Factory.create :post, {:topic_id => topic.id}.merge(cond)
  end

end
