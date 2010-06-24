require 'test_helper'

class RequestFlowTest < ActionController::IntegrationTest

	def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

    @stranger = UserFactory.create
    @stranger_character = GameCharacterFactory.create @character.game_info.merge({:user_id => @stranger.id})
    @another_stranger = UserFactory.create
    @another_stranger_character = GameCharacterFactory.create @character.game_info.merge({:user_id => @another_stranger.id})

    # 2 friend requests
		@request1 = @user.friend_requests.create :user_id => @stranger.id
		sleep 1
    @request2 = @user.friend_requests.create :user_id => @another_stranger.id
    sleep 1

    # 2 event requests
    @event = EventFactory.create :character_id => @character.id
		@request3 = @event.requests.create :participant_id => @stranger.id, :character_id => @stranger_character.id 
		sleep 1
    @request4 = @event.requests.create :participant_id => @another_stranger.id, :character_id => @another_stranger_character.id
    sleep 1

    # 2 guild requests 
    @guild = GuildFactory.create :character_id => @character.id
		@request5 = @guild.requests.create :user_id => @stranger.id, :character_id => @stranger_character.id 
    sleep 1
    @request6 = @guild.requests.create :user_id => @another_stranger.id, :character_id => @another_stranger_character.id 
   
		@user_sess = login @user
		@stranger_sess = login @stranger
	end

	test "GET index" do
		@user_sess.get "/requests"
		@user_sess.assert_template "user/requests/index"
		assert_equal @user_sess.assigns(:requests), [@request6, @request5, @request4, @request3, @request2, @request1]

		@user_sess.get "/requests?type=1"
		assert_equal @user_sess.assigns(:requests), [@request2, @request1]

		@user_sess.get "/requests?type=2"
		assert_equal @user_sess.assigns(:requests), [@request4, @request3]

		@user_sess.get "/requests?type=3"
		assert_equal @user_sess.assigns(:requests), [@request6, @request5]
	end

end
