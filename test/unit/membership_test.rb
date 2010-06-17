require 'test_helper'

class MembershipTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create_idol
    @friend = UserFactory.create
    @stranger = UserFactory.create
    @same_game_user = UserFactory.create
    @fan = UserFactory.create
    @idol = UserFactory.create_idol
 
    FriendFactory.create @user, @friend
    @character1 = GameCharacterFactory.create :user_id => @user.id
    @character2 = GameCharacterFactory.create @character1.game_info.merge({:user_id => @friend.id})
    @character3 = GameCharacterFactory.create @character1.game_info.merge({:user_id => @same_game_user.id})
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id

    @guild = GuildFactory.create :character_id => @character1.id 
    @sensitive = "政府"

    [@user, @friend, @same_game_user, @fan, @idol].each {|f| f.reload}
  end

  test "send invitation" do
    assert_no_difference "@guild.reload.invitations_count" do
      assert_no_difference "@same_game_user.reload.guild_invitations_count" do
        @guild.invite [@character3]
      end
    end

    assert_no_difference "@guild.reload.invitations_count" do
      assert_no_difference "@friend.reload.guild_invitations_count" do
        assert_no_difference "@same_game_user.reload.guild_invitations_count" do
          @guild.invite [@character2, @character3]
        end
      end
    end

    # 已经请求加入的
    @request = @guild.requests.create :user_id => @friend.id, :character_id => @character2.id
    assert_no_difference "@guild.reload.invitations_count" do
      assert_no_difference "@friend.reload.guild_invitations_count" do
        @guild.invite [@character2]
      end
    end
    @request.destroy

    FriendFactory.create @same_game_user, @user

    assert_difference "@guild.reload.invitations_count", 2 do
      assert_difference "@friend.reload.guild_invitations_count" do
        assert_difference "@same_game_user.reload.guild_invitations_count" do
          @guild.invite [@character2, @character3]
        end
      end
    end
  end

  test "accept/decline invitation" do
    @guild.invite [@character2]
    @invitation = @guild.invitations.last

    assert_difference "@guild.reload.invitations_count", -1 do
      assert_difference "@friend.reload.guild_invitations_count", -1 do
        assert_no_difference "@friend.reload.participated_guilds_count" do
          assert_difference "@user.reload.notifications_count" do
            @invitation.decline_invitation
          end
        end
      end
    end

    @guild.invite [@character2]
    @invitation = @guild.invitations.last

    assert_difference "@guild.reload.invitations_count", -1 do
      assert_difference "@friend.reload.guild_invitations_count", -1 do
        assert_difference "@friend.reload.participated_guilds_count" do
          assert_difference "@user.reload.notifications_count" do
            @invitation.accept_invitation
          end
        end
      end
    end
  end

  test "send request" do
    assert_difference "@guild.reload.requests_count" do
      assert_difference "@user.reload.guild_requests_count" do
        @request = @guild.requests.create :user_id => @same_game_user.id, :character_id => @character3.id
      end
    end

    # 已经发送的
    assert_no_difference "@guild.reload.requests_count" do
      assert_no_difference "@user.reload.guild_requests_count" do
        @request = @guild.requests.create :user_id => @same_game_user.id, :character_id => @character3.id
      end
    end
    
    # 没有相同游戏角色的
    @character = GameCharacterFactory.create :user_id => @fan.id
    assert_no_difference "@guild.reload.requests_count" do
      assert_no_difference "@user.reload.guild_requests_count" do
        @request = @guild.requests.create :user_id => @fan.id, :character_id => @character.id
      end
    end

    # 游戏角色不是自己的
    assert_no_difference "@guild.reload.requests_count" do
      assert_no_difference "@fan.reload.guild_requests_count" do
        @request = @guild.requests.create :user_id => @fan.id, :character_id => @character3.id
      end
    end

    # 已经被邀请的
    @guild.invite [@character2]
    assert_no_difference "@guild.reload.requests_count" do
      assert_no_difference "@fan.reload.guild_requests_count" do
        @request = @guild.requests.create :user_id => @friend.id, :character_id => @character2.id
      end
    end    
  end

  test "accept/decline request" do
    @request = @guild.requests.create :user_id => @friend.id, :character_id => @character2.id

    assert_difference "@guild.reload.requests_count", -1 do
      assert_difference "@user.reload.guild_requests_count", -1 do
        assert_no_difference "@friend.reload.participated_guilds_count" do
          assert_difference "@friend.reload.notifications_count" do
            @request.decline_request
          end
        end
      end
    end

    @request = @guild.requests.create :user_id => @friend.id, :character_id => @character2.id

    assert_difference "@guild.reload.requests_count", -1 do
      assert_difference "@user.reload.guild_requests_count", -1 do
        assert_difference "@friend.reload.participated_guilds_count" do
          assert_difference "@friend.reload.notifications_count" do
            @request.accept_request
          end
        end
      end
    end  
  end

  test "change role" do
    @membership = @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id

    assert_difference "@guild.reload.members_count", -1 do
      assert_difference "@guild.reload.veterans_count" do
        assert_difference "@friend.reload.notifications_count" do
          @membership.change_role Membership::Veteran
        end
      end
    end

    assert_difference "@guild.reload.members_count" do
      assert_difference "@guild.reload.veterans_count", -1 do
        assert_difference "@friend.reload.notifications_count" do
          @membership.change_role Membership::Member
        end
      end
    end

    assert_no_difference "@guild.reload.members_count" do
      assert_no_difference "@guild.reload.veterans_count" do
        assert_no_difference "@friend.reload.notifications_count" do
          @membership.change_role Membership::Member
        end
      end
    end

    assert_no_difference "@guild.reload.members_count" do
      assert_no_difference "@guild.reload.veterans_count" do
        assert_no_difference "@friend.reload.notifications_count" do
          @membership.change_role 'invalid'
        end
      end
    end
  end

  test "evcit member" do
    @membership1 = @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id
    @membership2 = @guild.veteran_memberships.create :user_id => @same_game_user.id, :character_id => @character3.id

    assert_difference "@guild.reload.members_count", -1 do
      assert_difference "@friend.reload.notifications_count" do
        @membership1.evict
      end
    end

    assert_difference "@guild.reload.veterans_count", -1 do
      assert_difference "@same_game_user.reload.notifications_count" do
        @membership2.evict
      end
    end

    @guild.invite [@character2]
    @invitation = @guild.invitations.last

    assert_no_difference "@guild.reload.members_count" do
      assert_no_difference "@guild.reload.veterans_count" do
        assert_no_difference "@friend.reload.notifications_count" do
          @invitation.evict
        end
      end
    end

    @request = @guild.requests.create :user_id => @same_game_user.id, :character_id => @character3.id
    assert_no_difference "@guild.reload.members_count" do
      assert_no_difference "@guild.reload.veterans_count" do
        assert_no_difference "@friend.reload.notifications_count" do
          @request.evict
        end
      end
    end    
  end

end
