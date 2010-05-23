class TaskRequirement

  attr_accessor :val

  def initialize val
    @val = val
  end

  def init_achievement achievement
  end

  def satisfy?
  end

  def notify_create resource, hash
  end

  def valid?
    true
  end

end

class BlogMoreThanRequirement < TaskRequirement

  def init_achievement achievement
    achievement[:blogs_count] = 0
  end

  def satisfy? achievement
    achievement[:blogs_count] > val
  end

  def notify_create resource, achievement
    return unless resource.is_a? Blog
    achievement[:blogs_count] = achievement[:blogs_count] + 1
  end

end

class CommentDifferentBlogsRequirement < TaskRequirement

  def init_achievement achievement
    achievement[:comment_blogs] = []
  end

  def satisfy? achievement
    achievement[:comment_blogs].count > val
  end

  def notify_create resource, achievement
    return unless resource.is_a? Comment
    return unless resource.commentable_type == 'Blog'
    if !achievement[:comment_blogs].include?(resource.commentable_id)
      achievement[:comment_blogs] << resource.commentable_id
    end
  end

end
