class Tagging < ActiveRecord::Base

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}}}

	belongs_to :taggable, :polymorphic => true

	belongs_to :tag

	belongs_to :poster, :class_name => 'User'

  attr_readonly :poster_id, :taggable_id, :taggable_type, :tag_id

  validates_presence_of :poster_id

  validate_on_create :taggable_is_valid

protected

  def taggable_is_valid
    if taggable.blank?
      errors.add(:taggable_id, "被标记的资源不存在")
    elsif poster and !taggable.is_taggable_by? poster
      errors.add(:taggable_id, "没有权限标记")
    end
  end

end
