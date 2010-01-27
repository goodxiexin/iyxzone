class Comment < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :recipient, :class_name => 'User'

  belongs_to :commentable, :polymorphic => true

	has_many :notices, :as => 'producer', :dependent => :destroy

  acts_as_emotion_text :columns => [:content]

  def is_deleteable_by? user
    commentable.is_comment_deleteable_by? user, self
  end

  def is_recipient_required?
    commentable.is_comment_recipient_required?
  end

  def validate
    if poster_id.blank?
      errors.add_to_base('没有发布者')
      return
    end

    if commentable_id.blank? or commentable_type.blank?
      errors.add_to_base('没有被评论的东西')
      return
    else
      commentable = commentable_type.camelize.constantize.find(:first, :conditions => {:id => commentable_id})
      if commentable.blank?
        errors.add_to_base('被评论的东西不存在')
        return
      elsif !commentable.is_commentable_by? poster
        errors.add_to_base('没有评论的权限')
        return
      end
    end
    
    if is_recipient_required? and recipient_id.blank?
      errors.add_to_base('没有接收的人')
    end

  end

end
