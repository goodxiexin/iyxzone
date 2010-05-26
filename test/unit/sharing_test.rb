require 'test_helper'

class SharingTest < ActiveSupport::TestCase

  def setup
    # create a user with game character
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
  
    # create 4 friends
    @friend = UserFactory.create
    FriendFactory.create @user, @friend1
    
    # create stranger
    @stranger = UserFactory.create

    # create same-game-user
    @same_game_user = UserFactory.create
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_user.id
    
    # create 2 guilds
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id
  end

  test "分享" do
    r = 'reason'
    t = 'title'

    assert @blog.share_by(@user, r, t)
    @blog.reload
    assert @blog.sharings_count, 1
    assert @blog.shared_by?(@user)

    assert @blog.share_by(@friend, r, t)
    @blog.reload
    assert @blog.sharings_count, 2
    assert @blog.shared_by?(@friend)

    assert @blog.share_by(@same_game_user, r, t)
    @blog.reload
    assert @blog.sharings_count, 3
    assert @blog.shared_by?(@same_game_user)

    assert @blog.share_by(@stranger, r, t)
    @blog.reload
    assert @blog.sharings_count, 4
    assert @blog.shared_by?(@same_game_user)

    assert_equal @blog.first_sharer, @user
  end

end
