require 'test_helper'

# 如何测试page.redirect_to
class User::BlogsControllerTest < ActionController::TestCase

  include AuthenticatedTestHelper

  def setup
    # create a user with game character
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

    # create 2 guilds
    @guild1 = GuildFactory.create :character_id => @character.id, :president_id => @user.id
    @guild2 = GuildFactory.create :character_id => @character2.id, :president_id => @same_game_user.id
    @guild2.memberships.create :user_id => @user.id, :character_id => @character.id, :status => Membership::Member

    # create 4 blogs for user
    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend.id]
    @blog2 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@friend.id]
    @blog3 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend.id]
    @blog4 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@friend.id]
    @draft = DraftFactory.create :poster_id => @user.id, :game_id => @game.id
  end

  test "view hot pages" do
    get 'hot', {}, {:user_id => @user.id} 
    assert_template 'user/blogs/hot'
  end

  test "view recent page" do
    get 'recent', {}, {:user_id => @user.id}
    assert_template 'user/blogs/recent'
  end

  test "view index page" do
    get 'index', {:uid => @user.id}, {:user_id => @user.id}
    assert_template 'user/blogs/index'
    assert_equal assigns(:blogs), @user.blogs.for('owner')

    get 'index', {:uid => @friend.id}, {}
    assert_template 'user/blogs/index'
    assert assigns(:blogs).blank?

    get 'index', {:uid => @same_game_user.id}, {}
    assert_template 'errors/404'

    get 'index', {:uid => @stranger.id}, {}
    assert_template 'errors/404'
  end

  test "view relative page" do
    get 'relative', {:uid => @user.id}, {:user_id => @user.id}
    assert_template 'user/blogs/relative'
    assert assigns(:blogs).blank?

    get 'relative', {:uid => @friend.id}, {}
    assert_template 'user/blogs/relative'
    assert_equal assigns(:blogs), @friend.relative_blogs.for('friend')

    get 'relative', {:uid => @same_game_user.id}, {}
    assert_template 'errors/404'

    get 'relative', {:uid => @stranger.id}, {}
    assert_template 'errors/404'
  end
 
end
