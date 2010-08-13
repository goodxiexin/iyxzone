require 'app/mailer/friendship_mailer'

class FriendshipObserver < ActiveRecord::Observer

	def after_create friendship
		if friendship.is_request?
      requests = Friendship.match(:status => Friendship::Request, :user_id => friendship.user_id, :friend_id => friendship.friend_id).all - [friendship]
      if requests.blank?
        FriendshipMailer.deliver_request(friendship.user, friendship.friend) if friendship.friend.mail_setting.request_to_be_friend?
      else
        requests.each {|r| r.destroy} # 只保留最新的，应该只有1个
      end
      friendship.friend.raw_increment :friend_requests_count
		elsif friendship.is_friend?
      friendship.user.raw_increment :friends_count 
    end
	end

	def after_update friendship
		if friendship.was_request? and friendship.is_friend?
      # delete some obsoleted friend/comrade suggestions
			friendship.user.destroy_obsoleted_friend_suggestions friendship.friend
			friendship.user.destroy_obsoleted_comrade_suggestions friendship.friend
			friendship.friend.destroy_obsoleted_friend_suggestions friendship.user
      friendship.friend.destroy_obsoleted_comrade_suggestions friendship.user

      # change counter
      friendship.friend.raw_decrement :friend_requests_count
      friendship.user.raw_increment :friends_count

      #if friendship.recently_accepted?
      # send notification
			friendship.user.notifications.create(:data => "#{profile_link friendship.friend}同意了你的好友请求", :category => Notification::Friend)
			
      # issue feeds
      recipients = [friendship.user.profile]
      recipients.concat friendship.user.friends.reject {|f| f == friendship.friend} # friendship.friend 刚刚成为好友
      friendship.deliver_feeds :recipients => recipients, :data => {:friend => friendship.user_id}
      recipients = [friendship.friend.profile]
      recipients.concat(friendship.friend.friends - friendship.user.friends) # this prevents people from receiving same feed twice
      friendship.deliver_feeds :recipients => recipients, :data => {:friend => friendship.friend_id}
    
      # deliver mail
      FriendshipMailer.deliver_confirm(friendship.user, friendship.friend) if friendship.user.mail_setting.confirm_friend?
      #end
    end
	end

	def after_destroy friendship
    if friendship.is_request?
      friendship.friend.raw_decrement :friend_requests_count
      if friendship.recently_declined?
        friendship.user.notifications.create(:data => "#{profile_link friendship.friend}决绝了你的好友请求", :category => Notification::Friend)
      end
		elsif friendship.is_friend?
      friendship.user.raw_decrement :friends_count
      if friendship.recently_cancelled?
        friendship.friend.notifications.create(:data => "你和#{profile_link friendship.user}的好友关系解除了", :category => Notification::Friend)
      end
    end
	end

end
