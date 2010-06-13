require 'test_helper'

class ParticipationTest < ActiveSupport::TestCase

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

  test "send invitation, normal event" do
    @event = EventFactory.create :character_id => @user_character.id

    assert_no_difference "@event.reload.invitations_count" do
      @event.invite [@friend_character, @stranger_character]
    end
    
    assert_difference "@event.reload.invitations_count" do
      assert_difference "@friend.reload.event_invitations_count" do
        @event.invite [@friend_character]
      end
    end
    assert_equal @event.invitees, [@friend]
  
    # 非好友不能邀请
    assert_no_difference "@event.reload.invitations_count" do
      @event.invite [@stranger_character]
    end
   
    # 已经请求加入的角色不能邀请
    @request = @event.requests.create :participant_id => @stranger.id, :character_id => @stranger_character.id
    assert_no_difference "@event.reload.invitations_count" do
      @event.invite [@stranger_character]
    end
    @request.destroy

    # 已经邀请的角色不能邀请
    @invitation = @event.invitations.create :participant_id => @stranger.id, :character_id => @stranger_character.id
    assert_no_difference "@event.reload.invitations_count" do
      @event.invite [@stranger_character]
    end
    @invitation.destroy

    # 已经加入的角色不能再邀请
    @event.confirmed_participations.create :participant_id => @stranger.id, :character_id => @stranger_character.id
    assert_no_difference "@event.reload.invitations_count" do
      @event.invite [@stranger_character]
    end    
  end

  test "guild event" do
    @guild = GuildFactory.create :character_id => @user_character.id 
    @event = EventFactory.create :character_id => @user_character.id, :guild_id => @guild.id

    assert_no_difference "@event.reload.invitations_count" do
      @event.invite [@friend_character]
    end

    assert_no_difference "@event.reload.invitations_count" do
      @event.invite [@stranger_character]
    end

    @guild.member_memberships.create :user_id => @friend.id, :character_id => @friend_character.id

    assert_no_difference "@event.reload.invitations_count" do
      @event.invite [@friend_character, @stranger_character]
    end

    assert_difference "@event.reload.invitations_count" do
      @event.invite [@friend_character]
    end
    assert_equal @event.invitees, [@friend]

    @guild.member_memberships.create :user_id => @stranger.id, :character_id => @stranger_character.id
    
    assert_difference "@event.reload.invitations_count" do
      @event.invite [@stranger_character]
    end
  
    # 已经请求加入，已经邀请的，已经加入的无法再邀请，这些在上一个测试都测了
  end

  test "decline invitation" do
    @event = EventFactory.create :character_id => @user_character.id
  
    assert_difference "@event.reload.invitations_count" do
      assert_difference "@friend.reload.event_invitations_count" do
        @event.invite [@friend_character]
      end
    end
    @invitation = @event.invitations.last
  
    assert_difference "Notification.count" do
      assert_difference "@event.reload.invitations_count", -1 do
        assert_no_difference "@event.confirmed_participations.count", "@event.maybe_participations.count" do 
          @invitation.decline_invitation
        end
      end
    end
  end

  test "accept invitation" do
    @event = EventFactory.create :character_id => @user_character.id

    assert_difference "@event.reload.invitations_count" do
      assert_difference "@friend.reload.event_invitations_count" do
        @event.invite [@friend_character]
      end
    end
    @invitation = @event.invitations.last

    assert_difference "Notification.count" do
      assert_difference "@event.reload.invitations_count", -1 do
        assert_difference "@event.confirmed_participations.count" do
          @invitation.accept_invitation Participation::Confirmed
        end
      end
    end
  end

  test "send request, normal event, all can send" do
    @event = EventFactory.create :character_id => @user_character.id
    @sb = UserFactory.create
    @sb_character = GameCharacterFactory.create :user_id => @sb.id

    # 没有相应的游戏角色
    assert_no_difference "@event.reload.requests_count" do
      @event.requests.create :character_id => @sb_character.id, :participant_id => @sb.id
    end

    assert_difference "@event.reload.requests_count" do
      assert_difference "@user.reload.event_requests_count" do
        @event.requests.create :character_id => @stranger_character.id, :participant_id => @stranger.id
      end
    end

    # 已经发送请求的
    @request = @event.requests.create :character_id => @friend_character.id, :participant_id => @friend.id
    assert_no_difference "@event.reload.requests_count" do
      @event.requests.create :character_id => @friend_character.id, :participant_id => @friend.id
    end
    @request.destroy

    # 已经发送邀请的
    @invitation = @event.invitations.create :character_id => @friend_character.id, :participant_id => @friend.id 
    assert_no_difference "@event.reload.requests_count" do
      @request = @event.requests.create :character_id => @friend_character.id, :participant_id => @friend.id 
    end 
    @invitation.destroy

    # 已经参加的
    @participation = @event.confirmed_participations.create :character_id => @friend_character.id, :participant_id => @friend.id 
    assert_no_difference "@event.reload.requests_count" do
      @event.requests.create :character_id => @friend_character.id, :participant_id => @friend.id
    end 
    @participation.destroy

    assert_difference "@event.reload.requests_count" do
      @event.requests.create :character_id => @friend_character.id, :participant_id => @friend.id
    end 
  end

  test "send request, normal event, only friends can send" do
    @event = EventFactory.create :character_id => @user_character.id, :privilege => 2

    assert_difference "@event.reload.requests_count" do
      @event.requests.create :character_id => @friend_character.id, :participant_id => @friend.id
    end

    # 不是好友
    assert_no_difference "@event.reload.requests_count" do
      @event.requests.create :character_id => @stranger_character.id, :participant_id => @stranger.id
    end
  end

  test "send request, guild event, only members can send" do
    @guild = GuildFactory.create :character_id => @user_character.id
    @event = EventFactory.create :character_id => @user_character.id, :guild_id => @guild.id

    assert_no_difference "@event.reload.requests_count" do
      @event.requests.create :character_id => @friend_character.id, :participant_id => @friend.id
    end

    @guild.member_memberships.create :character_id => @friend_character.id, :user_id => @friend.id
    assert_difference "@event.reload.requests_count" do
      @event.requests.create :character_id => @friend_character.id, :participant_id => @friend.id
    end

    assert_no_difference "@event.reload.requests_count" do
      @event.requests.create :character_id => @friend_character.id, :participant_id => @friend.id
    end
  end

  test "decline request" do
    @event = EventFactory.create :character_id => @user_character.id

    assert_difference "@event.reload.requests_count" do
      assert_difference "@user.reload.event_requests_count" do
        @request = @event.requests.create :character_id => @stranger_character.id, :participant_id => @stranger.id
      end
    end

    assert_difference "Notification.count" do
      assert_difference "@event.reload.requests_count", -1 do
        assert_no_difference "@event.confirmed_participations.count", "@event.maybe_participations.count" do
          @request.decline_request
        end
      end
    end
  end

  test "accept request" do
    @event = EventFactory.create :character_id => @user_character.id

    assert_difference "@event.reload.requests_count" do
      assert_difference "@user.reload.event_requests_count" do
        @request = @event.requests.create :character_id => @stranger_character.id, :participant_id => @stranger.id
      end
    end

    assert_difference "Notification.count" do
      assert_difference "@event.reload.requests_count", -1 do
        assert_difference "@event.confirmed_participations.count" do
          @request.accept_request
        end
      end
    end
  end

  test "participant counter" do
    @event = EventFactory.create :character_id => @user_character.id

    @p = @event.confirmed_participations.create :character_id => @friend_character.id, :participant_id => @friend.id
    @q = @event.maybe_participations.create :character_id => @stranger_character.id, :participant_id => @stranger.id

    @event.reload
    assert_equal @event.confirmed_count, 2
    assert_equal @event.maybe_count, 1

    @p.destroy
    @event.reload
    assert_equal @event.confirmed_count, 1
    assert_equal @event.maybe_count, 1

    @q.destroy
    @event.reload
    assert_equal @event.confirmed_count, 1
    assert_equal @event.maybe_count, 0
  end

  test "participant change status" do
    @event = EventFactory.create :character_id => @user_character.id
    @p = @event.confirmed_participations.create :character_id => @friend_character.id, :participant_id => @friend.id

    assert_difference "@user.reload.notifications_count" do
      assert_difference "@event.reload.confirmed_participations.count", -1 do
        assert_difference "@event.reload.maybe_participations.count" do
          @p.change_status Participation::Maybe
        end
      end
    end

    assert_no_difference "@user.reload.notifications_count" do
      assert_no_difference "@event.reload.confirmed_participations.count" do
        assert_no_difference "@event.reload.maybe_participations.count" do
          @p.change_status Participation::Maybe
        end
      end
    end
     
    assert_difference "@user.reload.notifications_count" do
      assert_difference "@event.reload.confirmed_participations.count" do
        assert_difference "@event.reload.maybe_participations.count", -1 do
          @p.change_status Participation::Confirmed
        end
      end
    end
  end

  test "event poster evict particpant" do
    @event = EventFactory.create :character_id => @user_character.id

    @p = @event.confirmed_participations.create :character_id => @friend_character.id, :participant_id => @friend.id
    assert_difference "@friend.reload.notifications_count" do
      assert_difference "@event.reload.confirmed_participations.count", -1 do
        assert_no_difference "@event.reload.maybe_participations.count" do
          @p.evict
        end
      end
    end

    @p = @event.maybe_participations.create :character_id => @friend_character.id, :participant_id => @friend.id
    assert_difference "@friend.reload.notifications_count" do
      assert_difference "@event.reload.maybe_participations.count", -1 do
        assert_no_difference "@event.reload.confirmed_participations.count" do
          @p.evict
        end
      end
    end  
  end

  test "accept request feed, normal event" do
    @profile = @user.profile
    @event = EventFactory.create :character_id => @stranger_character.id
    @game = @event.game
    @request = @event.requests.create :character_id => @user_character.id, :participant_id => @user.id
    @request.accept_request

    @friend.reload and @fan.reload and @idol.reload and @game.reload and @profile.reload
    assert @friend.recv_feed?(@request)
    assert @fan.recv_feed?(@request)
    assert !@idol.recv_feed?(@request)
    assert @profile.recv_feed?(@request)
    assert @game.recv_feed?(@request)
  end

  test "accept invitation feed, normal event" do
    FriendFactory.create @stranger, @user
    @profile = @user.profile
    @event = EventFactory.create :character_id => @stranger_character.id
    @game = @event.game
    @invitation = @event.invitations.create :character_id => @user_character.id, :participant_id => @user.id
    @invitation.accept_invitation Participation::Confirmed

    @friend.reload and @fan.reload and @idol.reload and @game.reload and @profile.reload
    assert @friend.recv_feed?(@invitation)
    assert @fan.recv_feed?(@invitation)
    assert !@idol.recv_feed?(@invitation)
    assert @profile.recv_feed?(@invitation)
    assert @game.recv_feed?(@invitation)
  end

  test "participants list" do
    @event = EventFactory.create :character_id => @user_character.id
  
    @p1 = @event.confirmed_participations.create :character_id => @friend_character.id, :participant_id => @friend.id
    @p2 = @event.maybe_participations.create :character_id => @stranger_character.id, :participant_id => @stranger.id

    @event.reload
    assert_equal @event.confirmed_participants, [@user, @friend]
    assert_equal @event.maybe_participants, [@stranger]

    @p2.change_status Participation::Confirmed

    @event.reload
    assert_equal @event.confirmed_participants, [@user, @friend, @stranger]
    assert_equal @event.maybe_participants, []

    @p1.change_status Participation::Maybe
    @p2.change_status Participation::Maybe

    @event.reload
    assert_equal @event.confirmed_participants, [@user]
    assert_equal @event.maybe_participants, [@friend, @stranger]
  end

end

