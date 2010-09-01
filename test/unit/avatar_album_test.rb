require 'test_helper'

class AvatarAlbumTest < ActiveSupport::TestCase
  
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

    @album = @user.avatar_album
    @sensitive = "政府"
  end

  test "album should be created automatically" do
    assert_not_nil @album
    assert_equal @album.poster_id, @user.id
    assert_equal @album.privilege, PrivilegedResource::FRIEND
    assert @album.accepted?
  end

  test "photo has the same privilege with album" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'Avatar'

    assert_equal @photo.privilege, PrivilegedResource::FRIEND
  end
  
  test "comment avatar album" do
    [@user, @friend, @fan, @idol].each do |u|
      assert @album.is_commentable_by? u
    end
    [@same_game_user, @stranger].each do |u|
      assert !@album.is_commentable_by?(u)
    end

    assert_no_difference "Comment.count" do
      @album.comments.create :poster_id => @user.id, :content => 'a', :recipient_id => nil
    end

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each do |u|
      if @album.is_commentable_by?(u)
        @comment = @album.comments.create :poster_id => u.id, :content => 'a', :recipient_id => @user.id
        assert @comment.is_deleteable_by?(@user)
        assert @comment.is_deleteable_by?(u)
        ([@friend, @same_game_user, @stranger, @fan, @idol] - [u]).each do |u|
          assert !@comment.is_deleteable_by?(u)
        end
      end
    end
  end

  test "comment notice" do
    @comment = @album.comments.create :poster_id => @user.id, :content => 'a', :recipient_id => @user.id
    @user.reload
    assert !@user.recv_notice?(@comment)
    
    @comment = @album.comments.create :poster_id => @friend.id, :content => 'a', :recipient_id => @user.id
    @user.reload
    assert @user.recv_notice?(@comment)
    
    @comment = @album.comments.create :poster_id => @fan.id, :content => 'a', :recipient_id => @friend.id
    @user.reload and @friend.reload
    assert @friend.recv_notice?(@comment)
    assert @user.recv_notice?(@comment)

    @comment = @album.comments.create :poster_id => @fan.id, :content => 'a', :recipient_id => @fan.id
    @user.reload and @fan.reload
    assert !@fan.recv_notice?(@comment)
    assert @user.recv_notice?(@comment)
  end

  test "sensitive album" do
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'Avatar'
    @friend.reload and @fan.reload
    assert @friend.recv_feed?(@photo1)
    assert @fan.recv_feed?(@photo1)
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'Avatar'
    @friend.reload and @fan.reload
    assert @friend.recv_feed?(@photo2)
    assert @fan.recv_feed?(@photo2)

    @album.update_attributes :description => @sensitive
    @album.reload
    assert @album.unverified?
 
    @photo1.unverify
    @friend.reload and @fan.reload and @album.reload
    assert !@friend.recv_feed?(@photo1)
    assert !@fan.recv_feed?(@photo1)
    assert @album.photos_count, 1
 
    @album.unverify
    @friend.reload and @fan.reload and @album.reload and @photo1.reload and @photo2.reload
    assert !@friend.recv_feed?(@photo1)
    assert !@friend.recv_feed?(@photo2)
    assert !@fan.recv_feed?(@photo1)
    assert !@fan.recv_feed?(@photo2)
    assert @album.photos_count, 0
    assert @photo1.rejected?
    assert @photo2.rejected?

    @album.verify
    @friend.reload and @fan.reload and @album.reload and @photo1.reload and @photo2.reload
    assert !@friend.recv_feed?(@photo1)
    assert !@friend.recv_feed?(@photo2)
    assert !@fan.recv_feed?(@photo1)
    assert !@fan.recv_feed?(@photo2)
    assert @album.photos_count, 2
    assert @photo1.accepted?
    assert @photo2.accepted?
  end

end
