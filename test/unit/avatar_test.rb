#
# set/unset cover
#
require 'test_helper'

class AvatarTest < ActiveSupport::TestCase

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

  test "avatar should inherit some attributes from album" do
    @photo = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar' 
    
    assert_equal @photo.privilege, @album.privilege
    assert_equal @photo.poster_id, @album.poster_id
  end

  test "create avatar and set it as cover" do
    assert_nil @album.cover
    assert_nil @user.avatar   

    @photo1 = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar' 
    @album.reload and @user.reload
    assert_nil @album.cover
    assert_nil @user.avatar

    # two ways to set cover of album
    @album.set_cover @photo1
    @album.reload and @user.reload
    assert_equal @album.cover, @photo1
    assert_equal @user.avatar, @photo1

    @photo2 = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar', :is_cover => 1 
    @album.reload and @user.reload
    assert_equal @album.cover, @photo2
    assert_equal @user.avatar, @photo2

    @photo2.update_attributes :is_cover => 0
    @album.reload and @user.reload
    assert_nil @album.cover
    assert_nil @user.avatar

    @photo1.update_attributes :is_cover => 1
    @album.reload and @user.reload
    assert_equal @album.cover, @photo1
    assert_equal @user.avatar, @photo1
  end

  test "sensitive avatar" do
    @photo = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar'
    @album.reload
    assert @photo.unverified?
    assert_equal @album.photos_count, 1

    @photo.verify
    @album.reload
    assert_equal @album.photos_count, 1
   
    @photo.update_attributes(:notation => @sensitive)
    assert @photo.unverified?

    @photo.unverify
    @album.reload
    assert_equal @album.photos_count, 0

    @photo.destroy
    @album.reload
    assert_equal @album.photos_count, 0
  end

  test "avatar feed" do
    @photo = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar'
    @friend.reload and @fan.reload and @idol.reload
    assert !@friend.recv_feed?(@photo)
    assert !@fan.recv_feed?(@photo)
    assert !@idol.recv_feed?(@photo)

    @photo.crop({:x1 => 10, :y1 => 10, :x2 => 10, :y2 => 10}, {:x1 => 10, :y1 => 10, :x2 => 10, :y2 => 10})
    @friend.reload and @fan.reload and @idol.reload
    assert @friend.recv_feed?(@photo)
    assert @fan.recv_feed?(@photo)
    assert !@idol.recv_feed?(@photo)
  end
  
  test "tag avatar" do
    @photo = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type =>'Avatar'
    
    assert @photo.is_taggable_by?(@user)
    assert @photo.is_taggable_by?(@friend)
    assert !@photo.is_taggable_by?(@same_game_user)
    assert !@photo.is_taggable_by?(@stranger)
    assert !@photo.is_taggable_by?(@fan)
    assert !@photo.is_taggable_by?(@idol)
    
    assert_equal @photo.tag_candidates_for(@user), [@user, @friend]
    assert_equal @photo.tag_candidates_for(@friend), [@friend, @user]    

    @tag = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @user.id, :tagged_user_id => @friend.id
    assert @tag.is_deleteable_by?(@user)
    assert !@tag.is_deleteable_by?(@friend)
    assert !@tag.is_deleteable_by?(@same_game_user)
    assert !@tag.is_deleteable_by?(@stranger)
    assert !@tag.is_deleteable_by?(@fan)
    assert !@tag.is_deleteable_by?(@idol)

    @tag = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @friend.id, :tagged_user_id => @friend.id
    assert @tag.is_deleteable_by?(@user)
    assert !@tag.is_deleteable_by?(@friend)
    assert !@tag.is_deleteable_by?(@same_game_user)
    assert !@tag.is_deleteable_by?(@stranger)
    assert !@tag.is_deleteable_by?(@fan)
    assert !@tag.is_deleteable_by?(@idol)
  end
  
  test "tag notice" do
    @photo = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type =>'Avatar'

    @tag = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @user.id, :tagged_user_id => @friend.id
    @friend.reload
    assert @friend.recv_notice?(@tag) 

    @friend2 = UserFactory.create
    FriendFactory.create @user, @friend2
    FriendFactory.create @friend, @friend2

    @tag = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @friend2.id, :tagged_user_id => @friend.id
    @friend.reload and @user.reload
    assert @friend.recv_notice?(@tag) 
    assert @user.recv_notice?(@tag)
  end

  test "comment avatar" do
    @photo = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar'
  
    assert @photo.is_commentable_by?(@user)
    assert @photo.is_commentable_by?(@friend)
    assert !@photo.is_commentable_by?(@same_game_user)
    assert !@photo.is_commentable_by?(@stranger)
    assert @photo.is_commentable_by?(@fan)
    assert @photo.is_commentable_by?(@idol)

    @comment = @photo.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @photo.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @photo.comments.create :poster_id => @fan.id, :recipient_id => @friend.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert @comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @photo.comments.create :poster_id => @idol.id, :recipient_id => @fan.id, :content => 'a'
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert @comment.is_deleteable_by?(@idol)
  end

  test "comment notice" do
    @photo = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar'

    assert_no_difference "Notice.count" do
      @comment = @photo.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    end

    assert_difference "Notice.count" do
      @comment = @photo.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload
    assert @user.recv_notice?(@comment)

    assert_difference "Notice.count" do
      @comment = @photo.comments.create :poster_id => @friend.id, :recipient_id => @friend.id, :content => 'a'
    end
    @user.reload
    assert @user.recv_notice?(@comment)

    assert_difference "Notice.count", 2 do
      @comment = @photo.comments.create :poster_id => @fan.id, :recipient_id => @friend.id, :content => 'a'
    end
    @user.reload and @friend.reload
    assert @user.recv_notice?(@comment)
    assert @friend.recv_notice?(@comment)
  end

  test "dig avatar" do
    @photo = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar'

    assert @photo.is_diggable_by?(@user)
    assert @photo.is_diggable_by?(@friend)
    assert !@photo.is_diggable_by?(@same_game_user)
    assert !@photo.is_diggable_by?(@stranger)
    assert @photo.is_diggable_by?(@fan)
    assert @photo.is_diggable_by?(@idol)
  end

  test "album photos_count" do
    assert_difference "@album.reload.photos_count" do
      @photo1 = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar'
    end

    assert_difference "@album.reload.photos_count" do
      @photo2 = PhotoFactory.create :album_id => @album.id, :poster_id => @user.id, :type => 'Avatar'
    end

    assert_difference "@album.reload.photos_count", -1 do
      @photo1.destroy
    end

    assert_difference "@album.reload.photos_count", -1 do
      @photo2.unverify
    end

    assert_difference "@album.reload.photos_count" do
      @photo2.verify
    end

    @photo2.unverify
    assert_no_difference "@album.reload.photos_count" do
      @photo2.destroy
    end
  end
  
end
