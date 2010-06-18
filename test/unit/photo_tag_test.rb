require 'test_helper'

class PhotoTagTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
    @album = @user.avatar_album
    @photo = PhotoFactory.create :poster_id => @user.id, :album_id => @album.id, :type => 'Avatar'
    @friend1 = UserFactory.create
    @friend2 = UserFactory.create
    FriendFactory.create @user, @friend1
    FriendFactory.create @user, @friend2
    [@user, @friend1, @friend2].each {|f| f.reload}
  end

  test "tags count" do
    assert_difference "Email.count" do
      @tag1 = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @user.id, :tagged_user_id => @friend1.id
    end
    @photo.reload and @friend1.reload
    assert_equal @photo.tags_count, 1
    assert @friend1.recv_notice?(@tag1)

    assert_difference "@photo.reload.tags_count" do
      @tag2 = PhotoTagFactory.create :photo_id => @photo.id, :poster_id => @user.id, :tagged_user_id => @friend2.id
    end

    @photo.reload
    assert_equal @photo.relative_users, [@friend1, @friend2]
  end



end
