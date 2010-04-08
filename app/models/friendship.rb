class Friendship < ActiveRecord::Base

  belongs_to :user

  belongs_to :friend, :class_name => 'User'

	acts_as_resource_feeds

	Request	= 0
	Friend	= 1

  def is_request?
    status == Friendship::Request
  end

  def was_request?
    status_was == Friendship::Request
  end

  def is_friend?
    status == Friendship::Friend
  end

  def was_friend?
    status_was == Friendship::Friend
  end

  def reverse
    Friendship.find_or_create(:user_id => friend_id, :friend_id => user_id, :status => status)
  end

  attr_accessor :recently_accepted

  attr_accessor :recently_declined

  attr_accessor :recently_destroyed

  def accept
    if status == Request
      self.recently_accepted = true
      self.update_attributes(:status => Friendship::Friend)
    end
  end

  def decline
    if status == Request
      self.recently_declined = true
      self.destroy
    end
  end

  def cancel
    if status == Friend
      self.recently_destroyed = true
      self.destroy
    end
  end

  attr_readonly :user_id, :friend_id

  validates_presence_of :user_id, :friend_id, :message => "不能为空", :on => :create

  validate_on_create :friend_is_valid

  validates_inclusion_of :status, :in => [Request, Friend], :message => "只能是1,2"

  validate_on_update :status_is_valid

protected

  def friend_is_valid
    return if user.blank? or friend.blank?
    friendship = user.all_friendships.find_by_friend_id(friend_id)
    if friendship.blank?
=begin
      unless friend.is_friendable_by? user
        errors.add(:friend_id, "不能加为好友")
      end
=end
    else
      if friendship.is_request?
        errors.add(:friend_id, "不能重复向同一个人发送请求")
      else
        errors.add(:friend_id, "已经是好友了")
      end
    end
  end

  def status_is_valid
    return if status.blank?
    errors.add(:status, "不能更新为请求") if is_request?
  end

end
