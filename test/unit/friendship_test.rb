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
  
  #
  # case1
  # user1 请求加 user2 为好友，但不能重复发送
  # 此时, user2 还可以给user1发送好友请求，但也不能重复发送
  #
  test "case1" do
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

  #
  # case2
  # user1发送好友请求，user2先拒绝后接受
  #
  test "case2" do
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
 
  #
  # case3
  # 2人互相发送好友请求，1方拒绝，另一个请求还在
  # 如果1方接受，那另一方的请求会被删除
  #
  test "case3" do
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
