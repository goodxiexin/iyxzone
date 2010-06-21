require 'test_helper'

class PokeFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @friend = UserFactory.create
    @stranger = UserFactory.create
    FriendFactory.create @user, @friend
    @user_sess = login @user
    @friend_sess = login @friend
    @stranger_sess = login @stranger
    @poke1 = PokeFactory.create
    @poke2 = PokeFactory.create
  end

  test "GET /pokes/new" do
    @user_sess.get "/pokes/new"
    @user_sess.assert_template "errors/404"

    @user_sess.get "/pokes/new", {:recipient_id => 'invalid'}
    @user_sess.assert_template "errors/404"

    @user_sess.get "/pokes/new", {:recipient_id => @friend.id}
    @user_sess.assert_template "user/pokes/new"
    assert_equal @user_sess.assigns(:pokes), [@poke1, @poke2]
  end

  test "POST /pokes" do
    assert_difference "PokeDelivery.count" do
      @user_sess.post "/pokes", {:delivery => {:recipient_id => @friend.id, :poke_id => @poke1.id}}
    end
    @delivery1 = @user_sess.assigns(:delivery)

    assert_no_difference "PokeDelivery.count" do
      @user_sess.post "/pokes", {:delivery => {:recipient_id => 'invalid', :poke_id => @poke1.id}}
    end

    sleep 1

    assert_difference "PokeDelivery.count" do
      @user_sess.post "/pokes", {:delivery => {:recipient_id => @friend.id, :poke_id => @poke1.id}}
    end
    @delivery2 = @user_sess.assigns(:delivery)

    # friend 查看并回复
    @friend_sess.get "/pokes"
    @friend_sess.assert_template "user/pokes/index"
    assert_equal @friend_sess.assigns(:deliveries), [@delivery2, @delivery1]

    assert_difference "PokeDelivery.count" do
      @friend_sess.post "/pokes", {:delivery => {:recipient_id => @user.id, :poke_id => @poke2.id}}
    end
  end

  test "DELETE /posts/:id" do
    @user_sess.post "/pokes", {:delivery => {:recipient_id => @friend.id, :poke_id => @poke1.id}}
    @delivery = @user_sess.assigns(:delivery)

    assert_no_difference "PokeDelivery.count" do
      @user_sess.delete "/pokes/#{@delivery.id}"
    end
    @user_sess.assert_template "errors/404" 

    assert_no_difference "PokeDelivery.count" do
      @friend_sess.delete "/pokes/invalid"
    end
    @friend_sess.assert_template "errors/404" 

    assert_difference "PokeDelivery.count", -1 do
      @friend_sess.delete "/pokes/#{@delivery.id}"
    end
  end

  test "destroy all" do
    @user_sess.post "/pokes", {:delivery => {:recipient_id => @friend.id, :poke_id => @poke1.id}}
    @user_sess.post "/pokes", {:delivery => {:recipient_id => @friend.id, :poke_id => @poke2.id}}

    assert_difference "PokeDelivery.count", -2 do
      @friend_sess.delete "/pokes/destroy_all"
    end
    @friend.reload
    assert_equal @friend.poke_deliveries_count, 0
  end

protected

  def login user
    open_session do |session|
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end   

end
