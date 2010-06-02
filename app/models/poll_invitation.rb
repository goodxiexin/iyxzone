class PollInvitation < ActiveRecord::Base

	belongs_to :user, :counter_cache => true

	belongs_to :poll

  validates_presence_of :poll_id, :message => "不能为空"

  validates_presence_of :user_id, :message => "不能为空"

  validate_on_create :user_is_valid

protected

  def user_is_valid
    return if user_id.blank? or poll.blank?
    if poll.has_invited? user_id
      errors.add(:user_id, '已经邀请过了')
    elsif !poll.poster.has_friend? user_id
      errors.add(:user_id, '邀请的不是好友')
    end
  end

end
