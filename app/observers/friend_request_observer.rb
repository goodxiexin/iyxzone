class FriendRequestObserver < ActiveRecord::Observer

  observe :friendship

	def after_create friendship
		if friendship.is_request? #status == Friendship::Request
			# request was created
			FriendshipMailer.deliver_request(friendship.user, friendship.friend) if friendship.friend.mail_setting.request_to_be_friend
			friendship.friend.raw_increment :requests_count
		end
	end

	def after_update friendship
		# intimate friends are not supported right now
		if friendship.was_request? and friendship.is_friend? #status_was == Friendship::Request and friendship.status == Friendship::Friend
			# request was accepted
			friendship.user.destroy_obsoleted_friend_suggestions friendship.friend
			friendship.user.destroy_obsoleted_comrade_suggestions friendship.friend
			friendship.friend.destroy_obsoleted_friend_suggestions friendship.user
      friendship.friend.destroy_obsoleted_comrade_suggestions friendship.user
			friendship.user.notifications.create(:data => "#{profile_link friendship.friend}同意了你的好友请求") 
			friendship.friend.raw_decrement! :requests_count
		end
	end

	def after_destroy friendship
		if friendship.is_request? #status == Friendship::Request
			# request was declined
			friendship.user.notifications.create(:data => "#{profile_link friendship.friend}决绝了你的好友请求")
			friendship.friend.raw_decrement! :requests_count
		elsif friendship.is_friend? #status == Friendship::Friend
			# cancel friendship
			friendship.friend.notifications.create(:data => "你和#{profile_link friendship.user}的好友关系解除了")
		end
	end

end
