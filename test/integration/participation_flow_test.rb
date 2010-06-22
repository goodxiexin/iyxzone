require 'test_helper'

class ParticipationFlowTest < ActionController::IntegrationTest

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

    @guild = GuildFactory.create :character_id => @user_character.id
    @guild.veteran_memberships.create :character_id => @friend_character.id, :user_id => @friend.id

    @sensitive = "政府"

    @user_sess = login @user
    @friend_sess = login @friend
    @same_game_user_sess = login @same_game_user
    @stranger_sess = login @stranger
    @idol_sess = login @idol
    @fan_sess = login @fan

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each {|f| f.reload}
  end
  
  test "GET /events/:id/invitations/new" do
    @event = EventFactory.create :character_id => @user_character.id

    @friend_sess.get "/events/#{@event.id}/invitations/new"
    @friend_sess.assert_not_found

    @user_sess.get "/events/#{@event.id}/invitations/new"
    @user_sess.assert_template "user/events/invitations/new"
    assert_equal @user_sess.assigns(:event), @event

    @user_sess.get "/events/invalid/invitations/new"
    @user_sess.assert_not_found

    @event.unverify
    @user_sess.get "/events/invalid/invitations/new"
    @user_sess.assert_not_found 
  end

  test "POST /events/:id/invitations" do
    # normal event
    @event = EventFactory.create :character_id => @user_character.id

    @friend_sess.post "/events/#{@event.id}/invitations", {:values => [@friend_character.id]}
    @friend_sess.assert_not_found

    assert_no_difference "@event.reload.invitations_count" do
      @user_sess.post "/events/#{@event.id}/invitations", {:values => [@friend_character.id, @same_game_user_character.id]}
    end

    @event.unverify
    @user_sess.post "/events/#{@event.id}/invtations", {:values => [@friend_character.id]}
    @user_sess.assert_not_found
    @event.verify

    @user_sess.post "/events/#{@event.id}/invitations", {:values => ['invalid']}
    @user_sess.assert_not_found

    assert_difference "@event.reload.invitations_count" do
      @user_sess.post "/events/#{@event.id}/invitations", {:values => [@friend_character.id]}
    end
    @user_sess.assert_redirected_to event_url(@event)

    # guild event
    @event = EventFactory.create :character_id => @user_character.id, :guild_id => @guild.id
   
    # invite none member 
    assert_no_difference "@event.reload.invitations_count" do
      @user_sess.post "/events/#{@same_game_user.id}/invitations", {:values => [@same_game_user_character.id]}
    end

    assert_no_difference "@event.reload.invitations_count" do
      @user_sess.post "/events/#{@event.id}/invitations", {:values => [@same_game_user_character.id, @friend_character.id]}
    end

    assert_difference "@event.reload.invitations_count" do
      @user_sess.post "/events/#{@event.id}/invitations", {:values => [@friend_character.id]}
    end
  end
 
  test "PUT /events/:id/invitations/:id" do
    @event = EventFactory.create :character_id => @user_character.id
    @invitation = @event.invitations.create :participant_id => @friend.id, :character_id => @friend_character.id

    @user_sess.get "/events/#{@event.id}/invitations/#{@invitation.id}/edit"
    @user_sess.assert_not_found
    @user_sess.put "/events/#{@event.id}/invitations/#{@invitation.id}/accept"
    @user_sess.assert_not_found
    @user_sess.delete "/events/#{@event.id}/invitations/#{@invitation.id}/decline"
    @user_sess.assert_not_found

    @event.unverify
    @friend_sess.get "/events/#{@event.id}/invitations/#{@invitation.id}/edit"
    @friend_sess.assert_not_found
    @friend_sess.delete "/events/#{@event.id}/invitations/#{@invitation.id}/decline"
    @friend_sess.assert_not_found
    @friend_sess.put "/events/#{@event.id}/invitations/#{@invitation.id}/accept"
    @friend_sess.assert_not_found
    @event.verify

    @friend_sess.get "/events/#{@event.id}/invitations/#{@invitation.id}/edit"
    @friend_sess.assert_template "user/events/invitations/edit"
    assert_difference "@event.reload.invitations_count", -1 do
      @friend_sess.delete "/events/#{@event.id}/invitations/#{@invitation.id}/decline"
    end

    @invitation = @event.invitations.create :participant_id => @friend.id, :character_id => @friend_character.id
    assert_no_difference "@event.reload.invitations_count" do
      @friend_sess.put "/events/#{@event.id}/invitations/#{@invitation.id}/accept", {:status => 'invalid'}
    end
    assert_difference "@event.reload.invitations_count", -1 do
      assert_difference "@friend.reload.upcoming_events.count" do
        @friend_sess.put "/events/#{@event.id}/invitations/#{@invitation.id}/accept", {:status => Participation::Confirmed}
      end
    end
  end

  test "invite, accept/decline" do
    @event = EventFactory.create :character_id => @user_character.id
    FriendFactory.create @user, @same_game_user

    @user_sess.get "/events/#{@event.id}/invitations/new"
    @user_sess.assert_template "user/events/invitations/new"

    @user_sess.post "/events/#{@event.id}/invitations", {:values => [@friend_character.id, @same_game_user_character.id]}
    @user_sess.assert_redirected_to event_url(@event)
    @invitation1 = @event.invitations.first
    @invitation2 = @event.invitations.last

    @friend_sess.get "/events/#{@event.id}"
    @friend_sess.assert_template "user/events/show"
    @friend_sess.get "/events/#{@event.id}/invitations/#{@invitation1.id}/edit"
    @friend_sess.assert_template "user/events/invitations/edit"
    assert_no_difference "@event.reload.participants_count" do
      @friend_sess.delete "/events/#{@event.id}/invitations/#{@invitation1.id}/decline"
    end

    @same_game_user_sess.get "/events/#{@event.id}"
    @same_game_user_sess.assert_template "user/events/show"
    @same_game_user_sess.get "/events/#{@event.id}/invitations/#{@invitation2.id}/edit"
    @same_game_user_sess.assert_template "user/events/invitations/edit"
    assert_difference "@event.reload.participants_count" do
      @same_game_user_sess.put "/events/#{@event.id}/invitations/#{@invitation2.id}/accept", {:status => Participation::Confirmed}
    end

  end

  test "GET /events/:id/requests/new" do
    @event = EventFactory.create :character_id => @user_character.id

    @event.unverify
    @user_sess.get "/events/#{@event.id}/requests/new"
    @user_sess.assert_not_found
    @event.verify

    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @idol_sess, @fan_sess].each do |sess|
      sess.get "/events/#{@event.id}/requests/new"
      sess.assert_template "user/events/requests/new"
    end

    # only friend can attend
    @event = EventFactory.create :character_id => @user_character.id, :privilege => 2

    [@user_sess, @friend_sess].each do |sess|
      sess.get "/events/#{@event.id}/requests/new"
      sess.assert_template "user/events/requests/new"
    end

    [@same_game_user_sess, @stranger_sess, @idol_sess, @fan_sess].each do |sess|
      sess.get "/events/#{@event.id}/requests/new"  
      sess.assert_not_found
    end
   
    # guild event 
    @event = EventFactory.create :character_id => @user_character.id, :guild_id => @guild.id

    [@user_sess, @friend_sess].each do |sess|
      sess.get "/events/#{@event.id}/requests/new"
      sess.assert_template "user/events/requests/new"
    end

    [@same_game_user_sess, @stranger_sess, @idol_sess, @fan_sess].each do |sess|
      sess.get "/events/#{@event.id}/requests/new"  
      sess.assert_not_found
    end
  end

  test "POST /events/:id/requests" do
    @event = EventFactory.create :character_id => @user_character.id
    @stranger_character = GameCharacterFactory.create

    @event.unverify
    @friend_sess.post "/events/#{@event.id}/requests", {:request => {:character_id => @friend_character.id}}
    @friend_sess.assert_not_found
    @event.verify

    assert_difference "@event.reload.requests_count" do
      @friend_sess.post "/events/#{@event.id}/requests", {:request => {:character_id => @friend_character.id}}
    end

    assert_no_difference "@event.reload.requests_count" do
      @stranger_sess.post "/events/#{@event.id}/requests", {:request => {:character_id => @stranger_character.id}}
    end

    @event = EventFactory.create :character_id => @user_character.id, :privilege => 2
    @fan_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @fan.id})

    assert_difference "@event.reload.requests_count" do
      @friend_sess.post "/events/#{@event.id}/requests", {:request => {:character_id => @friend_character.id}}
    end

    assert_no_difference "@event.reload.requests_count" do
      @fan_sess.post "/events/#{@event.id}/requests", {:request => {:character_id => @fan_character.id}}
    end
    
    # guild event 
    @event = EventFactory.create :character_id => @user_character.id, :guild_id => @guild.id

    assert_difference "@event.reload.requests_count" do
      @friend_sess.post "/events/#{@event.id}/requests", {:request => {:character_id => @friend_character.id}}
    end

    assert_no_difference "@event.reload.requests_count" do
      @fan_sess.post "/events/#{@event.id}/requests", {:request => {:character_id => @fan_character.id}}
    end
  end

  test "accept/decline request" do
    @event = EventFactory.create :character_id => @user_character.id
    @stranger_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @stranger.id})
    @request1 = @event.requests.create :participant_id => @friend.id, :character_id => @friend_character.id
    @request2 = @event.requests.create :participant_id => @stranger.id, :character_id => @stranger_character.id
  
    @friend_sess.put "/events/#{@event.id}/requests/#{@request1.id}/accept", {:status => Participation::Confirmed}
    @friend_sess.assert_not_found
    @stranger_sess.delete "/events/#{@event.id}/requests/#{@request2.id}/decline"
    @stranger_sess.assert_not_found

    @event.unverify
    @user_sess.put "/events/#{@event.id}/requests/#{@request1.id}/accept"
    @user_sess.assert_not_found
    @user_sess.delete "/events/#{@event.id}/requests/#{@request1.id}/decline"
    @user_sess.assert_not_found
    @event.verify

    @user_sess.put "/events/invalid/requests/#{@request1.id}/accept"
    @user_sess.assert_not_found
    @user_sess.put "/events/#{@event.id}/requests/invalid/accept"
    @user_sess.assert_not_found
    @user_sess.delete "/events/invalid/requests/#{@request1.id}/decline"
    @user_sess.assert_not_found
    @user_sess.delete "/events/#{@event.id}/requests/invalid/decline"
    @user_sess.assert_not_found

    assert_difference "@event.reload.requests_count", -1 do
      assert_difference "@friend.reload.upcoming_events.count" do
        @user_sess.put "/events/#{@event.id}/requests/#{@request1.id}/accept"
      end
    end
    assert_difference "@event.reload.requests_count", -1 do
      assert_no_difference "@stranger.reload.upcoming_events.count" do
        @user_sess.delete "/events/#{@event.id}/requests/#{@request2.id}/decline"
      end
    end
  end

  test "send request, accept/decline" do
    @event = EventFactory.create :character_id => @user_character.id
    @stranger_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @stranger.id})

    @friend_sess.get "/events/#{@event.id}/requests/new"
    @friend_sess.assert_template "user/events/requests/new"
    @friend_sess.post "/events/#{@event.id}/requests", {:request => {:character_id => @friend_character.id}}
    @request1 = @friend_sess.assigns(:request)

    assert_difference "@event.reload.requests_count", -1 do
      assert_difference "@friend.reload.upcoming_events.count" do
        @user_sess.put "/events/#{@event.id}/requests/#{@request1.id}/accept"
      end
    end

    @stranger_sess.get "/events/#{@event.id}/requests/new"
    @stranger_sess.assert_template "user/events/requests/new"
    @stranger_sess.post "/events/#{@event.id}/requests", {:request => {:character_id => @stranger_character.id}}
    @request2 = @stranger_sess.assigns(:request)

    assert_difference "@event.reload.requests_count", -1 do
      assert_no_difference "@stranger.reload.upcoming_events.count" do
        @user_sess.delete "/events/#{@event.id}/requests/#{@request2.id}/decline"
      end
    end
  end

  test "change status" do
    @event = EventFactory.create :character_id => @user_character.id
    @p = @event.confirmed_participations.create :participant_id => @friend.id, :character_id => @friend_character.id

    @user_sess.get "/events/#{@event.id}/participations/#{@p.id}/edit"
    @user_sess.assert_not_found
    @user_sess.put "/events/#{@event.id}/participations/#{@p.id}", {:status => Participation::Maybe}
    @user_sess.assert_not_found

    @event.unverify
    @friend_sess.get "/events/#{@event.id}/participations/#{@p.id}/edit"
    @friend_sess.assert_not_found
    @friend_sess.put "/events/#{@event.id}/participations/#{@p.id}", {:status => Participation::Maybe}
    @friend_sess.assert_not_found
    @event.verify

    @friend_sess.get "/events/invalid/participations/#{@p.id}/edit"
    @friend_sess.assert_not_found
    @friend_sess.get "/events/#{@event.id}/participations/invalid/edit"
    @friend_sess.assert_not_found

    @friend_sess.get "/events/#{@event.id}/participations/#{@p.id}/edit"
    @friend_sess.assert_template "user/events/participations/edit"
    assert_difference "@user.reload.notifications_count" do
      @friend_sess.put "/events/#{@event.id}/participations/#{@p.id}", {:status => Participation::Maybe}
    end
    @p.reload
    assert_equal @p.status, Participation::Maybe
  end

  test "evict participant" do
    @event = EventFactory.create :character_id => @user_character.id
    @p = @event.confirmed_participations.create :participant_id => @friend.id, :character_id => @friend_character.id

    @event.unverify
    @friend_sess.delete "/events/#{@event.id}/participations/#{@p.id}"
    @friend_sess.assert_not_found
    @event.verify

    @friend_sess.delete "/events/#{@event.id}/participations/#{@p.id}"
    @friend_sess.assert_not_found
    @friend_sess.delete "/events/invalid/participations/#{@p.id}"
    @friend_sess.assert_not_found
    @friend_sess.delete "/events/#{@event.id}/participations/invalid"
    @friend_sess.assert_not_found

    assert_difference "@friend.reload.notifications_count" do
      assert_difference "@event.reload.participants_count", -1 do
        @user_sess.delete "/events/#{@event.id}/participations/#{@p.id}"
      end
    end
  end

end
