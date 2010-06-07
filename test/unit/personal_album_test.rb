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

  test "photo has the same privilege and game_id with album" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id, :game_id => @character1.game_id, :privilege => PrivilegedResource::PUBLIC
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'

    assert_equal @photo.privilege, PrivilegedResource::PUBLIC 
    assert_equal @photo.game_id, @character1.game_id

    @album.update_attributes :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @photo.reload
    assert_equal @photo.privilege, PrivilegedResource::FRIEND_OR_SAME_GAME

    @album.update_attributes :game_id => @character3.game_id
    @photo.reload
    assert_equal @photo.game_id, @character3.game_id
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

    @comment = @album1.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)
  
    @comment = @album1.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album1.comments.create :poster_id => @same_game_user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert @comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album1.comments.create :poster_id => @stranger.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert @comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album1.comments.create :poster_id => @fan.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert @comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album1.comments.create :poster_id => @idol.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert @comment.is_deleteable_by?(@idol)

    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    
    assert @album2.is_commentable_by?(@user)
    assert @album2.is_commentable_by?(@friend)
    assert @album2.is_commentable_by?(@same_game_user)
    assert !@album2.is_commentable_by?(@stranger)
    assert @album2.is_commentable_by?(@fan)
    assert @album2.is_commentable_by?(@idol)

    @comment = @album2.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album2.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album2.comments.create :poster_id => @same_game_user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert @comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album2.comments.create :poster_id => @fan.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert @comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album2.comments.create :poster_id => @idol.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert @comment.is_deleteable_by?(@idol)

    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    
    assert @album3.is_commentable_by?(@user)
    assert @album3.is_commentable_by?(@friend)
    assert !@album3.is_commentable_by?(@same_game_user)
    assert !@album3.is_commentable_by?(@stranger)
    assert @album3.is_commentable_by?(@fan)
    assert @album3.is_commentable_by?(@idol)

    @comment = @album3.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album3.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album3.comments.create :poster_id => @fan.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert @comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @album3.comments.create :poster_id => @idol.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert @comment.is_deleteable_by?(@idol)

    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
    
    assert @album4.is_commentable_by?(@user)
    assert !@album4.is_commentable_by?(@friend)
    assert !@album4.is_commentable_by?(@same_game_user)
    assert !@album4.is_commentable_by?(@stranger)
    assert !@album4.is_commentable_by?(@fan)
    assert !@album4.is_commentable_by?(@idol)

    @comment = @album4.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)
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

  test "share album" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    assert @album.is_shareable_by?(@user)
    assert @album.is_shareable_by?(@friend)
    assert @album.is_shareable_by?(@same_game_user)
    assert @album.is_shareable_by?(@stranger)
    assert @album.is_shareable_by?(@fan)
    assert @album.is_shareable_by?(@idol)

    @album = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    assert @album.is_shareable_by?(@user)
    assert @album.is_shareable_by?(@friend)
    assert @album.is_shareable_by?(@same_game_user)
    assert !@album.is_shareable_by?(@stranger)
    assert @album.is_shareable_by?(@fan)
    assert @album.is_shareable_by?(@idol)

    @album = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    assert @album.is_shareable_by?(@user)
    assert @album.is_shareable_by?(@friend)
    assert !@album.is_shareable_by?(@same_game_user)
    assert !@album.is_shareable_by?(@stranger)
    assert @album.is_shareable_by?(@fan)
    assert @album.is_shareable_by?(@idol)

    @album = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
    assert @album.is_shareable_by?(@user)
    assert !@album.is_shareable_by?(@friend)
    assert !@album.is_shareable_by?(@same_game_user)
    assert !@album.is_shareable_by?(@stranger)
    assert !@album.is_shareable_by?(@fan)
    assert !@album.is_shareable_by?(@idol)

    @type, @id = Share.get_type_and_id "/personal_albums/#{@album.id}"
    assert_equal @type, "Album"
    assert_equal @id.to_i, @album.id
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
