#
# FriendTag就是blog, video的标签（谁和这个资源有关）
#

class FriendTag < ActiveRecord::Base

  belongs_to :tagged_user, :class_name => 'User'

  belongs_to :poster, :class_name => 'User'

  belongs_to :taggable, :polymorphic => true

	belongs_to :blog, :foreign_key => 'taggable_id'

	belongs_to :video, :foreign_key => 'taggable_id'

  produce_notices :relative => lambda {|tag| [tag.taggable_id, tag.taggable_type]}

  attr_readonly :poster_id, :tagged_user_id, :taggable_id, :taggable_type

  validates_presence_of :poster_id

  validate_on_create :taggable_is_valid

  validate_on_create :tagged_user_is_valid

protected

  def tagged_user_is_valid
    if tagged_user.blank?
      errors.add(:tagged_user, "不存在")
    elsif tagged_user != poster and !poster.has_friend?(tagged_user)
      errors.add(:tagged_user_id, "不是好友")
    end
  end

  def taggable_is_valid
    if taggable.blank?
      errors.add(:taggable_id, "不存在")
    elsif taggable.has_tag? tagged_user_id
      errors.add(:tagged_user_id, '已经标记过了')
    end
  end

end


