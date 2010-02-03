class Sharing < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :shareable, :polymorphic => true

  named_scope :hot, :conditions => ["created_at > ?", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC"

  named_scope :recent, :conditions => ["created_at >?", 2.weeks.ago.to_s(:db)], :order => "created_at DESC"

  acts_as_commentable :order => 'created_at ASC', :recipient_required => false

  acts_as_resource_feeds

  acts_as_diggable

  def validate_on_create
    if poster_id.blank?
      errors.add_to_base('没有发布者')
      return
    end

    if shareable_id.blank? or shareable_type.blank?
      errors.add_to_base('没有被分享的资源')
      return
    else
      shareable = shareable_type.constantize.find(:first, :conditions => {:id => shareable_id})
      if shareable.blank?
        errors.add_to_base('被分享的资源不存在')
        return
      elsif shareable.shared_by? poster
        errors.add_to_base('已经分享过了')
      end
    end
  end

end
