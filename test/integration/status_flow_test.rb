require 'test_helper'

class StatusFlowTest < ActionController::IntegrationTest

  def setup
    # create a user with game character
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game

    # create friend
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @friend.id
    
    # create stranger
    @stranger = UserFactory.create

    # create same-game-user
    @same_game_user = UserFactory.create
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_user.id

    # login
    @user_sess = login @user
    @friend_sess = login @friend
    @same_game_user_sess = login @same_game_user
    @stranger_sess = login @stranger
 
    # create status
    @status1 = @user_sess.create_status :content => 'status1'
    sleep 1
    @status2 = @user_sess.create_status :content => 'status2'
    @status3 = @friend_sess.create_status :content => 'status3'
    sleep 1
    @status4 = @friend_sess.create_status :content => 'status4'
  end

  test "GET index" do
    @user_sess.get "/statuses?uid=#{@user.id}"
    @user_sess.assert_template 'user/statuses/index'
    assert_equal @user_sess.assigns(:statuses), [@status2, @status1]

    @user_sess.get "/statuses?uid=#{@friend.id}"
    @user_sess.assert_template 'user/statuses/index'
    assert_equal @user_sess.assigns(:statuses), [@status4, @status3]

    @user_sess.get "/statuses?uid=#{@same_game_user.id}"
    @user_sess.assert_redirected_to new_friend_url(:uid => @same_game_user.id)

    @user_sess.get "/statuses?uid=#{@stranger.id}"
    @user_sess.assert_redirected_to new_friend_url(:uid => @stranger.id)

    @status1.unverify
    @user_sess.get "/statuses?uid=#{@user.id}"
    @user_sess.assert_template 'user/statuses/index'
    assert_equal @user_sess.assigns(:statuses), [@status2]
  end

  test "POST create" do
    assert_difference "Status.count", 1 do
      @user_sess.post "/statuses", {:status => {:content => 'content'}}
    end
    
    @user.reload
    assert_equal @user.statuses_count, 3
  end

  test "DELETE destroy" do
    assert_difference "Status.count", -1 do
      @user_sess.delete "/statuses/#{@status1.id}"
    end
  
    @user.reload
    assert_equal @user.statuses_count, 1
  end

private
 
  module CustomDsl 

    def create_status params
      post "/statuses", {:status => params}
      assigns(:status)
    end  
  
  end  

  def login user
    open_session do |session|
      session.extend CustomDsl 
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end 


end
