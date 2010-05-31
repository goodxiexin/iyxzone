require 'test_helper'

class FriendFlowTest < ActionController::IntegrationTest

  def setup
    @user1 = UserFactory.create
    @user2 = UserFactory.create
    @user1_sess = login @user1
    @user2_sess = login @user2
  end

  test "GET /friend_requests/new" do
    @user1_sess.get "/friend_requests/new?friend_id=invalid"
    @user1_sess.assert_template 'errors/404'

    @user1_sess.get "/friend_requests/new?friend_id=#{@user1.id}"
    @user1_sess.assert_template 'user/friends/requests/not_myself'
 
    @user1_sess.get "/friend_requests/new?friend_id=#{@user2.id}"
    @user1_sess.assert_template 'user/friends/requests/new'
    assert_equal @user1_sess.assigns(:recipient), @user2

    @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user2.id}}
 
    @user1_sess.get "/friend_requests/new?friend_id=#{@user2.id}"
    @user1_sess.assert_template 'user/friends/requests/already_sent'

    @friend = UserFactory.create
    FriendFactory.create @user1, @friend
    @user1_sess.get "/friend_requests/new?friend_id=#{@friend.id}"
    @user1_sess.assert_template 'user/friends/requests/already_friend'
  end

  test "POST /friend_requests" do
    assert_no_difference ["Email.count", "Friendship.count"] do
      @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => nil}}
    end

    assert_no_difference ["Email.count", "Friendship.count"] do
      @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user1.id}}
    end

    assert_difference ["Email.count", "Friendship.count"] do
      @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user2.id}}
    end

    assert_no_difference ["Email.count", "Friendship.count"] do
      @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user2.id}}
    end

    @friend = UserFactory.create
    FriendFactory.create @user1, @friend
    assert_no_difference ["Email.count", "Friendship.count"] do
      @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @friend.id}}
    end
  end
    
  test "PUT /friend_requests/:id/decline" do
    assert_difference ["Email.count", "Friendship.count"] do
      @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user2.id}}
    end
    @request1 = @user1_sess.assigns(:request)

    assert_no_difference "Notification.count" do
      @user1_sess.delete "/friend_requests/invalid/decline"
    end
    @user1_sess.assert_template 'errors/404'

    assert_no_difference "Notification.count" do
      @user1_sess.delete "/friend_requests/#{@request1.id}/decline"
    end
    @user1_sess.assert_template 'errors/404'

    assert_difference "Notification.count" do
      @user2_sess.delete "/friend_requests/#{@request1.id}/decline"
    end

    @user1.reload and @user2.reload
    assert_nil Friendship.find_by_id(@request1.id)
    assert_equal @user2.friends_count, 0
    assert_equal @user1.friends_count, 0
  end

  test "PUT /friend_requests/:id/accept" do
    assert_difference ["Email.count", "Friendship.count"] do
      @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user2.id}}
    end
    @request1 = @user1_sess.assigns(:request)

    assert_no_difference "Notification.count" do
      @user1_sess.put "/friend_requests/invalid/accept"
    end
    @user1_sess.assert_template 'errors/404'

    assert_no_difference "Notification.count" do
      @user1_sess.put "/friend_requests/#{@request1.id}/accept"
    end
    @user1_sess.assert_template 'errors/404'

    assert_difference "Notification.count" do
      @user2_sess.put "/friend_requests/#{@request1.id}/accept"
    end

    @user1.reload and @user2.reload
    assert_equal @user2.friends_count, 1
    assert_equal @user1.friends_count, 1
  end

  test "同时发送邀请，一方拒绝" do
    assert_difference ["Email.count", "Friendship.count"] do
      @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user2.id}}
    end
    @request1 = @user1_sess.assigns(:request)

    assert_difference ["Email.count", "Friendship.count"] do
      @user2_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user1.id}}
    end
    @request2 = @user2_sess.assigns(:request)

    assert_difference "Notification.count" do
      @user2_sess.delete "/friend_requests/#{@request1.id}/decline"
    end

    @user1.reload and @user2.reload
    assert_equal @user1.friends_count, 0
    assert_equal @user2.friends_count, 0

    assert_difference "Notification.count" do
      @user1_sess.put "/friend_requests/#{@request2.id}/accept"
    end

    @user1.reload and @user2.reload
    assert_equal @user1.friends_count, 1
    assert_equal @user2.friends_count, 1
  end

  test "同时发送请求，一方接受" do
    assert_difference ["Email.count", "Friendship.count"] do
      @user1_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user2.id}}
    end
    @request1 = @user1_sess.assigns(:request)

    assert_difference ["Email.count", "Friendship.count"] do
      @user2_sess.post "/friend_requests", {:request => {:data => "adsf", :friend_id => @user1.id}}
    end
    @request2 = @user2_sess.assigns(:request)

    assert_difference "Notification.count" do
      @user2_sess.put "/friend_requests/#{@request1.id}/accept"
    end

    @user1.reload and @user2.reload
    assert_equal @user1.friends_count, 1
    assert_equal @user2.friends_count, 1
  end

protected

  def login user
    open_session do |session|
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end

end
