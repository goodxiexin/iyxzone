require 'test_helper'

class FriendTagTest < ActiveSupport::TestCase

  def setup
    # create a user with game character
    @user = UserFactory.create :is_idol => true
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
  
    # create 4 friends
    @friend1 = UserFactory.create
    @friend2 = UserFactory.create
    @friend3 = UserFactory.create
    @friend4 = UserFactory.create
    FriendFactory.create @user, @friend1
    FriendFactory.create @user, @friend2
    FriendFactory.create @user, @friend3
    FriendFactory.create @user, @friend4
    [@user, @friend1, @friend2, @friend3, @friend4].each {|f| f.reload}

    # create stranger
    @stranger = UserFactory.create

    # create same-game-user
    @same_game_user = UserFactory.create
    @character2 = GameCharacterFactory.create @character.game_info.merge({:user_id => @same_game_user.id})

    # create fan and idol
    @fan = UserFactory.create
    @idol = UserFactory.create_idol
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id
    [@fan, @idol, @user].each {|f| f.reload}
  end

  test "create/delete friend tags" do
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id, @friend2.id]
    @blog.reload
    assert_equal @blog.tags_count, 2
    assert_equal @blog.relative_users, [@friend1, @friend2]

    @blog.update_attributes(:del_friend_tags => [@friend2.id])
    @blog.reload
    assert_equal @blog.tags_count, 1
    assert_equal @blog.relative_users, [@friend1] 

    @blog.update_attributes(:new_friend_tags => [@friend3.id])
    @blog.reload
    assert_equal @blog.tags_count, 2
    assert_equal @blog.relative_users, [@friend1, @friend3] 

    @blog.update_attributes(:del_friend_tags => [@friend1.id], :new_friend_tags => [@friend4.id])
    @blog.reload
    assert_equal @blog.tags_count, 2
    assert_equal @blog.relative_users, [@friend3, @friend4] 
    
    assert_no_difference "FriendTag.count" do
      @blog.update_attributes(:new_friend_tags => [@stranger.id, @same_game_user.id, @fan.id, @idol.id])
    end
  end


end
