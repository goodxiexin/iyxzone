class Dig < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :diggable, :polymorphic => true

  attr_readonly :poster_id, :diggable_id, :diggable_type

  validates_presence_of :poster_id

  validate_on_create :diggable_is_valid

protected
  
  def diggable_is_valid
    if diggable.blank?
      errors.add(:diggable_id, "不存在")
    elsif poster and diggable.digged_by?(poster)
      errors.add(:diggable_id, '已经挖过了')
    elsif poster and !diggable.is_diggable_by?(poster)
      errors.add(:diggable_id, '没有权限挖')
    end
  end

end
