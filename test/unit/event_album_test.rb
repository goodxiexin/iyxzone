require 'test_helper'

class EventAlbumTest < ActiveSupport::TestCase
  
  def setup
    @user = UserFactory.create_idol
    @friend = UserFactory.create
    @stranger = UserFactory.create
    @same_game_user = UserFactory.create
    @fan = UserFactory.create
    @idol = UserFactory.create_idol
 
    FriendFactory.create @user, @friend
    @character1 = GameCharacterFactory.create :user_id => @user.id
    @character2 = GameCharacterFactory.create @character1.game_info.merge({:user_id => @same_game_user.id})
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id
    [@user, @friend, @fan, @idol].each {|f| f.reload}
 
    @event = EventFactory.create :character_id => @character1.id
    @album = @event.album
    @sensitive = "政府"
  end

  test "album should be create automatically" do
    assert_not_nil @album
    assert_equal @album.poster_id, @event.poster_id
    assert_equal @album.privilege, PrivilegedResource::PUBLIC
    assert @album.accepted? 
  end

  test "photo has the same privilege with album" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'

    assert_equal @photo.privilege, PrivilegedResource::PUBLIC
  end

  test "comment event album" do
    assert @album.is_commentable_by?(@user) 
    assert @album.is_commentable_by?(@friend)
    assert @album.is_commentable_by?(@same_game_user) 
    assert @album.is_commentable_by?(@stranger)
    assert @album.is_commentable_by?(@fan) 
    assert @album.is_commentable_by?(@idol)

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each do |u|
      @comment = @album.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@user)
      assert @comment.is_deleteable_by?(u)
      ([@friend, @same_game_user, @stranger, @fan, @idol] - [u]).each do |u|
        assert !@comment.is_deleteable_by?(u)
      end
    end
  end

  test "comment notice" do
    @comment = @album.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @user.reload
    assert @user.recv_notice?(@comment)

    @comment = @album.comments.create :poster_id => @same_game_user.id, :recipient_id => @friend.id, :content => 'a'
    @user.reload and @friend.reload
    assert @user.recv_notice?(@comment)
    assert @friend.recv_notice?(@comment)

    @comment = @album.comments.create :poster_id => @user.id, :recipient_id => @friend.id, :content => 'a'
    @user.reload and @friend.reload
    assert !@user.recv_notice?(@comment)
    assert @friend.recv_notice?(@comment)
  end

  test "record upload" do
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
    @event.confirmed_participations.create :participant_id => @same_game_user.id, :character_id => @character2.id
    @album.record_upload @user, [@photo1, @photo2]

    @user.reload and @same_game_user.reload and @friend.reload and @fan.reload and @idol.reload
    [@friend, @same_game_user, @fan].each do |u|
      assert u.recv_feed?(@album)
    end
    [@idol, @user].each do |u|
      assert !u.recv_feed?(@album)
    end
  end

  test "sensitive album" do
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'

    @album.update_attributes :description => @sensitive
    @album.reload
    assert @album.unverified?
    assert !@friend.recv_feed?(@album)
    assert !@fan.recv_feed?(@album)

    @photo1.unverify
    @friend.reload and @fan.reload and @album.reload
    assert !@friend.recv_feed?(@album)
    assert !@fan.recv_feed?(@album)
    assert @album.photos_count, 1
 
    @album.unverify
    @friend.reload and @fan.reload and @album.reload and @photo1.reload and @photo2.reload
    assert !@friend.recv_feed?(@album)
    assert !@fan.recv_feed?(@album)
    assert @album.photos_count, 0
    assert @photo1.rejected?
    assert @photo2.rejected?

    @album.verify
    @friend.reload and @fan.reload and @album.reload and @photo1.reload and @photo2.reload
    assert !@friend.recv_feed?(@album)
    assert !@fan.recv_feed?(@album)
    assert @album.photos_count, 2
    assert @photo1.accepted?
    assert @photo2.accepted?
  end

end
