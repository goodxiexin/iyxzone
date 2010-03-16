require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase

  def setup
    # @u 给 @f 发请求
    @u = UserFactory.create
    @f = UserFactory.create
  end

  test "请求发送后，@f的好友请求计数器加1" do
    f = FriendshipFactory.build_request @u, @f

    assert_difference "f.friend(true).friend_requests_count" do
      f.save
    end
  end

  test "请求被接受后，@f 的请求计数器减1" do
    f = FriendshipFactory.create_request @u, @f

    assert_difference "f.friend(true).friend_requests_count", -1 do
      f.accept
    end
  end

  test "请求被接受后，@f 和 @u 的好友计数器加1" do
    f = FriendshipFactory.create_request @u, @f

    assert_difference ["f.friend(true).friends_count", "f.user(true).friends_count"] do
      f.accept
    end
  end

  test "请求被拒绝后，@f 的好友请求计数器减一" do
    f = FriendshipFactory.create_request @u, @f

    assert_difference "f.friend(true).friend_requests_count", -1 do
      f.destroy
    end
  end

  test "请求被拒绝后，@f 和 @u 的好友计数器不变" do
    f = FriendshipFactory.create_request @u, @f

    assert_no_difference ["f.user(true).friends_count", "f.friend(true).friends_count"] do
      f.destroy 
    end
  end

  test "解除好友关系后，@u 和 @f 的好友计数器都减一" do
    f1, f2 = FriendshipFactory.create_friend @u, @f
    @u.reload and @f.reload
 
    assert_difference ["f1.user(true).friends_count", "f1.friend(true).friends_count"], -1 do
      f1.cancel
    end
  end

  test "缺少user_id" do
    f = FriendshipFactory.build :friend_id => @f.id
    f.save

    assert_not_nil f.errors.on(:user_id)
  end

  test "缺少friend_id" do
    f = FriendshipFactory.build :user_id => @u.id
    f.save

    assert_not_nil f.errors.on(:friend_id)
  end

  test "状态为空" do
    f = FriendshipFactory.build :user_id => @u.id, :friend_id => @f.id, :status => nil 
    f.save

    assert_not_nil f.errors.on(:status)
  end

  test "状态不对" do
    f = FriendshipFactory.build :user_id => @u.id, :friend_id => @f.id, :status => 100 
    f.save

    assert_not_nil f.errors.on(:status)
  end
  
  test "不能把好友关系变成好友请求" do
    f1, f2 = FriendshipFactory.create_friend @u, @f
    f1.update_attributes(:status => Friendship::Request)

    assert_not_nil f1.errors.on(:status)
  end

  test "无法重复创建好友请求" do
    FriendshipFactory.create_request @u, @f
    f = FriendshipFactory.build_request @u, @f
    f.save

    assert_not_nil f.errors.on(:friend_id)
  end

  test "如果已经是好友了，无法创建好友请求" do
    FriendshipFactory.create_friend @u, @f
    f = FriendshipFactory.build_request @u, @f
    f.save

    assert_not_nil f.errors.on(:friend_id)
  end

end
