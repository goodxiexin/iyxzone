require 'test_helper'

class InvitationFlowTest < ActionController::IntegrationTest

	def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

    @friend = UserFactory.create
    @friend_character = GameCharacterFactory.create @character.game_info.merge({:user_id => @friend.id})

    FriendFactory.create @user, @friend

    # 2 event invitations
    @event1 = EventFactory.create :character_id => @friend_character.id
    @event1.invite [@character]
		@invitation1 = @event1.invitations.last
    sleep 1
    @event2 = EventFactory.create :character_id => @friend_character.id
    @event2.invite [@character]
    @invitation2 = @event2.invitations.last
    sleep 1

    # 2 guild invitations
    @guild1 = GuildFactory.create :character_id => @friend_character.id
    @guild1.invite [@character]
    @invitation3 = @guild1.invitations.last
		sleep 1
    @guild2 = GuildFactory.create :character_id => @friend_character.id
    @guild2.invite [@character]
    @invitation4 = @guild2.invitations.last
    sleep 1

    # 2 poll invitations
    @poll1 = Poll.create :poster_id => @friend.id, :game_id => @character.game_id, :privilege => 2, :no_deadline => 0, :deadline => 1.day.from_now, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}], :max_multiple => 2
    @poll1.invite [@user]
		@invitation5 = PollInvitation.last
    sleep 1
    @poll2 = Poll.create :poster_id => @friend.id, :game_id => @character.game_id, :privilege => 2, :no_deadline => 0, :deadline => 1.day.from_now, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}], :max_multiple => 2
    @poll2.invite [@user]
    @invitation6 = PollInvitation.last
    
		@user_sess = login @user
		@friend_sess = login @friend
	end

	test "GET index" do
		@user_sess.get "/invitations"
		@user_sess.assert_template "user/invitations/index"
		assert_equal @user_sess.assigns(:invitations), [@invitation6, @invitation5, @invitation4, @invitation3, @invitation2, @invitation1]

		@user_sess.get "/invitations?type=1"
		assert_equal @user_sess.assigns(:invitations), [@invitation6, @invitation5]

		@user_sess.get "/invitations?type=2"
		assert_equal @user_sess.assigns(:invitations), [@invitation2, @invitation1]

		@user_sess.get "/invitations?type=3"
		assert_equal @user_sess.assigns(:invitations), [@invitation4, @invitation3]

	end

end
