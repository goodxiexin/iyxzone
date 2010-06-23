require 'test_helper'

class RequestFlowTest < ActionController::IntegrationTest

	def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

    @stranger = UserFactory.create
    @stranger_character = GameCharacterFactory.create @character.game_info.merge({:user_id => @stranger.id})

		@request1 = Friendship.create(:friend_id => @user.id, :user_id => @stranger.id, :status => 0)

		sleep 1
    @event = EventFactory.create :character_id => @character.id
		@request2 = @event.requests.create :participant_id => @stranger.id, :character_id => @stranger_character.id 

		sleep 1
    @guild = GuildFactory.create :character_id => @character.id
		@request3 = @guild.requests.create :user_id => @stranger.id, :character_id => @stranger_character.id 

		@user_sess = login @user
		@stranger_sess = login @stranger
	end

	test "GET index" do
		@user_sess.get "/requests"
		@user_sess.assert_template "user/requests/index"
		assert_equal @user_sess.assigns(:requests), [@request1, @request2, @request3]

		@user_sess.get "/requests?type=1"
		assert_equal @user_sess.assigns(:requests), [@request1]

		@user_sess.get "/requests?type=2"
		assert_equal @user_sess.assigns(:requests), [@request2]

		@user_sess.get "/requests?type=3"
		assert_equal @user_sess.assigns(:requests), [@request3]

	end

end
