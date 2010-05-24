require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  # 只用blog来测试
  # 具体什么时候能挖，在具体的commentable类里测试
  # 这里只测试基本的计数器和是否是重复挖
  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
  
    # create 4 friends
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    
    # create stranger
    @stranger = UserFactory.create

    # create same-game-user
    @same_game_user = UserFactory.create
    @character2 = GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_user.id
  
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id
  end

  test "counter" do
    @blog.comments.create :content => 'comment', :recipient_id => @user.id, :poster_id => @user.id
    @blog.reload
    assert_equal @blog.comments_count, 1

    @comment = @blog.comments.create :content => 'comment', :recipient_id => @friend.id, :poster_id => @user.id
    @blog.reload
    assert_equal @blog.comments_count, 2

    @blog.comments.create :content => 'comment', :recipient_id => @same_game_user.id, :poster_id => @user.id
    @blog.reload
    assert_equal @blog.comments_count, 3

    @blog.comments.create :content => 'comment', :recipient_id => @stranger.id, :poster_id => @user.id
    @blog.reload
    assert_equal @blog.comments_count, 4

    @comment.destroy
    @blog.reload
    assert_equal @blog.comments_count, 3

    @blog.comments.create :content => 'comment', :recipient_id => @friend.id, :poster_id => @user.id
    @blog.reload
    assert_equal @blog.comments_count, 4    
  end

end
