require 'test_helper'

class GuildAlbumTest < ActiveSupport::TestCase

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
 
  test "album inherits some attributes from guild" do
    @guild = GuildFactory.create :character_id => @character1.id
    @album = @guild.album

    assert_not_nil @album
    assert_equal @album.privilege, PrivilegedResource::PUBLIC
    assert_equal @album.poster_id, @guild.president_id
  end

  test "photo has the same privilege with album" do
    @guild = GuildFactory.create :character_id => @character1.id
    @album = @guild.album

    @photo = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
    assert_equal @photo.privilege, @album.privilege
    assert_equal @photo.poster_id, @album.poster_id
  end

  test "comment album" do
    @guild = GuildFactory.create :character_id => @character1.id
    @album = @guild.album
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id
    
    assert @guild.is_commentable_by?(@user)
    assert @guild.is_commentable_by?(@friend)
    assert !@guild.is_commentable_by?(@same_game_user)
    assert !@guild.is_commentable_by?(@stranger)
    assert !@guild.is_commentable_by?(@fan)
    assert !@guild.is_commentable_by?(@idol)
  
    [@user, @friend].each do |u|
      @comment = @guild.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@user)
      if @user != u
        assert !@comment.is_deleteable_by?(u)
      end
      ([@friend, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !@comment.is_deleteable_by?(f)
      end
    end
  end

  test "comment notice" do
    @guild = GuildFactory.create :character_id => @character1.id
    @album = @guild.album
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id
    @guild.member_memberships.create :user_id => @same_game_user.id, :character_id => @character3.id

    assert_no_difference "Notice.count" do
      @comment = @guild.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload
    assert !@user.recv_notice?(@comment)

    assert_difference "Notice.count" do
      @comment = @guild.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload and @friend.reload
    assert @user.recv_notice?(@comment)
    assert !@friend.recv_notice?(@friend)
 
    assert_difference "Notice.count", 2 do
      @comment = @guild.comments.create :poster_id => @same_game_user.id, :recipient_id => @friend.id, :content => 'a'
    end
    @user.reload and @friend.reload and @same_game_user.reload
    assert @user.recv_notice?(@comment)
    assert @friend.recv_notice?(@comment)
    assert !@same_game_user.recv_notice?(@comment)

    assert_difference "Notice.count" do
      @comment = @guild.comments.create :poster_id => @friend.id, :recipient_id => @friend.id, :content => 'a'
    end
    @user.reload and @friend.reload
    assert @user.recv_notice?(@comment)
    assert !@friend.recv_notice?(@comment)
  end

  test "record upload" do
    @guild = GuildFactory.create :character_id => @character1.id
    @guild.member_memberships.create :user_id => @friend.id, :character_id => @character2.id
    @guild.member_memberships.create :user_id => @same_game_user.id, :character_id => @character3.id
    @album = @guild.album
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'

    @album.record_upload @user, [@photo1, @photo2]

    assert !@user.recv_feed?(@album)
    assert @friend.recv_feed?(@album)
    assert @same_game_user.recv_feed?(@album)
    assert !@stranger.recv_feed?(@album)    
    assert @fan.recv_feed?(@album)
    assert !@idol.recv_feed?(@album)

    @album.unverify

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each {|u| u.reload}
    assert !@user.recv_feed?(@album)
    assert !@friend.recv_feed?(@album)
    assert !@same_game_user.recv_feed?(@album)
    assert !@stranger.recv_feed?(@album)    
    assert !@fan.recv_feed?(@album)
    assert !@idol.recv_feed?(@album)

    @album.verify

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each {|u| u.reload}
    assert !@user.recv_feed?(@album)
    assert !@friend.recv_feed?(@album)
    assert !@same_game_user.recv_feed?(@album)
    assert !@stranger.recv_feed?(@album)    
    assert !@fan.recv_feed?(@album)
    assert !@idol.recv_feed?(@album)
  end

  test "sensitive" do
    @guild = GuildFactory.create :character_id => @character1.id
    @album = @guild.album
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'GuildPhoto'
    assert @album.accepted?

    @album.update_attributes :description => @sensitive
    assert @album.unverified?

    @photo1.unverify
    assert @album.photos_count, 1

    @album.unverify
    @album.reload and @photo1.reload and @photo2.reload
    assert_equal @album.photos_count, 0
    assert @photo1.rejected?
    assert @photo2.rejected?

    @album.verify
    @album.reload and @photo1.reload and @photo2.reload
    assert_equal @album.photos_count, 2
    assert @photo1.accepted?
    assert @photo2.accepted?
  end

end
