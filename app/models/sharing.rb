class Sharing < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :shareable, :polymorphic => true, :counter_cache => true

  acts_as_commentable :order => 'created_at ASC'

  acts_as_resource_feeds

  acts_as_diggable

  named_scope :hot, :conditions => ["created_at > ?", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC"

  named_scope :recent, :conditions => ["created_at >?", 2.weeks.ago.to_s(:db)], :order => "created_at DESC"

  def validate_on_create
    return if shareable_type == 'Link'
    if shareable.shared_by? poster
      errors.add_to_base('已经分享过了')
    end
  end

end
