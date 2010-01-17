class Friendship < ActiveRecord::Base

  belongs_to :user

  belongs_to :friend, :class_name => 'User'

  has_many :notifications, :as => 'notifier'

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

  def accept
    Friendship.transaction do
      self.update_attributes(:status => Friendship::Friend)
      Friendship.create(:user_id => friend_id, :friend_id => user_id, :status => Friendship::Friend)
    end
  rescue
    return false
  end
  
  def cancel
    Friendship.transaction do
      Friendship.find(:first, :conditions => {:user_id => friend_id, :friend_id => user_id}).destroy
      self.destroy
    end
  rescue
    return false
  end

  def validate
    if user_id.blank?
      errors.add_to_base('user_id不能为空')
      return
    end

    if friend_id.blank?
      errors.add_to_base('friend_id不能为空')
      return
    end

    if status.blank? 
      errors.add_to_base('状态不能为空')
    elsif !is_friend? and !is_request?
      errors.add_to_base('状态不对')
    end
  end

	def validate_on_create
    return unless errors.on_base.blank?

    friendship = user.all_friendships.find_by_friend_id(friend_id)
    if friendship.nil?
      #if is_friend?
      #  errors.add_to_base('不能直接加为好友')
      #end
    else
		  if friendship.is_request? 
			  errors.add_to_base('你已经申请加他为好友了')
		  elsif friendship.is_friend?
			  errors.add_to_base('你们已经是好友了')
		  end
    end
	end

  def validate_on_update
    return unless errors.on_base.blank?
    errors.add_to_base("不能更新为请求") if is_request?
  end

end
