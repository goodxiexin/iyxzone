class FriendshipFeedObserver < ActiveRecord::Observer

	observe :friendship

	def after_update friendship
		if friendship.status_was == 0 and friendship.status == 1
			recipients = [friendship.user.profile]
			recipients.concat friendship.user.friends
			friendship.deliver_feeds :recipients => recipients, :data => {:friend => friendship.user_id}
			recipients = [friendship.friend.profile]
			recipients.concat friendship.friend.friends
			friendship.deliver_feeds :recipients => recipients, :data => {:friend => friendship.friend_id}
		end
	end

end
