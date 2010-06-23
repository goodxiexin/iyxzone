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

    @president = UserFactory.create
    @president_character = GameCharacterFactory.create :game_id => @character.game_id, :user_id => @president.id
		@guild = GuildFactory.create :character_id => @president_character.id

  end
#=begin
  test "合法性" do
    notification1 = Notification.create(:user_id => nil, :data => 'd', :category => 1)
    assert !notification1.save

    notification2 = Notification.create(:user_id => 2, :data => nil, :category => 1)
    assert !notification2.save
		
    notification3 = Notification.create(:user_id => 2, :data => 'haha', :category => nil)
    assert !notification3.save
		
    notification4 = Notification.create(:user_id => 2, :data => 'haha', :category => 1)
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
#=end
  test "活动通知" do
    @event = EventFactory.create :character_id => @friend_character.id

		participation = @event.maybe_participations.create :participant_id => @user.id, :character_id => @character.id
		
		# 某人改变了状态
    assert_difference "@friend.reload.notifications_count" do
			assert_difference "@friend.reload.unread_notifications_count" do
				participation.change_status Participation::Confirmed
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

		# 取消活动
    assert_difference "@user.reload.notifications_count" do
			assert_difference "@user.reload.unread_notifications_count" do
				@event.destroy
			end
		end
		assert_equal @user.notifications.second.category, 2

    #@e.update_attributes(:end_time => 4.days.from_now.to_s(:db))
  end

=begin

  test "拒绝活动请求" do
    setup_event

    @r.destroy
    @user3.reload
    assert_equal @user3.notifications_count, 1
    assert_equal @user3.unread_notifications_count, 1
    @user1.reload
    assert_equal @user1.notifications_count, 0
    assert_equal @user1.unread_notifications_count, 0
  end

  test "接受活动请求" do
    setup_event

    @r.accept
    @user3.reload
    assert_equal @user3.notifications_count, 1
    assert_equal @user3.unread_notifications_count, 1
    @user1.reload
    assert_equal @user1.notifications_count, 0
    assert_equal @user1.unread_notifications_count, 0
  end

  test "接受活动邀请" do
    setup_event

    @i.update_attributes(:status => 4)
    @user2.reload
    assert_equal @user3.notifications_count, 0
    assert_equal @user3.unread_notifications_count, 0
    @user1.reload
    assert_equal @user1.notifications_count, 1
    assert_equal @user1.unread_notifications_count, 1
  end

  test "拒绝工会请求" do
    setup_guild

    @r.destroy
    @user3.reload
    assert_equal @user3.notifications_count, 1
    assert_equal @user3.unread_notifications_count, 1
    @user1.reload
    assert_equal @user1.notifications_count, 0
    assert_equal @user1.unread_notifications_count, 0
  end

  test "接受工会请求" do
    setup_guild

    @r.accept_request
    @user3.reload
    assert_equal @user3.notifications_count, 1
    assert_equal @user3.unread_notifications_count, 1
    @user1.reload
    assert_equal @user1.notifications_count, 0
    assert_equal @user1.unread_notifications_count, 0
  end

  test "接受工会邀请" do
    setup_guild
    
    @i.accept_invitation
    @user2.reload
    assert_equal @user2.notifications_count, 0
    assert_equal @user2.unread_notifications_count, 0
    @user1.reload
    assert_equal @user1.notifications_count, 1
    assert_equal @user1.unread_notifications_count, 1
  end

  test "拒绝工会邀请" do
    setup_guild

    @i.destroy
    @user2.reload
    assert_equal @user2.notifications_count, 0
    assert_equal @user2.unread_notifications_count, 0
    @user1.reload
    assert_equal @user1.notifications_count, 1
    assert_equal @user1.unread_notifications_count, 1
  end
=end
end
