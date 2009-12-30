class Friendship < ActiveRecord::Base

  belongs_to :user, :counter_cache => :friends_count

  belongs_to :friend, :class_name => 'User'

	acts_as_resource_feeds

	Request	= 0
	Friend	= 1

	def validate_on_create
		friendship = user.all_friendships.find_by_friend_id(friend_id)
		return if friendship.nil?
		if friendship.status == Friendship::Request
			errors.add_to_base('你已经申请加他为好友了')
		elsif friendship.status == Friendship::Friend
			errors.add_to_base('你们已经是好友了')
		end
	end

	def accept
		update_attribute('status', Friendship::Friend)
		Friendship.create(:user_id => friend_id, :friend_id => user_id, :status => Friendship::Friend)
	end

end
