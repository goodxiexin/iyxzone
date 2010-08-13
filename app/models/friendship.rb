class Friendship < ActiveRecord::Base

  belongs_to :user

  belongs_to :friend, :class_name => 'User'

	acts_as_resource_feeds

	Request	= 0
	Friend	= 1

  def is_request?
    status == Request
  end

  def was_request?
    status_was == Request
  end

  def is_friend?
    status == Friend
  end

  def was_friend?
    status_was == Friend
  end

  def reverse
    Friendship.match(:user_id => friend_id, :friend_id => user_id, :status => status).first
  end

  def recently_declined?
    @action == :recently_declined
  end

  def recently_cancelled?
    @action == :recently_cancelled
  end

  def accept
    if status == Request
      reverse_request = self.reverse # 是否双方都发送了请求
      reverse_request.destroy if reverse_request
      self.update_attributes(:status => Friend)
      Friendship.create(:user_id => friend_id, :friend_id => user_id, :status => Friend)
    end
  end

  def decline
    if status == Request
      # 拒绝请求也是删除，但是这个删除要和一般的删除（比如accept里的）区分开来
      @action = :recently_declined
      self.destroy
    end
  end

  def cancel
    if status == Friend
      @action = :recently_cancelled
      self.destroy
      reverse_friendship = self.reverse
      reverse_friendship.destroy if reverse_friendship
    end
  end

  attr_readonly :user_id, :friend_id

  validates_presence_of :user_id, :friend_id, :on => :create

  validate_on_create :friend_is_valid

  validates_inclusion_of :status, :in => [Request, Friend]

  validate_on_update :status_is_valid

protected

  def friend_is_valid
    return if user.blank? or friend.blank?
    friendship = user.all_friendships.find_by_friend_id(friend_id)

    if user == friend
      errors.add(:friend_id, "不能加自己")
    elsif friendship.blank?
    elsif friendship.is_request?
    elsif friendship.is_friend?
      errors.add(:friend_id, "已经是好友了")
    end
  end

  def status_is_valid
    return if status.blank?
    errors.add(:status, "不能更新为请求") if is_request?
  end

end
