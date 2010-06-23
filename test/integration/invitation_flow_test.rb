require 'test_helper'

class InvitationFlowTest < ActionController::IntegrationTest

	def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

    @friend = UserFactory.create
    @friend_character = GameCharacterFactory.create @character.game_info.merge({:user_id => @friend.id})

    FriendFactory.create @user, @friend

    @event = EventFactory.create :character_id => @friend_character.id
    @event.invite [@character]
		@invitation1 = @event.invitations.last

		sleep 1
    @guild = GuildFactory.create :character_id => @friend_character.id
    @guild.invite [@character]
    @invitation2 = @guild.invitations.last

		sleep 1
    @poll = Poll.create :poster_id => @friend.id, :game_id => @character.game_id, :privilege => 2, :no_deadline => 0, :deadline => 1.day.from_now, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}], :max_multiple => 2
    @poll.update_attributes(:invitees => [@user.id])
		@invitation3 = PollInvitation.last

		@user_sess = login @user
		@friend_sess = login @friend
	end

	test "GET index" do
		@user_sess.get "/invitations"
		@user_sess.assert_template "user/invitations/index"
		assert_equal @user_sess.assigns(:invitations), [@invitation1, @invitation2, @invitation3]

		@user_sess.get "/invitations?type=1"
		assert_equal @user_sess.assigns(:invitations), [@invitation3]

		@user_sess.get "/invitations?type=2"
		assert_equal @user_sess.assigns(:invitations), [@invitation1]

		@user_sess.get "/invitations?type=3"
		assert_equal @user_sess.assigns(:invitations), [@invitation2]

	end

end
