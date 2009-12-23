class Dig < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :diggable, :polymorphic => true, :counter_cache => true

  def validate_on_create
    errors.add_to_base('不能重复挖') if diggable.digged_by?(poster)
  end

end
