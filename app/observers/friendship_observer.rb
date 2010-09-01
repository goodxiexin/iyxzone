require 'app/mailer/friendship_mailer'

class FriendshipObserver < ActiveRecord::Observer

	def after_create friendship
    user = friendship.user
    friend = friendship.friend

		if friendship.is_request?
      requests = Friendship.match(:status => Friendship::Request, :user_id => user.id, :friend_id => friend.id).all - [friendship]
      if requests.blank?
        FriendshipMailer.deliver_request(user, friend) if friend.mail_setting.request_to_be_friend?
      else
        requests.each {|r| r.destroy} # 只保留最新的，应该只有1个
      end
      friend.raw_increment :friend_requests_count
		elsif friendship.is_friend?
      user.raw_increment :friends_count 
    end
	end

	def after_update friendship
    user = friendship.user
    friend = friendship.friend

		if friendship.was_request? and friendship.is_friend?
      # delete some obsoleted friend/comrade suggestions
			user.destroy_obsoleted_friend_suggestions friend
			user.destroy_obsoleted_comrade_suggestions friend
			friend.destroy_obsoleted_friend_suggestions user
      friend.destroy_obsoleted_comrade_suggestions user

      # change counter
      friend.raw_decrement :friend_requests_count
      user.raw_increment :friends_count

      #if friendship.recently_accepted?
      # send notification
			user.notifications.create(:data => "#{profile_link friend}同意了你的好友请求", :category => Notification::Friend)
			
      # issue feeds
      recipients = [user.profile]
      recipients.concat user.friends.reject {|f| f == friend} # friendship.friend 刚刚成为好友
      friendship.deliver_feeds :recipients => recipients, :data => {:friend => user.id}
      recipients = [friend.profile]
      recipients.concat(friend.friends - user.friends)
      friendship.deliver_feeds :recipients => recipients, :data => {:friend => friend.id}
    
      # deliver mail
      FriendshipMailer.deliver_confirm(user, friend) if user.mail_setting.confirm_friend?
      #end
    end
	end

	def after_destroy friendship
    user = friendship.user
    friend = friendship.friend

    if friendship.is_request?
      friend.raw_decrement :friend_requests_count
      if friendship.recently_declined?
        user.notifications.create(:data => "#{profile_link friend}决绝了你的好友请求", :category => Notification::Friend)
      end
		elsif friendship.is_friend?
      user.raw_decrement :friends_count
      if friendship.recently_cancelled?
        friend.notifications.create(:data => "你和#{profile_link user}的好友关系解除了", :category => Notification::Friend)
      end
    end
	end

end
