require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase

  def setup
    @user1 = UserFactory.create
    @user2 = UserFactory.create
  end

  test "association" do
    FriendFactory.create @user1, @user2
    @user1.reload and @user2.reload
 
    assert_equal @user1.friend_ids, [@user2.id]
    assert @user1.friends.include? @user2
    assert_equal @user2.friend_ids, [@user1.id]
    assert @user2.friends.include? @user1
  end
  
  test "create request" do
    assert_difference "Email.count" do
      @request = Friendship.create :user_id => @user1.id, :friend_id => @user2.id, :status => Friendship::Request
    end

    @user1.reload and @user2.reload
    assert_equal @user2.friend_requests_count, 1
    assert_equal @user2.friend_requests, [@request]

    assert_no_difference "Friendship.count" do
      @request = Friendship.create :user_id => @user1.id, :friend_id => @user2.id, :status => Friendship::Request
    end

    assert_difference "Email.count" do
      @request = Friendship.create :user_id => @user2.id, :friend_id => @user1.id, :status => Friendship::Request
    end

    @user1.reload and @user2.reload
    assert_equal @user1.friend_requests_count, 1
    assert_equal @user1.friend_requests, [@request]

    assert_no_difference "Friendship.count" do
      @request = Friendship.create :user_id => @user2.id, :friend_id => @user1.id, :status => Friendship::Request
    end
  end

  test "accept/decline request" do
    assert_difference "Email.count" do
      @request = Friendship.create :user_id => @user1.id, :friend_id => @user2.id, :status => Friendship::Request
    end

    @user1.reload and @user2.reload
    assert_equal @user1.friends_count, 0
    assert_equal @user2.friends_count, 0
    assert_equal @user2.friend_requests_count, 1

    assert_difference "Notification.count" do
      @request.decline
    end

    @user1.reload and @user2.reload
    assert_equal @user1.friends_count, 0
    assert_equal @user2.friends_count, 0
    assert_equal @user2.friend_requests_count, 0

    assert_difference "Email.count" do
      @request = Friendship.create :user_id => @user1.id, :friend_id => @user2.id, :status => Friendship::Request
    end

    assert_difference ["Email.count", "Notification.count"] do
      @request.accept
    end

    @user1.reload and @user2.reload
    assert_equal @user1.friends_count, 1
    assert_equal @user2.friends_count, 1
    assert_equal @user2.friend_requests_count, 0
  end
 
  test "biodirection request, then accept/decline" do
    @request1 = Friendship.create :user_id => @user1.id, :friend_id => @user2.id, :status => Friendship::Request
    @request2 = Friendship.create :user_id => @user2.id, :friend_id => @user1.id, :status => Friendship::Request

    @user1.reload and @user2.reload
    assert_equal @user1.friends_count, 0
    assert_equal @user2.friends_count, 0
    assert_equal @user1.friend_requests_count, 1
    assert_equal @user2.friend_requests_count, 1
  
    assert_difference "Friendship.count", -1 do
      @request1.decline
    end

    @request1 = Friendship.create :user_id => @user1.id, :friend_id => @user2.id, :status => Friendship::Request

    # 请求被删掉，同时新的friendship建立
    assert_no_difference "Friendship.count" do
      @request1.accept
    end

    assert_nil Friendship.find_by_id(@request2.id)

    @user1.reload and @user2.reload
    assert_equal @user1.friends_count, 1
    assert_equal @user2.friends_count, 1
    assert_equal @user1.friend_requests_count, 0
    assert_equal @user2.friend_requests_count, 0
  end

end
