require 'test_helper'

class MembershipFlowTest < ActionController::IntegrationTest

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

    @guild = GuildFactory.create :character_id => @user_character.id

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each {|f| f.reload}
  end
=begin 
  test "new invitation" do
    @user_sess.get "/guilds/invalid/invitations/new"
    @user_sess.assert_not_found

    [@friend_sess, @same_game_user_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds/#{@guild.id}/invitations/new"
      sess.assert_not_found
    end
  
    @user_sess.get "/guilds/#{@guild.id}/invitations/new"
    @user_sess.assert_template "user/guilds/invitations/new"
    assert_equal @user_sess.assigns(:guild), @guild
  end

  test "send invitation" do
    assert_no_difference "@guild.reload.invitations_count" do
      assert_no_difference "@same_game_user.reload.guild_invitations_count" do
        @user_sess.post "/guilds/#{@guild.id}/invitations", {:values => [@same_game_user_character.id]}
      end
    end

    assert_no_difference "@guild.reload.invitations_count" do
      assert_no_difference "@friend.reload.guild_invitations_count" do
        assert_no_difference "@same_game_user.reload.guild_invitations_count" do
          @user_sess.post "/guilds/#{@guild.id}/invitations", {:values => [@user_character.id, @friend_character.id]}
        end
      end
    end

    assert_difference "@guild.reload.invitations_count" do
      assert_difference "@friend.reload.guild_invitations_count" do
        @user_sess.post "/guilds/#{@guild.id}/invitations", {:values => [@friend_character.id]}
      end
    end

  end

  test "reply invitation" do
    @guild.invite [@friend_character]
    @invitation = @guild.invitations.last

    [@user_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.delete "/guilds/#{@guild.id}/invitations/#{@invitation.id}/decline"
      sess.assert_not_found
    end

    @friend_sess.delete "/guilds/invalid/invitations/#{@invitation.id}/decline"
    @friend_sess.assert_not_found
    @friend_sess.delete "/guilds/#{@guild.id}/invitations/invalid/decline"
    @friend_sess.assert_not_found
    
  end

  test "accept/decline invitation" do
    @guild.invite [@friend_character]
    @invitation = @guild.invitations.last

    [@user_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.delete "/guilds/#{@guild.id}/invitations/#{@invitation.id}/decline"
      sess.assert_not_found
    end

    @friend_sess.delete "/guilds/invalid/invitations/#{@invitation.id}/decline"
    @friend_sess.assert_not_found
    @friend_sess.delete "/guilds/#{@guild.id}/invitations/invalid/decline"
    @friend_sess.assert_not_found

    assert_no_difference "@friend.reload.participated_guilds_count" do
      @friend_sess.delete "/guilds/#{@guild.id}/invitations/#{@invitation.id}/decline"
    end

    @guild.invite [@friend_character]
    @invitation = @guild.invitations.last

    [@user_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.put "/guilds/#{@guild.id}/invitations/#{@invitation.id}/accept"
      sess.assert_not_found
    end

    @friend_sess.put "/guilds/invalid/invitations/#{@invitation.id}/accept"
    @friend_sess.assert_not_found
    @friend_sess.put "/guilds/#{@guild.id}/invitations/invalid/accept"
    @friend_sess.assert_not_found

    assert_difference "@friend.reload.participated_guilds_count" do
      @friend_sess.put "/guilds/#{@guild.id}/invitations/#{@invitation.id}/accept"
    end
  end

  test "whole process of invitation" do
    assert_difference "@guild.reload.invitations_count" do
      @user_sess.post "/guilds/#{@guild.id}/invitations", {:values => [@friend_character.id]}
    end
    @invitation = @guild.invitations.last
  
    @friend_sess.get "/guilds/#{@guild.id}/invitations/#{@invitation.id}/edit"
    @friend_sess.assert_template "user/guilds/invitations/edit"

    assert_no_difference "@friend.reload.participated_guilds_count" do
      @friend_sess.delete "/guilds/#{@guild.id}/invitations/#{@invitation.id}/decline"
    end

    assert_difference "@guild.reload.invitations_count" do
      @user_sess.post "/guilds/#{@guild.id}/invitations", {:values => [@friend_character.id]}
    end
    @guild.reload
    @invitation = @guild.invitations.last

    @friend_sess.get "/guilds/#{@guild.id}/invitations/#{@invitation.id}/edit"
    @friend_sess.assert_template "user/guilds/invitations/edit"

    assert_difference "@friend.reload.participated_guilds_count" do
      @friend_sess.put "/guilds/#{@guild.id}/invitations/#{@invitation.id}/accept"
    end
  end

  test "new request" do
    @friend_sess.get "/guilds/invalid/requests/new"
    @friend_sess.assert_not_found

    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/guilds/#{@guild.id}/requests/new"
      sess.assert_template "user/guilds/requests/new"
    end
  end

  test "send request" do
    assert_no_difference "@guild.reload.requests_count" do
      @friend_sess.post "/guilds/#{@guild.id}/requests", {:request => {:character_id => @same_game_user_character.id}}
    end

    assert_no_difference "@guild.reload.requests_count" do
      @friend_sess.post "/guilds/#{@guild.id}/requests", {:request => {:character_id => nil}}
    end

    @character = GameCharacterFactory.create :user_id => @stranger.id
    assert_no_difference "@guild.reload.requests_count" do
      @stranger_sess.post "/guilds/#{@guild.id}/requests", {:request => {:character_id => @character.id}}
    end

    @friend_sess.post "/guilds/invalid/requests", {:request => {:character_id => @friend_character.id}}
    @friend_sess.assert_not_found

    assert_difference "@guild.reload.requests_count" do
      @friend_sess.post "/guilds/#{@guild.id}/requests", {:request => {:character_id => @friend_character.id}}
    end
  end
  
  test "accept/decline request" do
    @request = @guild.requests.create :user_id => @friend.id, :character_id => @friend_character.id
    
    [@friend_sess, @stranger_sess, @same_game_user_sess, @fan_sess, @idol_sess].each do |sess|
      sess.delete "/guilds/#{@guild.id}/requests/#{@request.id}/decline"
      sess.assert_not_found
    end

    @user_sess.delete "/guilds/#{@guild.id}/requests/invalid/decline"
    @user_sess.assert_not_found
    @user_sess.delete "/guilds/invalid/requests/#{@request.id}/decline"
    @user_sess.assert_not_found

    assert_no_difference "@friend.reload.participated_guilds_count" do
      @user_sess.delete "/guilds/#{@guild.id}/requests/#{@request.id}/decline"
    end

# TODO:
    [@friend_sess, @stranger_sess, @same_game_user_sess, @fan_sess, @idol_sess].each do |sess, i|
      sess.put "/guilds/#{@guild.id}/requests/#{@request.id}/accept"
      sess.assert_not_found
    end

    @user_sess.put "/guilds/#{@guild.id}/requests/invalid/accept"
    @user_sess.assert_not_found
    @user_sess.put "/guilds/invalid/requests/#{@request.id}/accept"
    @user_sess.assert_not_found

    assert_difference "@friend.reload.participated_guilds_count" do
      @user_sess.put "/guilds/#{@guild.id}/requests/#{@request.id}/accept"
    end
  end
  
  test "whole process of request" do
    @friend_sess.get "/guilds/#{@guild.id}/requests/new"
    @friend_sess.assert_template "user/guilds/requests/new"

    assert_difference "@guild.reload.requests_count" do
      @friend_sess.post "/guilds/#{@guild.id}/requests", {:request => {:character_id => @friend_character.id}}
    end
    @request = @friend_sess.assigns(:request)

    assert_no_difference "@friend.reload.participated_guilds_count" do
      @user_sess.delete "/guilds/#{@guild.id}/requests/#{@request.id}/decline"
    end

    @friend_sess.get "/guilds/#{@guild.id}/requests/new"
    @friend_sess.assert_template "user/guilds/requests/new"

    assert_difference "@guild.reload.requests_count" do
      @friend_sess.post "/guilds/#{@guild.id}/requests", {:request => {:character_id => @friend_character.id}}
    end
    @request = @friend_sess.assigns(:request)

    assert_difference "@friend.reload.participated_guilds_count" do
      @user_sess.put "/guilds/#{@guild.id}/requests/#{@request.id}/accept"
    end
  end

  test "change role" do
    @m = @guild.member_memberships.create :user_id => @friend.id, :character_id => @friend_character.id
    
    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.put "/guilds/#{@guild.id}/memberships/#{@m.id}", {:status => Membership::Veteran}
      sess.assert_not_found
    end

    @user_sess.put "/guilds/#{@guild.id}/memberships/invalid", {:status => Membership::Veteran}
    @user_sess.assert_not_found
    @user_sess.put "/guilds/invalid/memberships/#{@m.id}", {:status => Membership::Veteran}
    @user_sess.assert_not_found
    assert_no_difference "@guild.reload.members_count" do
      @user_sess.put "/guilds/#{@guild.id}/memberships/#{@m.id}", {:status => nil}
    end

    assert_difference "@guild.reload.members_count", -1 do
      assert_difference "@guild.reload.veterans_count" do
        @user_sess.put "/guilds/#{@guild.id}/memberships/#{@m.id}", {:status => Membership::Veteran}
      end
    end

    assert_difference "@guild.reload.veterans_count", -1 do
      assert_difference "@guild.reload.members_count" do
        @user_sess.put "/guilds/#{@guild.id}/memberships/#{@m.id}", {:status => Membership::Member}
      end
    end

    assert_no_difference "@guild.reload.veterans_count" do
      assert_no_difference "@guild.reload.members_count" do
        @user_sess.put "/guilds/#{@guild.id}/memberships/#{@m.id}", {:status => Membership::Member}
      end
    end
  end
  
  test "evict" do
    @m = @guild.member_memberships.create :user_id => @friend.id, :character_id => @friend_character.id
    
    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.delete "/guilds/#{@guild.id}/memberships/#{@m.id}"
      sess.assert_not_found
    end

    @user_sess.delete "/guilds/#{@guild.id}/memberships/invalid"
    @user_sess.assert_not_found
    @user_sess.delete "/guilds/invalid/memberships/#{@m.id}"
    @user_sess.assert_not_found
    
    assert_difference "@guild.reload.members_count", -1 do
      @user_sess.delete "/guilds/#{@guild.id}/memberships/#{@m.id}"
    end
  end
=end
  test "member/veteran/invitee/requestor list" do
    @stranger_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @stranger.id})
    @fan_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @fan.id})
    @idol_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @idol.id})

    @m1 = @guild.veteran_memberships.create :user_id => @fan.id, :character_id => @fan_character.id
    sleep 1
    @m2 = @guild.member_memberships.create :user_id => @same_game_user.id, :character_id => @same_game_user_character.id
    sleep 1
    @m3 = @guild.invitations.create :user_id => @friend.id, :character_id => @friend_character.id
    sleep 1
    @m4 = @guild.requests.create :user_id => @idol.id, :character_id => @idol_character.id

    # TODO
=begin
    @user_sess.get "/guilds/#{@guild.id}/memberships", {:type => 222}
    @user_sess.assert_template "errors/500"
=end

    @user_sess.get "/guilds/invalid/memberships", {:type => 0}
    @user_sess.assert_not_found

    @user_sess.get "/guilds/#{@guild.id}/memberships", {:type => 0}
    @user_sess.assert_template "user/guilds/memberships/index"
    assert_equal @user_sess.assigns(:memberships), [@m2, @m1]

    @user_sess.get "/guilds/#{@guild.id}/memberships", {:type => 1}
    @user_sess.assert_template "user/guilds/memberships/index"
    assert_equal @user_sess.assigns(:memberships), [@m3]

    @user_sess.get "/guilds/#{@guild.id}/memberships", {:type => 2}
    @user_sess.assert_template "user/guilds/memberships/index"
    assert_equal @user_sess.assigns(:memberships), [@m4]
  end

end
