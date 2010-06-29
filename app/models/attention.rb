class Attention < ActiveRecord::Base

  belongs_to :follower, :class_name => 'User'

  belongs_to :attentionable, :polymorphic => true 

  attr_readonly :follower_id, :attentionable_id, :attentionable_type

  validates_presence_of :follower_id

  validate_on_create :attentionable_is_valid

protected

  def attentionable_is_valid
    if attentionable.blank?
      errors.add(:commentable_id, "不存在")
    elsif attentionable.followed_by?(follower)
      errors.add(:commentable_id, "已经关注了")
    end
  end

end
