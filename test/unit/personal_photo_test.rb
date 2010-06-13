require 'test_helper'

class PersonalPhotoTest < ActiveSupport::TestCase

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
    [@user, @friend, @fan, @idol].each {|f| f.reload}

    @sensitive = "政府" 
  end
  
  test "photo automatically inherits some attributes from album" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'

    assert_equal @photo.poster_id, @album.owner_id
    assert_equal @photo.game_id, @album.game_id
    assert_equal @photo.privilege, @album.privilege
  end

  test "photo has the same privilege with album" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
  
    @album.update_attributes :privilege => PrivilegedResource::OWNER
    @photo.reload
    assert_equal @photo.privilege, PrivilegedResource::OWNER
  end

  test "photos count" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id

    assert_difference "@album.reload.photos_count" do
      @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    end

    assert_difference "@album.reload.photos_count" do
      @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    end

    assert_difference "@album.reload.photos_count", -1 do
      @photo1.unverify
    end

    assert_no_difference "@album.reload.photos_count" do
      @photo1.destroy
    end

    assert_difference "@album.reload.photos_count", -1 do
      @photo2.destroy
    end
  end

  test "destroy cover" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto', :is_cover => 1

    @album.reload
    assert_equal @album.cover, @photo

    @photo.destroy

    @album.reload
    assert_nil @album.cover
  end
  
  test "set cover, migration" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id
    @photo1 = PhotoFactory.create :album_id => @album1.id, :is_cover => 1, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album2.id, :is_cover => 1, :type => 'PersonalPhoto'
    @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 1
    assert_equal @album2.photos_count, 1
    assert_equal @album1.cover, @photo1
    assert_equal @album2.cover, @photo2

    @photo1.update_attributes :is_cover => 0
    @photo2.update_attributes :is_cover => 0
    @album1.reload and @album2.reload
    assert_nil @album1.cover
    assert_nil @album2.cover
    
    @album1.set_cover @photo1
    @album2.set_cover @photo2

    @photo3 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto', :is_cover => 1
    @album1.reload
    assert_equal @album1.cover, @photo3
    assert_equal @album1.photos_count, 2

    # move photo to another album
    @photo1.update_attributes(:album_id => @album2.id)
    @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 1
    assert_equal @album2.photos_count, 2
    assert_equal @album1.cover, @photo3
    assert_equal @album2.cover, @photo2

    # move cover to another album
    @photo3.update_attributes(:album_id => @album2.id)
    @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 0
    assert_equal @album2.photos_count, 3
    assert_nil @album1.cover
    assert_equal @album2.cover, @photo2
 
    # move photo and set it as cover
    @photo1.update_attributes(:album_id => @album1.id, :is_cover => 1)
    @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 1
    assert_equal @album2.photos_count, 2
    assert_equal @album1.cover, @photo1
    assert_equal @album2.cover, @photo2
 
    @photo2.update_attributes(:album_id => @album1.id, :is_cover => 1)
    @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 2
    assert_equal @album2.photos_count, 1
    assert_equal @album1.cover, @photo2
    assert_nil @album2.cover
  end
  
  test "photo feeds" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER

    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'

    @album1.record_upload @user, [@photo1, @photo2]
    @friend.reload and @fan.reload and @idol.reload
    assert @friend.recv_feed?(@album1)
    assert @fan.recv_feed?(@album1)
    assert !@idol.recv_feed?(@album1)

    @album1.unverify
    @friend.reload and @fan.reload and @idol.reload
    assert !@friend.recv_feed?(@album1)
    assert !@fan.recv_feed?(@album1)
    assert !@idol.recv_feed?(@album1)

    @photo1 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'

    @album2.record_upload @user, [@photo1, @photo2]
    @friend.reload and @fan.reload and @idol.reload
    assert !@friend.recv_feed?(@album2)
    assert !@fan.recv_feed?(@album2)
    assert !@idol.recv_feed?(@album2)
  end

  test "comment photo" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @photo3 = PhotoFactory.create :album_id => @album3.id, :type => 'PersonalPhoto'
    @photo4 = PhotoFactory.create :album_id => @album4.id, :type => 'PersonalPhoto'

    assert @photo1.is_commentable_by?(@user)
    assert @photo1.is_commentable_by?(@friend)
    assert @photo1.is_commentable_by?(@same_game_user)
    assert @photo1.is_commentable_by?(@stranger)
    assert @photo1.is_commentable_by?(@fan)
    assert @photo1.is_commentable_by?(@idol)

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each do |role|
      @comment = @photo1.comments.create :poster_id => role.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@user)
      assert @comment.is_deleteable_by?(role)
      ([@friend, @same_game_user, @stranger, @fan, @idol] - [role]).each do |u|
        assert !@comment.is_deleteable_by?(u)
      end
    end

    assert @photo2.is_commentable_by?(@user)
    assert @photo2.is_commentable_by?(@friend)
    assert @photo2.is_commentable_by?(@same_game_user)
    assert !@photo2.is_commentable_by?(@stranger)
    assert @photo2.is_commentable_by?(@fan)
    assert @photo2.is_commentable_by?(@idol)

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each do |role|
      if @photo2.is_commentable_by?(role)
        @comment = @photo2.comments.create :poster_id => role.id, :recipient_id => @user.id, :content => 'a'
        assert @comment.is_deleteable_by?(@user)
        assert @comment.is_deleteable_by?(role)
        ([@friend, @same_game_user, @stranger, @fan, @idol] - [role]).each do |u|
          assert !@comment.is_deleteable_by?(u)
        end
      end
    end

    assert @photo3.is_commentable_by?(@user)
    assert @photo3.is_commentable_by?(@friend)
    assert !@photo3.is_commentable_by?(@same_game_user)
    assert !@photo3.is_commentable_by?(@stranger)
    assert @photo3.is_commentable_by?(@fan)
    assert @photo3.is_commentable_by?(@idol)

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each do |role|
      if @photo3.is_commentable_by?(role)
        @comment = @photo3.comments.create :poster_id => role.id, :recipient_id => @user.id, :content => 'a'
        assert @comment.is_deleteable_by?(@user)
        assert @comment.is_deleteable_by?(role)
        ([@friend, @same_game_user, @stranger, @fan, @idol] - [role]).each do |u|
          assert !@comment.is_deleteable_by?(u)
        end
      end
    end

    assert @photo4.is_commentable_by?(@user)
    assert !@photo4.is_commentable_by?(@friend)
    assert !@photo4.is_commentable_by?(@same_game_user)
    assert !@photo4.is_commentable_by?(@stranger)
    assert !@photo4.is_commentable_by?(@fan)
    assert !@photo4.is_commentable_by?(@idol)

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each do |role|
      if @photo4.is_commentable_by?(role)
        @comment = @photo4.comments.create :poster_id => role.id, :recipient_id => @user.id, :content => 'a'
        assert @comment.is_deleteable_by?(@user)
        assert @comment.is_deleteable_by?(role)
        ([@friend, @same_game_user, @stranger, @fan, @idol] - [role]).each do |u|
          assert !@comment.is_deleteable_by?(u)
        end
      end
    end

  end

  test "comment notice" do
    @album = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'PersonalPhoto'
    @tag = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @user.id, :tagged_user_id => @friend.id
    
    assert_no_difference "Notice.count" do
      @comment = @album.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    end

    assert_difference "Notice.count" do
      @comment = @album.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload and @friend.reload
    assert @user.recv_notice?(@comment)
    assert !@friend.recv_notice?(@comment)
    
    assert_difference "Notice.count" do
      @comment = @album.comments.create :poster_id => @fan.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload and @friend.reload
    assert @user.recv_notice?(@comment)
    assert !@friend.recv_notice?(@comment)

    assert_difference "Notice.count", 2 do
      @comment = @album.comments.create :poster_id => @idol.id, :recipient_id => @fan.id, :content => 'a'
    end
    @user.reload and @friend.reload and @fan.reload
    assert @user.recv_notice?(@comment)
    assert !@friend.recv_notice?(@comment)
    assert @fan.recv_notice?(@comment)
  end

  test "share photo" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @photo3 = PhotoFactory.create :album_id => @album3.id, :type => 'PersonalPhoto'
    @photo4 = PhotoFactory.create :album_id => @album4.id, :type => 'PersonalPhoto'

    assert @photo1.is_shareable_by?(@user)
    assert @photo1.is_shareable_by?(@friend)
    assert @photo1.is_shareable_by?(@same_game_user)
    assert @photo1.is_shareable_by?(@stranger)
    assert @photo1.is_shareable_by?(@fan)
    assert @photo1.is_shareable_by?(@idol)

    assert @photo2.is_shareable_by?(@user)
    assert @photo2.is_shareable_by?(@friend)
    assert @photo2.is_shareable_by?(@same_game_user)
    assert !@photo2.is_shareable_by?(@stranger)
    assert @photo2.is_shareable_by?(@fan)
    assert @photo2.is_shareable_by?(@idol)

    assert @photo3.is_shareable_by?(@user)
    assert @photo3.is_shareable_by?(@friend)
    assert !@photo3.is_shareable_by?(@same_game_user)
    assert !@photo3.is_shareable_by?(@stranger)
    assert @photo3.is_shareable_by?(@fan)
    assert @photo3.is_shareable_by?(@idol)

    assert @photo4.is_shareable_by?(@user)
    assert !@photo4.is_shareable_by?(@friend)
    assert !@photo4.is_shareable_by?(@same_game_user)
    assert !@photo4.is_shareable_by?(@stranger)
    assert !@photo4.is_shareable_by?(@fan)
    assert !@photo4.is_shareable_by?(@idol)
  end

  test "dig photo" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @photo3 = PhotoFactory.create :album_id => @album3.id, :type => 'PersonalPhoto'
    @photo4 = PhotoFactory.create :album_id => @album4.id, :type => 'PersonalPhoto'

    assert @photo1.is_diggable_by?(@user)
    assert @photo1.is_diggable_by?(@friend)
    assert @photo1.is_diggable_by?(@same_game_user)
    assert @photo1.is_diggable_by?(@stranger)
    assert @photo1.is_diggable_by?(@fan)
    assert @photo1.is_diggable_by?(@idol)

    assert @photo2.is_diggable_by?(@user)
    assert @photo2.is_diggable_by?(@friend)
    assert @photo2.is_diggable_by?(@same_game_user)
    assert !@photo2.is_diggable_by?(@stranger)
    assert @photo2.is_diggable_by?(@fan)
    assert @photo2.is_diggable_by?(@idol)

    assert @photo3.is_diggable_by?(@user)
    assert @photo3.is_diggable_by?(@friend)
    assert !@photo3.is_diggable_by?(@same_game_user)
    assert !@photo3.is_diggable_by?(@stranger)
    assert @photo3.is_diggable_by?(@fan)
    assert @photo3.is_diggable_by?(@idol)

    assert @photo4.is_diggable_by?(@user)
    assert !@photo4.is_diggable_by?(@friend)
    assert !@photo4.is_diggable_by?(@same_game_user)
    assert !@photo4.is_diggable_by?(@stranger)
    assert !@photo4.is_diggable_by?(@fan)
    assert !@photo4.is_diggable_by?(@idol)
  end

  test "tag personal photo" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @photo3 = PhotoFactory.create :album_id => @album3.id, :type => 'PersonalPhoto'
    @photo4 = PhotoFactory.create :album_id => @album4.id, :type => 'PersonalPhoto'

    assert @photo1.is_taggable_by?(@user)
    assert @photo1.is_taggable_by?(@friend)
    assert !@photo1.is_taggable_by?(@same_game_user)
    assert !@photo1.is_taggable_by?(@stranger)
    assert !@photo1.is_taggable_by?(@fan)
    assert !@photo1.is_taggable_by?(@idol)
    assert_equal @photo1.tag_candidates_for(@user), [@user, @friend]
    assert_equal @photo1.tag_candidates_for(@friend), [@friend, @user]

    @tag = PhotoTagFactory.create :photo_id => @photo1.id, :poster_id => @user.id, :tagged_user_id => @friend.id
    assert @tag.is_deleteable_by?(@user)
    assert !@tag.is_deleteable_by?(@friend)
    assert !@tag.is_deleteable_by?(@same_game_user)
    assert !@tag.is_deleteable_by?(@stranger)
    assert !@tag.is_deleteable_by?(@fan)
    assert !@tag.is_deleteable_by?(@idol)

    @tag = PhotoTagFactory.create :photo_id => @photo1.id, :poster_id => @friend.id, :tagged_user_id => @friend.id
    assert @tag.is_deleteable_by?(@user)
    assert !@tag.is_deleteable_by?(@friend)
    assert !@tag.is_deleteable_by?(@same_game_user)
    assert !@tag.is_deleteable_by?(@stranger)
    assert !@tag.is_deleteable_by?(@fan)
    assert !@tag.is_deleteable_by?(@idol)

    assert @photo2.is_taggable_by?(@user)
    assert @photo2.is_taggable_by?(@friend)
    assert !@photo2.is_taggable_by?(@same_game_user)
    assert !@photo2.is_taggable_by?(@stranger)
    assert !@photo2.is_taggable_by?(@fan)
    assert !@photo2.is_taggable_by?(@idol)
    assert_equal @photo2.tag_candidates_for(@user), [@user, @friend]
    assert_equal @photo2.tag_candidates_for(@friend), [@friend, @user]

    @tag = PhotoTagFactory.create :photo_id => @photo2.id, :poster_id => @user.id, :tagged_user_id => @friend.id
    assert @tag.is_deleteable_by?(@user)
    assert !@tag.is_deleteable_by?(@friend)
    assert !@tag.is_deleteable_by?(@same_game_user)
    assert !@tag.is_deleteable_by?(@stranger)
    assert !@tag.is_deleteable_by?(@fan)
    assert !@tag.is_deleteable_by?(@idol)

    @tag = PhotoTagFactory.create :photo_id => @photo2.id, :poster_id => @friend.id, :tagged_user_id => @friend.id
    assert @tag.is_deleteable_by?(@user)
    assert !@tag.is_deleteable_by?(@friend)
    assert !@tag.is_deleteable_by?(@same_game_user)
    assert !@tag.is_deleteable_by?(@stranger)
    assert !@tag.is_deleteable_by?(@fan)
    assert !@tag.is_deleteable_by?(@idol)

    assert @photo3.is_taggable_by?(@user)
    assert @photo3.is_taggable_by?(@friend)
    assert !@photo3.is_taggable_by?(@same_game_user)
    assert !@photo3.is_taggable_by?(@stranger)
    assert !@photo3.is_taggable_by?(@fan)
    assert !@photo3.is_taggable_by?(@idol)

    assert_equal @photo3.tag_candidates_for(@user), [@user, @friend]
    assert_equal @photo3.tag_candidates_for(@friend), [@friend, @user]

    @tag = PhotoTagFactory.create :photo_id => @photo3.id, :poster_id => @user.id, :tagged_user_id => @friend.id
    assert @tag.is_deleteable_by?(@user)
    assert !@tag.is_deleteable_by?(@friend)
    assert !@tag.is_deleteable_by?(@same_game_user)
    assert !@tag.is_deleteable_by?(@stranger)
    assert !@tag.is_deleteable_by?(@fan)
    assert !@tag.is_deleteable_by?(@idol)

    @tag = PhotoTagFactory.create :photo_id => @photo3.id, :poster_id => @friend.id, :tagged_user_id => @friend.id
    assert @tag.is_deleteable_by?(@user)
    assert !@tag.is_deleteable_by?(@friend)
    assert !@tag.is_deleteable_by?(@same_game_user)
    assert !@tag.is_deleteable_by?(@stranger)
    assert !@tag.is_deleteable_by?(@fan)
    assert !@tag.is_deleteable_by?(@idol)

    assert @photo4.is_taggable_by?(@user)
    assert !@photo4.is_taggable_by?(@friend)
    assert !@photo4.is_taggable_by?(@same_game_user)
    assert !@photo4.is_taggable_by?(@stranger)
    assert !@photo4.is_taggable_by?(@fan)
    assert !@photo4.is_taggable_by?(@idol)
    assert_equal @photo1.tag_candidates_for(@user), [@user, @friend]

    @tag = PhotoTagFactory.create :photo_id => @photo4.id, :poster_id => @user.id, :tagged_user_id => @friend.id
    assert @tag.is_deleteable_by?(@user)
    assert !@tag.is_deleteable_by?(@friend)
    assert !@tag.is_deleteable_by?(@same_game_user)
    assert !@tag.is_deleteable_by?(@stranger)
    assert !@tag.is_deleteable_by?(@fan)
    assert !@tag.is_deleteable_by?(@idol)
  end

  test "tag notice" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::PUBLIC
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @album3 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::FRIEND
    @album4 = PersonalAlbumFactory.create :owner_id => @user.id, :privilege => PrivilegedResource::OWNER
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @photo3 = PhotoFactory.create :album_id => @album3.id, :type => 'PersonalPhoto'
    @photo4 = PhotoFactory.create :album_id => @album4.id, :type => 'PersonalPhoto'

    @friend2 = UserFactory.create
    FriendFactory.create @friend2, @user
    FriendFactory.create @friend2, @same_game_user

    assert_difference "Notice.count" do
      @tag = PhotoTagFactory.create :photo_id => @photo1.id, :tagged_user_id => @friend.id, :poster_id => @user.id
    end
    @friend.reload
    assert @friend.recv_notice?(@tag)

    assert_difference "Notice.count", 2 do
      @tag = PhotoTagFactory.create :photo_id => @photo1.id, :tagged_user_id => @same_game_user.id, :poster_id => @friend2.id
    end
    @same_game_user.reload and @user.reload
    assert @same_game_user.recv_notice?(@tag)
    assert @user.recv_notice?(@tag)

    assert_difference "Notice.count" do
      @tag = PhotoTagFactory.create :photo_id => @photo2.id, :tagged_user_id => @friend.id, :poster_id => @user.id
    end
    @friend.reload
    assert @friend.recv_notice?(@tag)

    assert_difference "Notice.count", 2 do
      @tag = PhotoTagFactory.create :photo_id => @photo2.id, :tagged_user_id => @same_game_user.id, :poster_id => @friend2.id
    end
    @same_game_user.reload and @user.reload
    assert @same_game_user.recv_notice?(@tag)
    assert @user.recv_notice?(@tag)

    assert_difference "Notice.count" do
      @tag = PhotoTagFactory.create :photo_id => @photo3.id, :tagged_user_id => @friend.id, :poster_id => @user.id
    end
    @friend.reload
    assert @friend.recv_notice?(@tag)

    assert_difference "Notice.count", 2 do
      @tag = PhotoTagFactory.create :photo_id => @photo3.id, :tagged_user_id => @same_game_user.id, :poster_id => @friend2.id
    end
    @same_game_user.reload and @user.reload
    assert @same_game_user.recv_notice?(@tag)
    assert @user.recv_notice?(@tag)

    assert_no_difference "Notice.count" do
      @tag = PhotoTagFactory.create :photo_id => @photo4.id, :tagged_user_id => @friend.id, :poster_id => @user.id
    end
    @friend.reload
    assert !@friend.recv_notice?(@tag)
  end
  
  test "migrate" do
    @album1 = PersonalAlbumFactory.create :owner_id => @user.id
    @album2 = PersonalAlbumFactory.create :owner_id => @user.id
    @photo1 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo2 = PhotoFactory.create :album_id => @album1.id, :type => 'PersonalPhoto'
    @photo3 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
    @photo4 = PhotoFactory.create :album_id => @album2.id, :type => 'PersonalPhoto'
 
    @album1.reload and @album2.reload
    assert_equal @album1.photos_count, 2
    assert_equal @album2.photos_count, 2
 
    PersonalPhoto.migrate :from => @album1, :to => @album2

    @album1.reload and @album2.reload and @photo1.reload and @photo2.reload
    assert_equal @album1.photos_count, 0
    assert_equal @album2.photos_count, 4
    assert_equal @photo1.album, @album2
    assert_equal @photo2.album, @album2
  end

end
