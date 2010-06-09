require 'test_helper'

class GameFlowTest < ActionController::IntegrationTest

	def setup
    # create a user with game character
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game

		ga = GameArea.create(:name => 'huadong1', :game_id => @game.id)
		ga.save

		gs = GameServer.create(:name => 'server1', :area_id => ga.id, :game_id => @game.id)
		gs.save


    # create friends
    @diff_friend = UserFactory.create
    FriendFactory.create @user, @diff_friend
    @diff_friend_character = GameCharacterFactory.create :user_id => @diff_friend.id
		@game2 = @diff_friend_character.game

    @same_game_friend = UserFactory.create
    FriendFactory.create @user, @same_game_friend
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => ga.id, :server_id => gs.id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_friend.id

    @comrade_friend = UserFactory.create
    FriendFactory.create @user, @comrade_friend
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @comrade_friend.id

    # create strangers
    @diff_stranger = UserFactory.create
    @stranger_character = GameCharacterFactory.create :user_id => @diff_stranger.id
		@game3 = @stranger_character.game

    @same_game_stranger = UserFactory.create
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => ga.id, :server_id => gs.id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_stranger.id

    @comrade_stranger = UserFactory.create
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @comrade_stranger.id

		# game attention
		GameAttention.create(:user_id => @user.id, :game_id => @game2.id)
		GameAttention.create(:user_id => @diff_friend.id, :game_id => @game.id)
		GameAttention.create(:user_id => @same_game_friend.id, :game_id => @game.id)

    # login
    @user_sess = login @user
    @diff_friend_sess = login @diff_friend
    @same_game_friend_sess = login @same_game_friend
		@comrade_friend_sess = login @comrade_friend
    @diff_stranger_sess = login @diff_stranger
    @same_game_stranger_sess = login @same_game_stranger
		@comrade_stranger_sess = login @comrade_stranger
  
	end

	test "GET index" do
		# invalid uid
    @user_sess.get "/games?uid=invalid"
    @user_sess.assert_template 'errors/404'

		# self
		@user_sess.get "/games?uid=#{@user.id}"
    @user_sess.assert_template 'user/games/index'
    assert_equal @user_sess.assigns(:game_characters).first, [@game.id,[@character] ]
		
		# friend
		@user_sess.get "/games?uid=#{@diff_friend.id}"
    @user_sess.assert_template 'user/games/index'
    assert_equal @user_sess.assigns(:game_characters).first, [@diff_friend_character.game.id,[@diff_friend_character] ]

		# stranger
		@user_sess.get "/games?uid=#{@diff_stranger.id}"
    @user_sess.assert_redirected_to new_friend_url(:uid => @diff_stranger.id)
	end

	test "GET show" do
		# invalid uid
    @user_sess.get "/games/invalid"
    @user_sess.assert_template "errors/404"
		
		# user play this game
		@user_sess.get "/games/#{@game.id}"
		@user_sess.assert_template "user/games/show"
		assert_equal @user_sess.assigns(:game), @game
		assert_not_nil @user_sess.assigns(:comrades)

		# user not play this game
		@diff_friend_sess.get "/games/#{@game.id}"
		@diff_friend_sess.assert_template "user/games/show"
		assert_nil @diff_friend_sess.assigns(:comrades)
	end

	test "GET hot" do
		@user_sess.get "/games/hot"
		@user_sess.assert_template "user/games/hot"
		assert_equal @user_sess.assigns(:games), [@game, @game2]
	end

	test "GET sexy" do
		@user_sess.get "/games/sexy"
		@user_sess.assert_template "user/games/sexy"
		assert_equal @user_sess.assigns(:games).first, @game
	end

	test "GET interested" do
		# invalid uid
    @user_sess.get "/games/interested?uid=invalid"
    @user_sess.assert_template 'errors/404'

		@user_sess.get "/games/interested?uid=#{@user.id}"
		@user_sess.assert_template "user/games/interested"
		assert_equal @user_sess.assigns(:games).first, @game2
	end

	test "GET beta" do
		@user_sess.get "/games/beta"
		@user_sess.assert_template "user/games/beta"
		assert_equal @user_sess.assigns(:games), []
	end

  test "GET friends" do
		@user_sess.get "/games/friends"
		@user_sess.assert_template "user/games/friends"
		assert_equal @user_sess.assigns(:game_characters).first.first, @game.id 
	end

private

  def login user
    open_session do |session|
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end 
end
