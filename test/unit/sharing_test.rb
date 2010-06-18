require 'test_helper'

class SharingTest < ActiveSupport::TestCase

  def setup
    # create a user with game character
    @user = UserFactory.create_idol
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
  
    # create friends
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    
    # create stranger
    @stranger = UserFactory.create

    # create fan and idol
    @fan = UserFactory.create
    @idol = UserFactory.create_idol
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id

    # create same-game-user
    @same_game_user = UserFactory.create
    @character2 = GameCharacterFactory.create @character.game_info.merge({:user_id => @same_game_user.id})
    
    [@user, @friend, @fan, @idol].each {|f| f.reload}
  end

  test "counter, first sharer" do
    r = 'reason'
    t = 'title'
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id

    assert_difference "Sharing.count" do
      assert @blog.share_by(@user, r, t)
    end
    @blog.reload
    assert @blog.sharings_count, 1
    assert @blog.shared_by?(@user)

    assert_difference "Sharing.count" do
      assert @blog.share_by(@friend, r, t)
    end
    @blog.reload
    assert @blog.sharings_count, 2
    assert @blog.shared_by?(@friend)

    # 不能重复分享
    assert_no_difference "Sharing.count" do
      assert !@blog.share_by(@friend, r, t)
    end

    assert_difference "Sharing.count" do
      assert @blog.share_by(@same_game_user, r, t)
    end
    @blog.reload
    assert @blog.sharings_count, 3
    assert @blog.shared_by?(@same_game_user)

    assert_difference "Sharing.count" do
      assert @blog.share_by(@stranger, r, t)
    end
    @blog.reload
    assert @blog.sharings_count, 4
    assert @blog.shared_by?(@same_game_user)

    assert_equal @blog.first_sharer, @user
  end

  test "share sensitive blog" do
    r = 'reason'
    t = 'title'
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @blog.unverify

    assert_no_difference "Sharing.count" do
      @blog.share_by(@user, r, t)
    end
    
    @blog.verify

    assert_difference "Sharing.count" do
      @blog.share_by(@user, r, t)
    end
  end

  test "hot/recent/friends, category" do
    r = 'reason'
    t = 'title'
    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @blog2 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @video1 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id
    @video2 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id

    assert @blog1.share_by @user, r, t
    @blog1.share.dug_by @user
    sleep 1
    @blog2.share_by @friend, r, t
    sleep 1
    @video1.share_by @user, r, t
    @video1.share.dug_by @user
    @video1.share.dug_by @friend
    sleep 1
    @video2.share_by @friend, r, t
    
    # hot
    @shares = Share.hot(:all).map(&:shareable) 
    assert_equal @shares, [@video1, @blog1, @video2, @blog2]

    @shares = Share.hot(:blog).map(&:shareable)
    assert_equal @shares, [@blog1, @blog2]
  
    @shares = Share.hot(:video).map(&:shareable)
    assert_equal @shares, [@video1, @video2]

    # recent
    @shares = Share.recent(:all).map(&:shareable) 
    assert_equal @shares, [@video2, @video1, @blog2, @blog1]

    @shares = Share.recent(:blog).map(&:shareable)
    assert_equal @shares, [@blog2, @blog1]
  
    @shares = Share.recent(:video).map(&:shareable)
    assert_equal @shares, [@video2, @video1]
    
    # index 
    @shares = @user.sharings.in(:all).map(&:shareable)
    assert_equal @shares, [@video1, @blog1]

    @shares = @user.sharings.in(:blog).map(&:shareable)
    assert_equal @shares, [@blog1]

    @shares = @user.sharings.in(:video).map(&:shareable)
    assert_equal @shares, [@video1]

    # friends
    @shares = Sharing.by(@user.friend_ids).in(:all).map(&:shareable)
    assert_equal @shares, [@video2, @blog2]

    @shares = Sharing.by(@user.friend_ids).in(:blog).map(&:shareable)
    assert_equal @shares, [@blog2]

    @shares = Sharing.by(@user.friend_ids).in(:video).map(&:shareable)
    assert_equal @shares, [@video2]
  end

  test "comment sharing" do 
    r = 'reason'
    t = 'title'
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id

    assert_difference "Sharing.count" do
      @blog.share_by @user, r, t
    end
    @sharing = Sharing.last

    assert @sharing.is_commentable_by? @user
    assert @sharing.is_commentable_by? @friend
    assert @sharing.is_commentable_by? @same_game_user
    assert @sharing.is_commentable_by? @stranger
    assert @sharing.is_commentable_by? @fan
    assert @sharing.is_commentable_by? @idol

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each do |u|
      comment = @sharing.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert comment.is_deleteable_by?(@user)
      assert comment.is_deleteable_by?(u)
      ([@friend, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !comment.is_deleteable_by?(f)
      end  
    end

  end

  test "comment notice" do
    r = 'reason'
    t = 'title'
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id

    assert_difference "Sharing.count" do
      @blog.share_by @user, r, t
    end
    @sharing = Sharing.last

    assert_no_difference "Notice.count" do
      @comment = @sharing.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    end

    assert_difference "Notice.count" do
      @comment = @sharing.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload
    assert @user.recv_notice?(@comment)

    assert_difference "Notice.count", 2 do
      @comment = @sharing.comments.create :poster_id => @same_game_user.id, :recipient_id => @friend.id, :content => 'a'
    end
    @user.reload and @friend.reload
    assert @user.recv_notice?(@comment)
    assert @friend.recv_notice?(@comment)

    assert_difference "Notice.count" do
      @comment = @sharing.comments.create :poster_id => @user.id, :recipient_id => @same_game_user.id, :content => 'a'
    end
    @same_game_user.reload
    assert @same_game_user.recv_notice?(@comment)
  end

  test "sharing feed" do
    # create guilds
    @guild1 = GuildFactory.create :character_id => @character.id, :president_id => @user.id
    @guild2 = GuildFactory.create :character_id => @character2.id, :president_id => @same_game_user.id
    @guild2.memberships.create :user_id => @user.id, :character_id => @character.id, :status => Membership::Member    

    r = 'reason'
    t = 'title'
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id

    assert_difference "Sharing.count" do
      @blog.share_by @user, r, t
    end
    @sharing = Sharing.last

    @user.reload and @friend.reload and @guild1.reload and @guild2.reload and @fan.reload and @idol.reload
    assert @user.profile.recv_feed?(@sharing)     
    assert @friend.recv_feed?(@sharing)
    assert @guild1.recv_feed?(@sharing)
    assert @guild2.recv_feed?(@sharing)
    assert @fan.recv_feed?(@sharing)
    assert !@idol.recv_feed?(@sharing)
  end

  test "dig share" do
    # nothing special for sharing, so no test is needed except ones in dig_test.rb
  end

end
