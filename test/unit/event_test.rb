require 'test_helper'

#
# TODO: upcoming
#

class EventTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create_idol
    @idol = UserFactory.create_idol
    @fan = UserFactory.create
    @friend = UserFactory.create
    @stranger = UserFactory.create
    @user_character = GameCharacterFactory.create :user_id => @user.id
    @friend_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @friend.id})
    @stranger_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @stranger.id})    
    
    FriendFactory.create @user, @friend
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id    
    [@user, @friend, @fan, @idol].each {|f| f.reload}

    @sensitive = "政府"
  end
  
  test "create normal event" do
    assert_difference "Event.count" do
      @event = Event.create :character_id => @user_character.id, :start_time => 1.days.from_now, :end_time => 2.days.from_now, :title => 't', :description => 'd'
    end

    assert_not_nil @event.album
    assert @event.has_participant?(@user)    
    assert_equal @event.poster, @user
    assert_equal @event.poster_character, @user_character
    assert !@event.is_guild_event?
    assert_nil @event.guild
    assert_equal @event.game_id, @user_character.game_id
    assert_equal @event.game_server_id, @user_character.server_id
    assert_equal @event.game_area_id, @user_character.area_id
  end

  test "fail to create normal event" do
    assert_no_difference "Event.count" do
      @event = Event.create :character_id => nil, :start_time => 1.days.from_now, :end_time => 2.days.from_now, :title => 't', :description => 'd'
    end
    assert_not_nil @event.errors.on(:character_id) 
  
    assert_no_difference "Event.count" do
      @event = Event.create :character_id => @user_character.id, :privilege => nil, :start_time => 1.days.from_now, :end_time => 2.days.from_now, :title => 't', :description => 'd'
    end
    assert_not_nil @event.errors.on(:privilege) 

    assert_no_difference "Event.count" do
      @event = Event.create :character_id => @user_character.id, :start_time => 1.days.ago, :end_time => 2.days.from_now, :title => 't', :description => 'd'
    end
    assert_not_nil @event.errors.on(:start_time) 

    assert_no_difference "Event.count" do
      @event = Event.create :character_id => @user_character.id, :start_time => 3.days.from_now, :end_time => 2.days.from_now, :title => 't', :description => 'd'
    end
    assert_not_nil @event.errors.on(:end_time)
  end

  test "create guild event" do
    @guild = GuildFactory.create :character_id => @user_character.id
    
    assert_difference "Event.count" do
      @event = Event.create :character_id => @user_character.id, :start_time => 1.days.from_now, :end_time => 2.days.from_now, :title => 't', :description => 'd', :guild_id => @guild.id
    end

    assert_not_nil @event.album
    assert @event.has_participant?(@user)
    assert_equal @event.poster, @user
    assert @event.is_guild_event?
    assert_equal @event.guild, @guild
    assert_equal @event.game_id, @user_character.game_id
    assert_equal @event.game_server_id, @user_character.server_id
    assert_equal @event.game_area_id, @user_character.area_id
  end 
  
  test "fail to create guild event" do
    @guild1 = GuildFactory.create :character_id => @friend_character.id
    @guild2 = GuildFactory.create :character_id => @stranger_character.id
    @guild1.member_memberships.create :user_id => @user.id, :character_id => @user_character.id
    @user_character2 = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @user.id})
    @guild2.veteran_memberships.create :user_id => @user.id, :character_id => @user_character2.id

    assert_no_difference "Event.count" do
      @event = Event.create :character_id => @user_character.id, :start_time => 1.days.ago, :end_time => 2.days.from_now, :title => 't', :description => 'd', :guild_id => 'invalid'
    end
  
    assert_no_difference "Event.count" do
      @event = Event.create :character_id => @user_character.id, :start_time => 1.days.ago, :end_time => 2.days.from_now, :title => 't', :description => 'd', :guild_id => @guild1.id
    end

    assert_no_difference "Event.count" do
      @event = Event.create :character_id => @user_character2.id, :start_time => 1.days.from_now, :end_time => 2.days.from_now, :title => 't', :description => 'd', :guild_id => @guild1.id
    end

    assert_difference "Event.count" do
      @event = Event.create :character_id => @user_character2.id, :start_time => 1.days.from_now, :end_time => 2.days.from_now, :title => 't', :description => 'd', :guild_id => @guild2.id
    end
  end

=begin
  test "upcoming, participated, index" do
    @event1 = EventFactory.create :character_id => @user_character.id
    @event2 = EventFactory.create :character_id => @friend_character.id, :start_time => 1.seconds.from_now, :end_time => 3.seconds.from_now
    @event3 = EventFactory.create :character_id => @stranger_character.id, :start_time => 4.seconds.from_now, :end_time => 6.seconds.from_now

    # @user participates in event2 and event3
    assert_difference "Participation.count", 2 do
      @event2.participations.create :participant_id => @user.id, :character_id => @user_character.id, :status => Participation::Confirmed
      @event3.participations.create :participant_id => @user.id, :character_id => @user_character.id, :status => Participation::Maybe
    end
    @user.reload
    assert_equal @user.upcoming_events, [@event2, @event3]
    assert_equal @user.participated_events, []
    sleep 2
    puts "upcoming: #{@user.upcoming_events.map(&:id)}"
    assert @event2.started?
    assert !@event2.expired?
    @user.reload
    assert_equal @user.upcoming_events, [@event2, @event3]
    assert_equal @user.participated_events, []

    sleep 3
    puts "upcoming: #{@user.upcoming_events.map(&:id)}"
    assert @event2.expired?
    assert @event3.started?
    assert !@event3.expired?
    @user.reload
    assert_equal @user.upcoming_events, [@event3]
    assert_equal @user.participated_events, [@event2]

    sleep 2
    puts "upcoming: #{@user.upcoming_events.map(&:id)}"
    assert @event3.expired?
    @user.reload
    assert_equal @user.upcoming_events, []
    assert_equal @user.participated_events, [@event3, @event2]
  end
=end 
  test "edit/update event" do
    @event = EventFactory.create :character_id => @user_character.id
    
    assert @event.update_attributes(:title => 'new event title')
    assert @event.update_attributes(:start_time => 10.days.from_now, :end_time => 12.days.from_now)
    assert !@event.update_attributes(:end_time => 9.days.from_now)
    assert @event.update_attributes(:start_time => 1.days.ago, :end_time => 1.days.from_now)
    assert !@event.update_attributes(:start_time => Time.now, :end_time => 1.seconds.ago)
  end

  test "change time of event" do
    @event = EventFactory.create :character_id => @user_character.id
    @event.maybe_participations.create :participant_id => @friend.id, :character_id => @friend_character.id
 
    assert_difference ["Notification.count", "Email.count"], 2 do 
      @event.update_attributes(:start_time => 10.minutes.from_now)
    end
  end

  test "delete event" do
  end
 
  test "comment event" do
    @event = EventFactory.create :character_id => @user_character.id

    assert @event.is_commentable_by?(@user)
    assert !@event.is_commentable_by?(@friend)
    assert !@event.is_commentable_by?(@stranger)
  
    @event.confirmed_participations.create :participant_id => @friend.id, :character_id => @friend_character.id
    assert @event.is_commentable_by?(@friend)

    @comment = @event.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @event.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@stranger)
  end

  test "comment notice" do
    @event = EventFactory.create :character_id => @user_character.id
    @event.confirmed_participations.create :participant_id => @friend.id, :character_id => @friend_character.id
    @event.confirmed_participations.create :participant_id => @stranger.id, :character_id => @stranger_character.id

    assert_no_difference "Notice.count" do
      @comment = @event.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    end
 
    assert_difference "Notice.count" do
      @comment = @event.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload
    assert @user.recv_notice?(@comment)

    assert_difference "Notice.count", 2 do
      @comment = @event.comments.create :poster_id => @stranger.id, :recipient_id => @friend.id, :content => 'a'
    end
    @user.reload and @friend.reload
    assert @friend.recv_notice?(@comment)
    assert @user.recv_notice?(@comment)
  end

  test "event feed" do
    @guild = GuildFactory.create :character_id => @friend_character.id
    @guild.memberships.create :user_id => @user.id, :character_id => @friend_character.id, :status => Membership::Member
    @game = @guild.game
    @profile = @user.profile
    
    @event = EventFactory.create :character_id => @user_character.id

    [@game, @profile, @guild, @friend, @fan, @idol].each {|t| t.reload}
    assert @profile.recv_feed?(@event)
    assert @game.recv_feed?(@event)
    assert @guild.recv_feed?(@event)
    assert @friend.recv_feed?(@event)
    assert @fan.recv_feed?(@event)
    assert !@idol.recv_feed?(@event)
  
    @event.unverify
    [@game, @profile, @guild, @friend, @fan, @idol].each {|t| t.reload}
    assert !@profile.recv_feed?(@event)
    assert !@game.recv_feed?(@event)
    assert !@guild.recv_feed?(@event)
    assert !@friend.recv_feed?(@event)
    assert !@fan.recv_feed?(@event)
    assert !@idol.recv_feed?(@event)

    @event.verify
    [@game, @profile, @guild, @friend, @fan, @idol].each {|t| t.reload}
    assert !@profile.recv_feed?(@event)
    assert !@game.recv_feed?(@event)
    assert !@guild.recv_feed?(@event)
    assert !@friend.recv_feed?(@event)
    assert !@fan.recv_feed?(@event)
    assert !@idol.recv_feed?(@event)
  end
  
  test "sensitive event" do
    @event = EventFactory.create :character_id => @user_character.id
    assert @event.accepted? 
    
    @event = EventFactory.create :character_id => @user_character.id, :title => @sensitive
    assert @event.unverified?

    @event.verify
    @event.update_attributes(:title => "#{@sensitive}sb")
    @event.reload
    assert @event.unverified?

    @album = @event.album
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'

    @event.unverify
    @album.reload and @photo.reload
    assert @album.rejected?
    assert @photo.rejected?
  end

end
