require 'test_helper'

class GuildFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create_idol
    @idol = UserFactory.create_idol
    @fan = UserFactory.create
    @friend = UserFactory.create
    @same_game_user = UserFactory.create
    @stranger = UserFactory.create
    @user_character = GameCharacterFactory.create :user_id => @user.id
    @friend_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @friend.id})
    @same_game_user_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @same_game_user.id})
    @game = @user_character.game

    FriendFactory.create @user, @friend
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id    

    @sensitive = "政府"

    @user_sess = login @user
    @friend_sess = login @friend
    @same_game_user_sess = login @same_game_user
    @stranger_sess = login @stranger
    @idol_sess = login @idol
    @fan_sess = login @fan

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each {|f| f.reload}
  end
=begin
  test "GET /guilds/hot" do
    @guild1 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild2 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild3 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild4 = GuildFactory.create :character_id => @user_character.id

    @guild1.member_memberships.create :character_id => @friend_character.id, :user_id => @friend.id
    @guild4.member_memberships.create :character_id => @friend_character.id, :user_id => @friend.id
    @guild2.member_memberships.create :character_id => @friend_character.id, :user_id => @friend.id
    @guild2.veteran_memberships.create :character_id => @same_game_user_character.id, :user_id => @same_game_user.id

    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/guilds/hot"
      sess.assert_template "user/guilds/hot"
      assert_equal sess.assigns(:guilds), [@guild2, @guild4, @guild1, @guild3]
    end

    [@stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds/hot"
      sess.assert_template "user/guilds/hot"
      assert_equal sess.assigns(:guilds),  []
    end

    @guild4.unverify

    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/guilds/hot"
      sess.assert_template "user/guilds/hot"
      assert_equal sess.assigns(:guilds), [@guild2, @guild1, @guild3]
    end

    [@stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds/hot"
      sess.assert_template "user/guilds/hot"
      assert_equal sess.assigns(:guilds),  []
    end
  end

  test "GET /guilds/recent" do
    @guild1 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild2 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild3 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild4 = GuildFactory.create :character_id => @user_character.id

    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/guilds/hot"
      sess.assert_template "user/guilds/hot"
      assert_equal sess.assigns(:guilds), [@guild4, @guild3, @guild2, @guild1]
    end

    [@stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds/hot"
      sess.assert_template "user/guilds/hot"
      assert_equal sess.assigns(:guilds),  []
    end

    @guild4.unverify

    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/guilds/hot"
      sess.assert_template "user/guilds/hot"
      assert_equal sess.assigns(:guilds), [@guild3, @guild2, @guild1]
    end

    [@stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds/hot"
      sess.assert_template "user/guilds/hot"
      assert_equal sess.assigns(:guilds),  []
    end
  end

  test "GET /guilds/friends" do
    @guild1 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild2 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild3 = GuildFactory.create :character_id => @friend_character.id
    @guild1.member_memberships.create :character_id => @friend_character.id, :user_id => @friend.id
    @guild2.member_memberships.create :character_id => @friend_character.id, :user_id => @friend.id

    @user_sess.get "/guilds/friends"
    @user_sess.assert_template "user/guilds/friends"
    assert_equal @user_sess.assigns(:guilds), [@guild3, @guild2, @guild1]

    @friend_sess.get "/guilds/friends"
    @friend_sess.assert_template "user/guilds/friends"
    assert_equal @friend_sess.assigns(:guilds), [@guild2, @guild1]

    @guild2.unverify

    @user_sess.get "/guilds/friends"
    @user_sess.assert_template "user/guilds/friends"
    assert_equal @user_sess.assigns(:guilds), [@guild3, @guild1]

    @friend_sess.get "/guilds/friends"
    @friend_sess.assert_template "user/guilds/friends"
    assert_equal @friend_sess.assigns(:guilds), [@guild1]
  end
  
  test "GET /guilds" do
    @guild1 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild2 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild3 = GuildFactory.create :character_id => @user_character.id
    sleep 1
    @guild4 = GuildFactory.create :character_id => @friend_character.id
    @guild4.member_memberships.create :user_id => @user.id, :character_id => @user_character.id

    [@user_sess, @friend_sess].each do |sess|
      sess.get "/guilds", {:uid => @user.id}
      sess.assert_template "user/guilds/index"
      assert_equal sess.assigns(:guilds), [@guild3, @guild2, @guild1]
    end

    @guild2.unverify

    [@user_sess, @friend_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds", {:uid => @user.id}
      sess.assert_template "user/guilds/index"
      assert_equal sess.assigns(:guilds), [@guild3, @guild1]
    end

    [@same_game_user_sess, @stranger_sess].each do |sess|
      sess.get "/guilds", {:uid => @user.id}
      sess.assert_redirected_to new_friend_url(:uid => @user.id)
    end

  end 
  
  test "GET /guilds/participated" do
    @guild1 = GuildFactory.create :character_id => @friend_character.id
    sleep 1
    @guild2 = GuildFactory.create :character_id => @friend_character.id
    sleep 1
    @guild3 = GuildFactory.create :character_id => @friend_character.id
    sleep 1
    @guild1.member_memberships.create :user_id => @user.id, :character_id => @user_character.id
    @guild2.member_memberships.create :user_id => @user.id, :character_id => @user_character.id
    @guild3.member_memberships.create :user_id => @user.id, :character_id => @user_character.id

    [@user_sess, @friend_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds/participated", {:uid => @user.id}
      sess.assert_template "user/guilds/participated"
      assert_equal sess.assigns(:guilds), [@guild3, @guild2, @guild1]
    end

    @guild2.unverify

    [@user_sess, @friend_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds/participated", {:uid => @user.id}
      sess.assert_template "user/guilds/participated"
      assert_equal sess.assigns(:guilds), [@guild3, @guild1]
    end

    [@same_game_user_sess, @stranger_sess].each do |sess|
      sess.get "/guilds/participated", {:uid => @user.id}
      sess.assert_redirected_to new_friend_url(:uid => @user.id)
    end
  end

  test "GET /guilds/new" do
    @user_sess.get "/guilds/new"
    @user_sess.assert_template "user/guilds/new"
  end

  test "POST /guilds" do
    assert_difference "@user.reload.guilds_count" do
      @user_sess.post "/guilds", {:guild => {:name => 'name', :character_id => @user_character.id, :description => 'd'}}
    end
    @guild = @user_sess.assigns(:guild)
    @user_sess.assert_redirected_to new_guild_invitation_url(@guild)

    assert_no_difference "@user.reload.guilds_count" do
      @user_sess.post "/guilds", {:guild => {:name => 'name', :character_id => @friend_character.id, :description => 'd'}}
    end

    assert_no_difference "@user.reload.guilds_count" do
      @user_sess.post "/guilds", {:guild => {:name => nil, :character_id => @user_character.id, :description => 'd'}}
    end

    assert_no_difference "@user.reload.guilds_count" do
      @user_sess.post "/guilds", {:guild => {:name => nil, :character_id => @user_character.id, :description => nil}}
    end
  end

  test "PUT /guilds/:id" do
    @guild = GuildFactory.create :character_id => @user_character.id

    @user_sess.put "/guilds/#{@guild.id}", {:guild => {:description => 'new'}}
    @guild.reload
    assert_equal @guild.description, 'new'
  
    @name = @guild.name  
    @user_sess.put "/guilds/#{@guild.id}", {:guild => {:name => 'new'}}
    @guild.reload
    assert_equal @guild.name, @name
  
    @game_id = @guild.game_id
    @user_sess.put "/guilds/#{@guild.id}", {:guild => {:game_id => GameCharacterFactory.create.game_id}}
    @guild.reload
    assert_equal @guild.game_id, @game_id
  end

  test "DELETE /guilds/:id" do
    @guild = GuildFactory.create :character_id => @user_character.id
  
    [@friend_sess, @stranger_sess, @same_game_user_sess, @fan_sess, @idol_sess].each do |sess|
      sess.delete "/guilds/#{@guild.id}"
      sess.assert_not_found
    end

    @user_sess.delete "/guilds/invalid"
    @user_sess.assert_not_found

    assert_difference "Guild.count", -1 do
      @user_sess.delete "/guilds/#{@guild.id}"
    end
  end
=end
  test "get /guilds/:id" do
    @guild = GuildFactory.create :character_id => @user_character.id
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @friend_character.id

    # blog feed
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @guild.reload
    assert @guild.recv_feed?(@blog)

    # video feed
    @video = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
    @guild.reload
    assert @guild.recv_feed?(@video)

    # poll feed
    @poll = Poll.create :poster_id => @user.id, :game_id => @game.id, :privilege => 1, :no_deadline => 1, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}]
    @guild.reload
    assert @guild.recv_feed?(@poll)

    # vote feed
    @vote = @poll.votes.create :voter_id => @user.id, :answer_ids => [@poll.answers.first.id]
    @guild.reload
    assert @guild.recv_feed?(@vote)

    # event feed
    @event = EventFactory.create :character_id => @user_character.id, :guild_id => @guild.id
    @guild.reload
    assert @guild.recv_feed?(@event)

    # participation feed
    @participation = @event.requests.create :participant_id => @friend.id, :character_id => @friend_character.id
    @participation.accept_request
    @guild.reload
    assert @guild.recv_feed?(@participation)

    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds/#{@guild.id}"
      sess.assert_template "user/guilds/show"
    end     
  end

end
