require 'test_helper'

class EventFlowTest < ActionController::IntegrationTest

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

  test "GET /events/hot" do
    @event1 = EventFactory.create :character_id => @user_character.id, :start_time => 1.seconds.from_now
    sleep 1
    @event2 = EventFactory.create :character_id => @user_character.id, :start_time => 2.seconds.from_now
    sleep 1
    @event3 = EventFactory.create :character_id => @user_character.id, :guild_id => @guild.id, :start_time => 3.seconds.from_now
    sleep 1
    @event4 = EventFactory.create :character_id => @user_character.id, :privilege => 2, :start_time => 2.seconds.from_now

    @event1.confirmed_participations.create :participant_id => @friend.id, :character_id => @friend_character.id
    @event1.maybe_participations.create :participant_id => @same_game_user.id, :character_id => @same_game_user_character.id
    @event2.confirmed_participations.create :participant_id => @friend.id, :character_id => @friend_character.id
    @event2.confirmed_participations.create :participant_id => @same_game_user.id, :character_id => @same_game_user_character.id
    @event3.confirmed_participations.create :participant_id => @friend.id, :character_id => @friend_character.id

    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/events/hot"
      sess.assert_template "user/events/hot"
      assert_equal sess.assigns(:events), [@event2, @event1, @event3, @event4]
    end

    [@stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/events/hot"
      sess.assert_template "user/events/hot"
      assert_equal sess.assigns(:events), []
    end

    @event3.unverify
    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/events/hot"
      sess.assert_template "user/events/hot"
      assert_equal sess.assigns(:events), [@event2, @event1, @event4]
    end

    @event2.update_attributes :start_time => 1.seconds.from_now, :end_time => 2.seconds.from_now
    sleep 3 # ensure event2 expires

=begin
    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/events/hot"
      sess.assert_template "user/events/hot"
      assert_equal sess.assigns(:events), [@event1, @event4]
    end
=end
  end

  test "GET /events/recent" do
    @event1 = EventFactory.create :character_id => @user_character.id
    sleep 1
    @event2 = EventFactory.create :character_id => @user_character.id
    sleep 1
    @event3 = EventFactory.create :character_id => @user_character.id, :guild_id => @guild.id
    sleep 1
    @event4 = EventFactory.create :character_id => @user_character.id, :privilege => 2
  
    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/events/recent"
      sess.assert_template "user/events/recent"
      assert_equal sess.assigns(:events), [@event4, @event3, @event2, @event1]
    end

    [@stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/events/recent"
      sess.assert_template "user/events/recent"
      assert_equal sess.assigns(:events), []
    end

    @event4.unverify
    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/events/recent"
      sess.assert_template "user/events/recent"
      assert_equal sess.assigns(:events), [@event3, @event2, @event1]
    end
    
    @event3.update_attributes :start_time => 1.seconds.from_now, :end_time => 2.seconds.from_now
    sleep 3 # ensure event3 expires

=begin
    [@user_sess, @friend_sess, @same_game_user_sess].each do |sess|
      sess.get "/events/recent"
      sess.assert_template "user/events/recent"
      assert_equal sess.assigns(:events), [@event2, @event1]
    end
=end
  end

  test "GET /events/friends" do
    @event1 = EventFactory.create :character_id => @user_character.id
    sleep 1
    @event2 = EventFactory.create :character_id => @user_character.id
    sleep 1
    @event3 = EventFactory.create :character_id => @friend_character.id, :guild_id => @guild.id
    sleep 1
    @event4 = EventFactory.create :character_id => @friend_character.id, :privilege => 2
    
    @event1.confirmed_participations.create :participant_id => @friend.id, :character_id => @friend_character.id
    @event3.confirmed_participations.create :participant_id => @user.id, :character_id => @user_character.id

    @user_sess.get "/events/friends"
    @user_sess.assert_template "user/events/friends"
    assert_equal @user_sess.assigns(:events), [@event4, @event3, @event1]

    @friend_sess.get "/events/friends"
    @friend_sess.assert_template "user/events/friends"
    assert_equal @friend_sess.assigns(:events), [@event3, @event2, @event1]
  end

  test "GET /events/:id" do
    @fan_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @fan.id})
    @idol_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @idol.id})
    @event1 = EventFactory.create :character_id => @user_character.id
    @event2 = EventFactory.create :character_id => @friend_character.id, :guild_id => @guild.id

    @event1.invitations.create :participant_id => @friend.id, :character_id => @friend_character.id
    @event1.requests.create :participant_id => @same_game_user.id, :character_id => @same_game_user_character.id
    @event1.maybe_participations.create :participant_id => @fan.id, :character_id => @fan_character.id

    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/events/#{@event1.id}"
      sess.assert_template "user/events/show"
    end

    @guild.member_memberships.create :user_id => @fan.id, :character_id => @fan_character.id
    @guild.member_memberships.create :user_id => @idol.id, :character_id => @idol_character.id
    @guild.member_memberships.create :user_id => @same_game_user.id, :character_id => @same_game_user_character.id
    @event2.requests.create :participant_id => @fan.id, :character_id => @fan_character.id
    @event2.invitations.create :participant_id => @idol.id, :character_id => @idol_character.id
    @event2.maybe_participations.create :participant_id => @friend.id, :character_id => @friend_character.id
    
    [@user_sess, @friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/events/#{@event2.id}"
      sess.assert_template "user/events/show"
    end
  end

  test "GET /events" do
    @event1 = EventFactory.create :character_id => @user_character.id
    sleep 1
    @event2 = EventFactory.create :character_id => @user_character.id
    sleep 1
    @event3 = EventFactory.create :character_id => @user_character.id, :guild_id => @guild.id
    sleep 1
    @event4 = EventFactory.create :character_id => @user_character.id, :privilege => 2

    [@user_sess, @friend_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/events", {:uid => @user.id}
      sess.assert_template 'user/events/index'
      assert_equal sess.assigns(:events), [@event4, @event3, @event2, @event1]
    end
    
    [@same_game_user_sess, @stranger_sess].each do |sess|
      sess.get "/events", {:uid => @user.id}
      sess.assert_redirected_to new_friend_url(:uid => @user.id)
    end
    
    @user_sess.get "/events", {:uid => 'invalid'}
    @user_sess.assert_not_found

    @event3.unverify and @event4.unverify

    @user_sess.get "/events", {:uid => @user.id}
    @user_sess.assert_template 'user/events/index'
    assert_equal @user_sess.assigns(:events), [@event2, @event1]
  end
  
  test "GET /events/upcoming" do
    @event1 = EventFactory.create :character_id => @friend_character.id
    @event2 = EventFactory.create :character_id => @friend_character.id
    @event3 = EventFactory.create :character_id => @friend_character.id, :guild_id => @guild.id
    @event4 = EventFactory.create :character_id => @friend_character.id, :privilege => 2
    [@event1, @event2, @event3, @event4].each do |e|
      e.confirmed_participations.create :participant_id => @user.id, :character_id => @user_character.id
    end 

    [@user_sess, @friend_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/events/upcoming", {:uid => @user.id}
      sess.assert_template 'user/events/upcoming'
      assert_equal sess.assigns(:events), [@event1, @event2, @event3, @event4]
    end
    
    [@same_game_user_sess, @stranger_sess].each do |sess|
      sess.get "/events/upcoming", {:uid => @user.id}
      sess.assert_redirected_to new_friend_url(:uid => @user.id)
    end
    
    @user_sess.get "/events/upcoming", {:uid => 'invalid'}
    @user_sess.assert_not_found

    @event3.unverify and @event4.unverify

    @user_sess.get "/events/upcoming", {:uid => @user.id}
    @user_sess.assert_template 'user/events/upcoming'
    assert_equal @user_sess.assigns(:events), [@event1, @event2]
  end

=begin
  # 有问题阿
  test "GET /events/participated" do
    @event1 = EventFactory.create :character_id => @friend_character.id, :start_time => 1.seconds.from_now, :end_time => 2.seconds.from_now
    @event2 = EventFactory.create :character_id => @friend_character.id, :start_time => 1.seconds.from_now, :end_time => 3.seconds.from_now
    @event3 = EventFactory.create :character_id => @friend_character.id, :guild_id => @guild.id, :start_time => 1.seconds.from_now, :end_time => 4.seconds.from_now
    [@event1, @event2, @event3].each do |e|
      e.confirmed_participations.create :participant_id => @user.id, :character_id => @user_character.id
    end

    sleep 10
    @user.reload
    
    [@user_sess, @friend_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/events/participated", {:uid => @user.id}
      sess.assert_template "user/events/participated"
      assert_equal sess.assigns(:events), [@event1, @event2, @event3]
    end

    [@stranger_sess, @same_game_user_sess].each do |sess|
      sess.get "/events/participated", {:uid => @user.id}
      sess.assert_redirected_to "user/events/participated"
    end

    @user_sess.get "/events/participated", {:uid => 'invalid'}
    @user_sess.assert_not_found

    @event2.unverify
    @user_sess.get "/events/participated", {:uid => @user.id}
    @user_sess.assert_template "user/events/participated"
    assert_equal @user_sess.assigns(:events), [@event1, @event3]
  end
=end
  test "POST /events" do
    # create normal event
    @user_sess.get "/events/new"
    @user_sess.assert_template "user/events/new"
  
    assert_difference ["Event.count", "Participation.count"] do
      @user_sess.post "/events", {:event => {:start_time => 1.days.from_now, :end_time => 2.days.from_now, :privilege => 1, :title => 't', :description => 'd', :character_id => @user_character.id}}
    end
    @event = @user_sess.assigns(:event)
    @user_sess.assert_redirected_to new_event_invitation_url(@event)

    assert_no_difference "Event.count" do
      @user_sess.post "/events", {:event => {:start_time => 1.days.ago, :end_time => 2.days.from_now, :privilege => 1, :title => 't', :description => 'd', :character_id => @user_character.id}}
    end

    # create guild event
    @user_sess.get "/events/new", {:guild_id => @guild.id}
    @user_sess.assert_template "user/events/new"
    assert_equal @user_sess.assigns(:guild), @guild

    assert_difference ["Event.count", "Participation.count"] do
      @user_sess.post "/events", {:event => {:start_time => 1.days.from_now, :end_time =>  2.days.from_now, :privilege => 1, :title => 't', :description => 'd', :character_id => @user_character.id, :guild_id => @guild.id}}
    end
    @event = @user_sess.assigns(:event)
    @user_sess.assert_redirected_to new_event_invitation_url(@event)
    assert_equal @event.guild, @guild

    @temp_character = GameCharacterFactory.create :user_id => @user.id
    assert_no_difference "Event.count" do
      @user_sess.post "/events", {:event => {:start_time => 1.days.from_now, :end_time => 2.days.from_now, :privilege => 1, :title => 't', :description => 'd', :character_id => @temp_character.id, :guild_id => @guild.id}}
    end
  end
  
  test "PUT /events/:id" do
    @event = EventFactory.create :character_id => @user_character.id  
    @event.confirmed_participations.create :character_id => @friend_character.id, :participant_id => @friend.id    

    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.get "/events/#{@event.id}/edit"
      sess.assert_not_found
      sess.put "/events/#{@event.id}", {:event => {:title => 'fuck'}}
      sess.assert_not_found
    end

    @user_sess.get "/events/invalid/edit"
    @user_sess.assert_not_found
    @user_sess.put "/events/invalid", {:event => {:title => 'fuck'}}
    @user_sess.assert_not_found
  
    @user_sess.get "/events/#{@event.id}/edit"
    @user_sess.assert_template "user/events/edit"
    assert_equal @user_sess.assigns(:event), @event

    @user_sess.put "/events/#{@event.id}", {:event => {:title => 'fuck'}}
    @user_sess.assert_redirected_to event_url(@event)
    @event.reload
    assert_equal @event.title, 'fuck'

    assert_difference "Email.count", 2 do
      @user_sess.put "/events/#{@event.id}", {:event => {:start_time => 1.days.ago}}
    end

    assert_no_difference "Email.count" do
      @user_sess.put "/events/#{@event.id}", {:event => {:end_time => 1.seconds.ago}}
    end

    assert_difference "Email.count", 2 do
      @user_sess.put "/events/#{@event.id}", {:event => {:start_time => 1.seconds.from_now}}
    end
  end

  test "DELETE /events/:id" do
    @event = EventFactory.create :character_id => @user_character.id
    @event.confirmed_participations.create :character_id => @friend_character.id, :participant_id => @friend.id

    [@friend_sess, @same_game_user_sess, @stranger_sess, @fan_sess, @idol_sess].each do |sess|
      sess.delete "/events/#{@event.id}"
      sess.assert_not_found
    end

    assert_difference "Event.count", -1 do
      @user_sess.delete "/events/#{@event.id}"
    end

    @user_sess.delete "/events/invalid"
    @user_sess.assert_not_found
  end

end
