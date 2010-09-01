#
# recv_feed? same_game_user?
#
require 'test_helper'

class EventPhotoTest < ActiveSupport::TestCase

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
  
  test "photo should inherit some attributes from album" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto' 
    
    assert_equal @photo.privilege, @album.privilege
    assert_equal @photo.poster_id, @album.poster_id
  end

  test "create photo and set it as cover" do
    assert_nil @album.cover

    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto' 
    @album.reload
    assert_nil @album.cover

    # two ways to set cover of album
    @album.set_cover @photo1
    @album.reload
    assert_equal @album.cover, @photo1

    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto', :is_cover => 1 
    @album.reload 
    assert_equal @album.cover, @photo2

    @photo2.update_attributes :is_cover => 0
    @album.reload
    assert_nil @album.cover
  end

  test "sensitive photo" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
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

  test "event photo feed" do
    @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
    @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
    @p = @event.confirmed_participations.create :character_id => @character2.id, :participant_id => @same_game_user.id
    @album.record_upload @user, [@photo1, @photo2]
    
    @friend.reload and @same_game_user.reload and @fan.reload and @idol.reload
    assert @friend.recv_feed?(@album)
    assert @same_game_user.recv_feed?(@album)
    assert @fan.recv_feed?(@album)
    assert !@idol.recv_feed?(@album)
  end
  
  test "tag photo" do
    @photo = PhotoFactory.create :album_id => @album.id, :type =>'EventPhoto'
    assert @photo.is_taggable_by?(@user)
    [@friend, @same_game_user, @stranger, @fan, @idol].each do |u|
      assert !@photo.is_taggable_by?(u)
    end
    assert_equal @photo.tag_candidates_for(@user), [@user]

    @event.confirmed_participations.create :participant_id => @same_game_user.id, :character_id => @character2.id
    @event.reload and @photo.reload # 是的，这很奇怪，但是你必须这么做，不然photo.album.event还是老的event
    assert @photo.is_taggable_by?(@same_game_user)
    assert_equal @photo.tag_candidates_for(@same_game_user), [@user, @same_game_user]

    @tag = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @user.id, :tagged_user_id => @same_game_user.id
    assert @tag.is_deleteable_by?(@user)
    [@friend, @same_game_user, @stranger, @fan, @idol].each do |u|
      assert !@tag.is_deleteable_by?(u)
    end
    
    @tag = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @same_game_user.id, :tagged_user_id => @user.id
    assert @tag.is_deleteable_by?(@user)
    [@friend, @same_game_user, @stranger, @fan, @idol].each do |u|
      assert !@tag.is_deleteable_by?(u)
    end
  end
  
  test "tag notice" do
    @photo = PhotoFactory.create :album_id => @album.id, :type =>'EventPhoto'
    @event.confirmed_participations.create :participant_id => @same_game_user.id, :character_id => @character2.id
 
    @tag = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @user.id, :tagged_user_id => @same_game_user.id
    @same_game_user.reload
    assert @same_game_user.recv_notice?(@tag) 

    @tag = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @same_game_user.id, :tagged_user_id => @user.id
    @user.reload
    assert @user.recv_notice?(@tag) 
  end
  
  test "comment avatar" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
  
    assert @photo.is_commentable_by?(@user)
    assert @photo.is_commentable_by?(@friend)
    assert @photo.is_commentable_by?(@same_game_user)
    assert @photo.is_commentable_by?(@stranger)
    assert @photo.is_commentable_by?(@fan)
    assert @photo.is_commentable_by?(@idol)

    [@user, @friend, @same_game_user, @stranger, @fan, @idol].each do |u|
      @comment = @photo.comments.create :poster_id => u.id, :recipient_id => @user.id, :content => 'a'
      assert @comment.is_deleteable_by?(@user)
      assert @comment.is_deleteable_by?(u)
      ([@friend, @same_game_user, @stranger, @fan, @idol] - [u]).each do |u|
        assert !@comment.is_deleteable_by?(u)
      end
    end
  end

  test "comment notice" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'

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

  test "dig photo" do
    @photo = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'

    assert @photo.is_diggable_by?(@user)
    assert @photo.is_diggable_by?(@friend)
    assert @photo.is_diggable_by?(@same_game_user)
    assert @photo.is_diggable_by?(@stranger)
    assert @photo.is_diggable_by?(@fan)
    assert @photo.is_diggable_by?(@idol)
  end

  test "album photos_count" do
    assert_difference "@album.reload.photos_count" do
      @photo1 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
    end

    assert_difference "@album.reload.photos_count" do
      @photo2 = PhotoFactory.create :album_id => @album.id, :type => 'EventPhoto'
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
