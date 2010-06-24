require 'test_helper'

class NotificationTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @friend = UserFactory.create
    @friend_character = GameCharacterFactory.create :game_id => @character.game_id, :user_id => @friend.id
    @stranger = UserFactory.create
    @stranger_character = GameCharacterFactory.create :game_id => @character.game_id, :user_id => @stranger.id

    FriendFactory.create @user, @friend
  end

  test "合法性" do
    notification1 = Notification.create(:user_id => nil, :data => 'd', :category => 1)
    assert !notification1.save

    notification2 = Notification.create(:user_id => @user.id, :data => nil, :category => 1)
    assert !notification2.save
		
    notification3 = Notification.create(:user_id => @user.id, :data => 'haha', :category => nil)
    assert !notification3.save
		
    notification4 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 1)
    assert notification4.save
  end

  test "好友请求" do
		# 拒绝好友请求
		friendship2 = Friendship.create(:friend_id => @user.id, :user_id => @stranger.id, :status => 0)
    assert_no_difference "@user.reload.notifications_count" do
			assert_no_difference "@user.reload.unread_notifications_count" do
				assert_difference "@stranger.reload.notifications_count" do
					assert_difference "@stranger.reload.unread_notifications_count" do
						friendship2.decline
					end
				end
			end
		end

		assert_equal @stranger.notifications.first.category, 0

		assert_no_difference "@stranger.notifications_count" do
			assert_difference "@stranger.unread_notifications_count", -1 do
				Notification.read [@stranger.notifications.first], @stranger
			end
		end

		# 同意好友请求
		friendship1 = Friendship.create(:friend_id => @user.id, :user_id => @stranger.id, :status => 0)
    assert_no_difference "@user.reload.notifications_count" do
			assert_no_difference "@user.reload.unread_notifications_count" do
				assert_difference "@stranger.reload.notifications_count" do
					assert_difference "@stranger.reload.unread_notifications_count" do
						friendship1.accept
					end
				end
			end
		end
		
		assert_no_difference "@stranger.notifications_count" do
			assert_difference "@stranger.reload.unread_notifications_count", -1 do
				Notification.read_all @stranger
			end
		end

		# 绝交
    friendship3 = @user.friendships.find_by_friend_id(@friend.id)

    assert_no_difference "@user.reload.notifications_count" do
			assert_no_difference "@user.reload.unread_notifications_count" do
				assert_difference "@friend.reload.notifications_count" do
					assert_difference "@friend.reload.unread_notifications_count" do
						friendship3.cancel
					end
				end
			end
		end
  end  

	test "标记标签通知" do
    assert_difference "@user.reload.notifications_count" do
			assert_difference "@user.reload.unread_notifications_count" do
				@user.profile.add_tag @friend, "2b"
			end
		end
		assert_equal @user.notifications.first.category, 1
	end

  test "活动通知" do
    @event = EventFactory.create :character_id => @friend_character.id

    @event.invite [@character]
		@invitation = @event.invitations.last

    assert_difference "@friend.reload.notifications_count" do
			assert_difference "@friend.reload.unread_notifications_count" do
        @invitation.accept_invitation Participation::Confirmed
			end
		end
		assert_equal @friend.notifications.first.category, 5
		
		# 拒绝请求
		@request = @event.requests.create :participant_id => @stranger.id, :character_id => @stranger_character.id 

    assert_difference "@stranger.reload.notifications_count" do
			assert_difference "@stranger.reload.unread_notifications_count" do
        @request.decline_request
			end
		end
		assert_equal @stranger.notifications.first.category, 5
		sleep 1

		# 同意请求
		@request = @event.requests.create :participant_id => @stranger.id, :character_id => @stranger_character.id 

    assert_difference "@stranger.reload.notifications_count" do
			assert_difference "@stranger.reload.unread_notifications_count" do
        @request.accept_request
			end
		end
		assert_equal @stranger.notifications.first.category, 5

		# 某人改变了状态
    assert_difference "@friend.reload.notifications_count" do
			assert_difference "@friend.reload.unread_notifications_count" do
				@invitation.change_status Participation::Maybe
			end
		end
		assert_equal @friend.notifications.first.category, 4

		# 改变时间
    assert_difference "@user.reload.notifications_count" do
			assert_difference "@user.reload.unread_notifications_count" do
				@event.update_attributes(:end_time => 9.days.from_now)
			end
		end
		assert_equal @user.notifications.first.category, 3
		sleep 1

		# 取消活动
    assert_difference "@user.reload.notifications_count" do
			assert_difference "@user.reload.unread_notifications_count" do
				@event.destroy
			end
		end
		assert_equal @user.notifications.first.category, 2

  end

	test "公会相关通知" do
    @guild = GuildFactory.create :character_id => @friend_character.id

    @guild.invite [@character]
    @invitation = @guild.invitations.last
		# 拒绝公会邀请
    assert_difference "@friend.reload.notifications_count" do
			assert_difference "@friend.reload.unread_notifications_count" do
				@invitation.decline_invitation
			end
		end
		assert_equal @friend.notifications.first.category, 6
		sleep 1

    @guild.invite [@character]
    @membership = @guild.invitations.last
		# 同意公会邀请
    assert_difference "@friend.reload.notifications_count" do
			assert_difference "@friend.reload.unread_notifications_count" do
				@membership.accept_invitation
			end
		end
		assert_equal @friend.notifications.first.category, 6

		# 拒绝请求
		@request = @guild.requests.create :user_id => @stranger.id, :character_id => @stranger_character.id 

    assert_difference "@stranger.reload.notifications_count" do
			assert_difference "@stranger.reload.unread_notifications_count" do
        @request.decline_request
			end
		end
		assert_equal @stranger.notifications.first.category, 6
		sleep 1

		# 同意请求
		@request = @guild.requests.create :user_id => @stranger.id, :character_id => @stranger_character.id 

    assert_difference "@stranger.reload.notifications_count" do
			assert_difference "@stranger.reload.unread_notifications_count" do
        @request.accept_request
			end
		end
		assert_equal @stranger.notifications.first.category, 6
		
		# 换职位
    assert_difference "@user.reload.notifications_count" do
			assert_difference "@user.reload.unread_notifications_count" do
        @membership.change_role Membership::Veteran
			end
		end
		assert_equal @user.notifications.first.category, 7
		sleep 1

		# 删除公会
    assert_difference "@user.reload.notifications_count" do
			assert_difference "@user.reload.unread_notifications_count" do
        @guild.destroy
			end
		end
		assert_equal @user.notifications.first.category, Notification::GuildCancel

	end

end
