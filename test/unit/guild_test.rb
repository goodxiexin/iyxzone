require 'test_helper'

class GuildTest < ActiveSupport::TestCase

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
    [@user, @friend, @fan, @idol].each {|f| f.reload}
 
    @sensitive = "政府"
  end
  
  test "create guild" do
    assert_difference "Guild.count" do
      @guild = Guild.create :character_id => @character1.id, :name => 'guild', :description => 'd'
    end

    @user.reload
    assert_equal @user.guilds_count, 1
    assert_equal @guild.president_id, @user.id
    assert_equal @guild.game_area_id, @character1.area_id
    assert_equal @guild.game_server_id, @character1.server_id
    assert_equal @guild.game_id, @character1.game_id
  end

  test "fail to create guild" do
    assert_no_difference "Guild.count" do
      @guild = Guild.create :character_id => @character1.id, :name => nil, :description => 'd'
    end
    assert_not_nil @guild.errors.on(:name)

    assert_no_difference "Guild.count" do
      @guild = Guild.create :character_id => @character1.id, :name => 'name', :description => nil
    end
    assert_not_nil @guild.errors.on(:description)

    assert_no_difference "Guild.count" do
      @guild = Guild.create :character_id => nil, :name => 'name', :description => 'd'
    end
    assert_not_nil @guild.errors.on(:character_id)
  end
  
  test "some associations are created successfully" do
    assert_difference "GuildAlbum.count" do
      assert_difference "Membership.count" do
        assert_difference "Forum.count" do
          @guild = GuildFactory.create :character_id => @character1.id
        end
      end
    end

    assert_not_nil @guild.album
    assert_not_nil @guild.forum
    assert_not_nil @guild.memberships.find_by_user_id_and_character_id(@user.id, @character1.id)
  end

  test "guild counter" do
    assert_difference "@user.reload.guilds_count" do
      @guild = GuildFactory.create :character_id => @character1.id
    end 
 
    assert_difference "@friend.reload.participated_guilds_count" do 
      @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id
    end

    assert_difference "@same_game_user.reload.participated_guilds_count" do
      @guild.member_memberships.create :user_id => @same_game_user.id, :character_id => @character3.id
    end

    assert_difference "@user.reload.guilds_count", -1 do
      assert_difference "@friend.reload.participated_guilds_count", -1 do
        assert_difference "@same_game_user.reload.participated_guilds_count", -1 do
          @guild.unverify
        end
      end
    end

    assert_difference "@user.reload.guilds_count" do
      assert_difference "@friend.reload.participated_guilds_count" do
        assert_difference "@same_game_user.reload.participated_guilds_count" do
          @guild.verify
        end
      end
    end

    assert_difference "@user.reload.guilds_count", -1 do
      assert_difference "@friend.reload.participated_guilds_count", -1 do
        assert_difference "@same_game_user.reload.participated_guilds_count", -1 do
          @guild.destroy
        end
      end
    end
  
    @guild = GuildFactory.create :character_id => @character1.id
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id
    @guild.member_memberships.create :user_id => @same_game_user.id, :character_id => @character3.id

    @guild.unverify

    assert_no_difference "@user.reload.guilds_count" do
      assert_no_difference "@friend.reload.participated_guilds_count" do
        assert_no_difference "@same_game_user.reload.participated_guilds_count" do
          @guild.destroy
        end
      end
    end
  end

  test "guild feed" do
    @guild = GuildFactory.create :character_id => @character1.id
  
    @user.reload and @friend.reload and @fan.reload and @idol.reload
    assert !@user.recv_feed?(@guild)
    assert @friend.recv_feed?(@guild)
    assert @fan.recv_feed?(@guild)
    assert !@idol.recv_feed?(@guild)

    @guild.unverify
    @user.reload and @friend.reload and @fan.reload and @idol.reload
    assert !@user.recv_feed?(@guild)
    assert !@friend.recv_feed?(@guild)
    assert !@fan.recv_feed?(@guild)
    assert !@idol.recv_feed?(@guild)

    @guild.verify
    @user.reload and @friend.reload and @fan.reload and @idol.reload
    assert !@user.recv_feed?(@guild)
    assert !@friend.recv_feed?(@guild)
    assert !@fan.recv_feed?(@guild)
    assert !@idol.recv_feed?(@guild)
  end

  test "edit/update guild" do
    @guild = GuildFactory.create :character_id => @character1.id

    # 只有description能该
    @guild.update_attributes(:description => 'new')
    @guild.reload
    assert_equal @guild.description, 'new'

    @guild.update_attributes(:character_id => @character2.id)
    @guild.reload
    assert_equal @guild.character_id, @character1.id
  
    @name = @guild.name
    @guild.update_attributes(:name => 'new')
    @guild.reload
    assert_equal @guild.name, @name
  end

  test "destroy guild" do
  end

  test "comment guild" do
    @guild = GuildFactory.create :character_id => @character1.id
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id

    assert @guild.is_commentable_by?(@user)
    assert @guild.is_commentable_by?(@friend)
    assert !@guild.is_commentable_by?(@same_game_user)
    assert !@guild.is_commentable_by?(@stranger)
    assert !@guild.is_commentable_by?(@fan)
    assert !@guild.is_commentable_by?(@idol)

    [@user, @friend].each do |u|
      comment = @guild.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert comment.is_deleteable_by? @user
      [@friend, @same_game_user, @stranger, @fan, @idol].each do |f|
        assert !comment.is_deleteable_by?(f)
      end
    end
  end

  test "comment notice" do
    @guild = GuildFactory.create :character_id => @character1.id
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id
    @guild.member_memberships.create :user_id => @same_game_user.id, :character_id => @character3.id

    assert_no_difference "Notice.count" do
      @comment = @guild.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    end

    assert_difference "Notice.count" do
      @comment = @guild.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload
    assert @user.recv_notice?(@comment)

    assert_difference "Notice.count" do
      @comment = @guild.comments.create :poster_id => @friend.id, :recipient_id => @friend.id, :content => 'a'
    end
    @user.reload and @friend.reload
    assert @user.recv_notice?(@comment)
    assert !@friend.recv_notice?(@comment)

    assert_difference "Notice.count", 2 do
      @comment = @guild.comments.create :poster_id => @same_game_user.id, :recipient_id => @friend.id, :content => 'a'
    end
    @user.reload and @friend.reload
    assert @user.recv_notice?(@comment)
    assert @friend.recv_notice?(@comment)
  end
 
  test "member/veteran list" do
    @guild = GuildFactory.create :character_id => @character1.id
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id
    @guild.veteran_memberships.create :user_id => @same_game_user.id, :character_id => @character3.id

    @guild.reload
    assert_equal @guild.president, @user
    assert_equal @guild.veterans, [@same_game_user]
    assert_equal @guild.members, [@friend]
    assert_equal @guild.president_and_veterans, [@user, @same_game_user]
    assert_equal @guild.members_and_veterans, [@friend, @same_game_user]
  end

  test "user's guilds list and privielged guilds list" do
    @guild1 = GuildFactory.create :character_id => @character1.id
    @guild1.member_memberships.create :user_id => @friend.id, :character_id => @character2.id
    @guild1.veteran_memberships.create :user_id => @same_game_user.id, :character_id => @character3.id
    sleep 1
    @guild2 = GuildFactory.create :character_id => @character1.id
    @guild2.veteran_memberships.create :user_id => @friend.id, :character_id => @character2.id
    @guild2.member_memberships.create :user_id => @same_game_user.id, :character_id => @character3.id
    
    @user.reload
    assert_equal @user.guilds, [@guild2, @guild1]
    assert_equal @user.participated_guilds, []
    assert_equal @user.privileged_guilds, [@guild2, @guild1]

    @friend.reload
    assert_equal @friend.guilds, []
    assert_equal @friend.participated_guilds, [@guild2, @guild1]
    assert_equal @friend.privileged_guilds, [@guild2]

    @same_game_user.reload
    assert_equal @same_game_user.guilds, []
    assert_equal @same_game_user.participated_guilds, [@guild2, @guild1]
    assert_equal @same_game_user.privileged_guilds, [@guild1] 
  end

  test "sensitive guild" do
    @guild = GuildFactory.create :character_id => @character1.id
    assert @guild.accepted?

    @guild = GuildFactory.create :character_id => @character1.id, :name => @sensitive
    assert @guild.unverified?
    
    @guild.verify
    @guild.update_attributes :description => @sensitive
    assert @guild.unverified?
  end
   
end
