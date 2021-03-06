require 'test_helper'

class PersonalAlbumTest < ActiveSupport::TestCase
  
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
    @character3 = GameCharacterFactory.create :user_id => @user.id
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id
    [@user, @friend, @same_game_user, @fan, @idol].each {|f| f.reload}

    @sensitive = "政府" 
  end

  test "album counter" do
    assert_difference "@user.reload.albums_count1" do
      @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC    
    end

    assert_difference "@user.reload.albums_count2" do
      @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    end

    assert_difference "@user.reload.albums_count3" do
      @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    end

    assert_difference "@user.reload.albums_count4" do
      @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
    end

    assert_difference "@user.reload.albums_count1", -1 do
      @album1.unverify
    end

    assert_no_difference "@user.reload.albums_count1" do
      @album1.destroy
    end

    @album2.update_attributes :privilege => PrivilegedResource::PUBLIC
    @user.reload
    assert_equal @user.albums_count1, 1
    assert_equal @user.albums_count2, 0

    assert_difference "@user.reload.albums_count3", -1 do
      @album3.unverify
    end

    assert_difference "@user.reload.albums_count4", -1 do
      @album4.destroy
    end
  end

  test "photo has the same privilege with album" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'

    assert_equal @photo.privilege, PrivilegedResource::PUBLIC 

    @album.update_attributes :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @photo.reload
    assert_equal @photo.privilege, PrivilegedResource::FRIEND_OR_SAME_GAME
  end

  test "comment album" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    
    assert @album1.is_commentable_by?(@user)
    assert @album1.is_commentable_by?(@friend)
    assert @album1.is_commentable_by?(@same_game_user)
    assert @album1.is_commentable_by?(@stranger)
    assert @album1.is_commentable_by?(@fan)
    assert @album1.is_commentable_by?(@idol)

    assert_no_difference "Comment.count" do
      @album1.comments.create :poster_id => @user.id, :recipient_id => nil, :content => 'a'
    end

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each do |u|
      comment = @album1.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert comment.is_deleteable_by?(@user)
      assert comment.is_deleteable_by?(u)
      ([@friend, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !comment.is_deleteable_by?(f)
      end
    end
    
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME

    [@user, @friend, @same_game_user, @fan, @idol].each do |u|
      comment = @album1.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert comment.is_deleteable_by?(@user)
      assert comment.is_deleteable_by?(u)
      ([@friend, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !comment.is_deleteable_by?(f)
      end
    end    

    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    
    [@user, @friend, @fan, @idol].each do |u|
      comment = @album1.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert comment.is_deleteable_by?(@user)
      assert comment.is_deleteable_by?(u)
      ([@friend, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !comment.is_deleteable_by?(f)
      end
    end

    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
  
    [@user].each do |u|
      comment = @album1.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert comment.is_deleteable_by?(@user)
      assert comment.is_deleteable_by?(u)
      ([@friend, @same_game_user, @stranger, @fan, @idol] - [u]).each do |f|
        assert !comment.is_deleteable_by?(f)
      end
    end  
  end

  test "comment notice" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id

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

  test "upload photos feed" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id

    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'

    @album.record_upload @user, [@photo1, @photo2]

    @friend.reload and @fan.reload and @idol.reload
    assert @friend.recv_feed?(@album)
    assert @fan.recv_feed?(@album)
    assert !@idol.recv_feed?(@album)    
  end

  test "sensitive album" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    @album.record_upload @user, [@photo1, @photo2]

    @album.update_attributes :description => @sensitive
    @album.reload
    assert @album.unverified?
 
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
