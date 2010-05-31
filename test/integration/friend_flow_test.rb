require 'test_helper'

class FriendFlowTest < ActionController::IntegrationTest

  def setup
    @user1 = UserFactory.create
    @user2 = UserFactory.create
    
    # create friends, login ASC order
    @friend1 = UserFactory.create :login => 'friend1'
    @friend2 = UserFactory.create :login => 'friend2'
    @friend3 = UserFactory.create :login => 'friend3'
    @friend4 = UserFactory.create :login => 'friend4'
    FriendFactory.create @user1, @friend1
    FriendFactory.create @user1, @friend2
    FriendFactory.create @user2, @friend3
    FriendFactory.create @user2, @friend4

    # login
    @user1_sess = login @user1
    @user2_sess = login @user2
  end

  test "GET /friends" do
    @user1_sess.get '/friends'
    @user1_sess.assert_template 'user/friends/index'
    assert_equal @user1_sess.assigns(:friends), [@friend1, @friend2]

    @user1_sess.get '/friends', {:term => 0}
    @user1_sess.assert_template 'user/friends/index'
    assert_equal @user1_sess.assigns(:friends), [@friend1, @friend2]

    # create games for them
    @character1 = GameCharacterFactory.create :user_id => @user1.id
    @character2 = GameCharacterFactory.create :user_id => @friend1.id
    @character3 = GameCharacterFactory.create :user_id => @friend2.id
    @character4 = GameCharacterFactory.create @character2.game_info.merge({:user_id => @user1.id})
    @character5 = GameCharacterFactory.create @character3.game_info.merge({:user_id => @user1.id})
    @user1.reload and @friend1.reload and @friend2.reload

    @user1_sess.get '/friends', {:term => 1, :game_id => @character1.game_id}
    @user1_sess.assert_template 'user/friends/index'
    assert @user1_sess.assigns(:friends).blank?

    @user1_sess.get '/friends', {:term => 1, :game_id => @character4.game_id}
    @user1_sess.assert_template 'user/friends/index'
    assert_equal @user1_sess.assigns(:friends), [@friend1]

    @user1_sess.get '/friends', {:term => 1, :game_id => @character5.game_id}
    @user1_sess.assert_template 'user/friends/index'
    assert_equal @user1_sess.assigns(:friends), [@friend2]

    @user1_sess.get '/friends', {:term => 1, :game_id => 'invalid'}
    @user1_sess.assert_template 'errors/404'

    # create guilds for them
    @guild1 = GuildFactory.create :character_id => @character1.id
    @guild2 = GuildFactory.create :character_id => @character4.id
    @guild3 = GuildFactory.create :character_id => @character5.id
    @guild2.member_memberships.create :user_id => @friend1.id, :character_id => @character2.id
    @guild3.member_memberships.create :user_id => @friend2.id, :character_id => @character3.id

    @user1_sess.get '/friends', {:term => 2, :guild_id => @guild1.id}
    @user1_sess.assert_template 'user/friends/index'
    assert @user1_sess.assigns(:friends).blank?

    @user1_sess.get '/friends', {:term => 2, :guild_id => @guild2.id}
    @user1_sess.assert_template 'user/friends/index'
    assert_equal @user1_sess.assigns(:friends), [@friend1]

    @user1_sess.get '/friends', {:term => 2, :guild_id => @guild3.id}
    @user1_sess.assert_template 'user/friends/index'
    assert_equal @user1_sess.assigns(:friends), [@friend2] 

    @user1_sess.get '/friends', {:term => 2, :guild_id => 'invalid'}
    @user1_sess.assert_template 'errors/404'
  end

  test "GET /friends/other" do
    @user1_sess.get '/friends/other', {:uid => @user2.id}
    @user1_sess.assert_template 'user/friends/other'
    assert_equal @user1_sess.assigns(:friends), [@friend3, @friend4]

    @user2_sess.get '/friends/other', {:uid => @user1.id}
    @user2_sess.assert_template 'user/friends/other'
    assert_equal @user2_sess.assigns(:friends), [@friend1, @friend2]

    @user2_sess.get '/friends/other', {:uid => @user2.id}
    @user2_sess.assert_template 'errors/404'

    @user2_sess.get '/friends/other', {:uid => 'invalid'}
    @user2_sess.assert_template 'errors/404'
  end

  test "GET /friends/common" do
    @user1_sess.get '/friends/common', {:uid => @user2.id}
    @user1_sess.assert_template 'user/friends/common'
    assert_equal @user1_sess.assigns(:friends), []

    FriendFactory.create @user2, @friend1

    @user1_sess.get '/friends/common', {:uid => @user2.id}
    @user1_sess.assert_template 'user/friends/common'
    assert_equal @user1_sess.assigns(:friends), [@friend1]

    @user2_sess.get '/friends/common', {:uid => @user2.id}
    @user2_sess.assert_template 'errors/404'

    @user2_sess.get '/friends/common', {:uid => 'invalid'}
    @user2_sess.assert_template 'errors/404'
  end

  test "GET /friends/new" do
    @user1_sess.get '/friends/new', {:uid => 'invalid'}
    @user1_sess.assert_template 'errors/404'

    @user1_sess.get '/friends/new', {:uid => @friend1.id}
    @user1_sess.assert_template 'errors/404'

    @user1_sess.get '/friends/new', {:uid => @user2.id}
    @user1_sess.assert_template 'user/friends/new'
    assert_equal @user1_sess.assigns(:user), @user2
  end

  test "DELETE /friends/:id" do
    assert_no_difference "@user1.reload.friends_count" do
      @user1_sess.delete "/friends/invalid"
    end
    @user1_sess.assert_template 'errors/404'

    assert_no_difference "@user1.reload.friends_count" do
      @user1_sess.delete "/friends/#{@user2.id}"
    end
    @user1_sess.assert_template 'errors/404'
   
    assert_difference "@user1.reload.friends_count", -1 do
      @user1_sess.delete "/friends/#{@friend1.id}"
    end
  end

protected

  def login user
    open_session do |session|
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end 

end
