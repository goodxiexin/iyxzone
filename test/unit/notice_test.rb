require 'test_helper'

class NoticeTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
    @friend = UserFactory.create
    @user_character = GameCharacterFactory.create :user_id => @user.id
    @friend_character = GameCharacterFactory.create @user_character.game_info.merge({:user_id => @friend.id})
    @game = @user_character.game
    FriendFactory.create @user, @friend

    # create some blog comment notices
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @comment = @blog.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @notice1 = Notice.last
    
    sleep 1
    
    @comment = @blog.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @notice2 = Notice.last

    sleep 1

    @video = VideoFactory.create :poster_id => @friend.id, :game_id => @game.id, :new_friend_tags => [@user.id]
    @notice3 = Notice.last
    
    sleep 1
    
    @comment = @video.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @notice4 = Notice.last
    
    sleep 1
  
    @comment = @video.comments.create :poster_id => @friend.id, :recipient_id => @user.id, :content => 'a'
    @notice5 = Notice.last    
  end

  test "notices are unread" do
    assert_equal @user.notices, [@notice5, @notice4, @notice3, @notice2, @notice1]
    
    assert_equal @user.notices.unread, [@notice5, @notice4, @notice3, @notice2, @notice1]
    [@notice5, @notice4, @notice3, @notice2, @notice1].each do |n|
      assert !n.read
    end
  end

  test "notices count" do
    assert_equal @user.reload.notices_count, 5
    assert_equal @user.reload.unread_notices_count, 5    
  end

  test "read notices" do
    assert_no_difference "@user.reload.notices_count" do
      assert_difference "@user.reload.unread_notices_count", -1 do
        @notice1.read_by @user, true
      end
    end  
    assert @notice1.reload.read
    assert !@notice2.reload.read

    assert_no_difference "@user.reload.notices_count" do
      assert_difference "@user.reload.unread_notices_count", -2 do
        @notice4.read_by @user
      end
    end
    assert !@notice3.reload.read
    assert @notice4.reload.read
    assert @notice5.reload.read
    
  end

end
