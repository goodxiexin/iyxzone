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
    @character2 = GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @friend.id
    
    # create stranger
    @stranger = UserFactory.create

    # create same-game-user
    @same_game_user = UserFactory.create
    @character3 = GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_user.id

    # create 2 guilds
    @guild1 = GuildFactory.create :character_id => @character.id, :president_id => @user.id
    @guild2 = GuildFactory.create :character_id => @character3.id, :president_id => @same_game_user.id
    @guild2.memberships.create :user_id => @user.id, :character_id => @character.id, :status => Membership::Member

    # create 4 blogs for user
    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend.id], :created_at => 1.days.ago
    @blog2 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@friend.id], :created_at => 2.days.ago
    @blog3 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend.id], :created_at => 3.days.ago
    @blog4 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@friend.id], :created_at => 4.days.ago
    @draft = DraftFactory.create :poster_id => @user.id, :game_id => @game.id

    # create 4 blogs for friend  
    @blog5 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@user.id], :created_at => 5.days.ago
    @blog6 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@user.id], :created_at => 6.days.ago
    @blog7 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@user.id], :created_at => 7.days.ago
    @blog8 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@user.id], :created_at => 8.days.ago

  end

  test "view hot pages" do
    get 'hot', {}, {:user_id => @user.id} 
    assert_template 'user/blogs/hot'
    assert_equal assigns(:blogs), [@blog1, @blog2, @blog3, @blog5, @blog6, @blog7]

    @blog2.dug_by @user
    @blog5.dug_by @user
    @blog6.dug_by @user
    @blog6.dug_by @friend

    get 'hot', {}, {:user_id => @user.id}
    assert_template 'user/blogs/hot'
    assert_equal assigns(:blogs), [@blog6, @blog2, @blog5, @blog1, @blog3, @blog7]
  end

  test "view recent page" do
    get 'recent', {}, {:user_id => @user.id}
    assert_template 'user/blogs/recent'
    assert_equal assigns(:blogs), [@blog1, @blog2, @blog3, @blog5, @blog6, @blog7]
  end

  test "view index page" do
    get 'index', {:uid => @user.id}, {:user_id => @user.id}
    assert_template 'user/blogs/index'
    assert_equal assigns(:blogs), [@blog1, @blog2, @blog3, @blog4]

    get 'index', {:uid => @friend.id}, {}
    assert_template 'user/blogs/index'
    assert_equal assigns(:blogs), [@blog5, @blog6, @blog7]

    get 'index', {:uid => @same_game_user.id}, {}
    assert_redirected_to new_friend_url(:uid => @same_game_user.id)

    get 'index', {:uid => @stranger.id}, {}
    assert_redirected_to new_friend_url(:uid => @stranger.id)
  
    get 'index', {:uid => @stranger.id + 100}, {}
    assert_template 'errors/404'
  end

  test "view relative page" do
    get 'relative', {:uid => @user.id}, {:user_id => @user.id}
    assert_template 'user/blogs/relative'
    assert_equal assigns(:blogs), [@blog5, @blog6, @blog7]

    get 'relative', {:uid => @friend.id}, {}
    assert_template 'user/blogs/relative'
    assert_equal assigns(:blogs), [@blog1, @blog2, @blog3]

    get 'relative', {:uid => @same_game_user.id}, {}
    assert_redirected_to new_friend_url(:uid => @same_game_user.id)

    get 'relative', {:uid => @stranger.id}, {}
    assert_redirected_to new_friend_url(:uid => @stranger.id)

    get 'relative', {:uid => @stranger.id + 100}, {}
    assert_template 'errors/404'
  end

  test "view friends page" do
    get 'friends', {}, {:user_id => @user.id}
    assert_template 'user/blogs/friends'
    assert_equal assigns(:blogs), [@blog5, @blog6, @blog7]
  end

  test "view own blog" do
    get "show", {:id => @blog1.id}, {:user_id => @user.id}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog1

    get "show", {:id => @blog2.id}, {}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog2

    get "show", {:id => @blog3.id}, {}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog3

    get "show", {:id => @blog4.id}, {}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog4
  
    get "show", {:id => @draft.id}, {}
    assert_template 'errors/404'

    get 'index', {:uid => @blog8.id + 100}, {}
    assert_template 'errors/404'
  end

  test "view friend's blog" do
    get "show", {:id => @blog5.id}, {:user_id => @user.id}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog5

    get "show", {:id => @blog6.id}, {}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog6

    get "show", {:id => @blog7.id}, {}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog7

    get "show", {:id => @blog8.id}, {}
    assert_template 'errors/402'
  end
  
  test "view same game user's blog" do
    get "show", {:id => @blog5.id}, {:user_id => @same_game_user.id}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog5

    get "show", {:id => @blog6.id}, {}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog6

    get "show", {:id => @blog7.id}, {}
    assert_redirected_to new_friend_url(:uid => @friend.id)

    get "show", {:id => @blog8.id}, {}
    assert_template 'errors/402'
  end

  test "view stranger's blog" do
    get "show", {:id => @blog1.id}, {:user_id => @stranger.id}
    assert_template 'user/blogs/show'
    assert_equal assigns(:blog), @blog1

    get "show", {:id => @blog2.id}, {}
    assert_redirected_to new_friend_url(:uid => @user.id)

    get "show", {:id => @blog3.id}, {}
    assert_redirected_to new_friend_url(:uid => @user.id)

    get "show", {:id => @blog4.id}, {}
    assert_template 'errors/402'
  end

  test "new" do
    get "new", {}, {:user_id => @user.id}
    assert_template 'user/blogs/new'
  end
 
  test "create" do
    params = {:title => 'h', :content => 'h', :game_id => @game.id}
  
    assert_difference "Blog.count" do 
      post "create", {:blog => params}, {:user_id => @user.id}
    end

    # TODO: js redirect_to ?

    params.delete(:title)
    assert_no_difference "Blog.count" do
      post "create", {:blog => params}, {}
    end
    
    # TODO: js replace html
  end

  test "edit" do
    get "edit", {:id => @blog1.id}, {:user_id => @user.id}
    assert_template 'user/blogs/edit'    

    get "edit", {:id => @blog2.id}, {}
    assert_template 'user/blogs/edit'    

    get "edit", {:id => @blog3.id}, {}
    assert_template 'user/blogs/edit'    

    get "edit", {:id => @blog4.id}, {}
    assert_template 'user/blogs/edit'    

    get "edit", {:id => @draft.id}, {}
    assert_template 'errors/404'
  
    get "edit", {:id => @blog8.id + 100}, {}
    assert_template 'errors/404'
  end

  test "update" do
    put "update", {:id => @blog1.id, :blog => {:title => 'a'}}, {:user_id => @user.id}
    # TODO: js redirect to
    @blog1.reload
    assert_equal @blog1.title, 'a'
    
    put "update", {:id => @blog1.id, :blog => {:title => nil}}, {}
    # TODO: js replace html
    @blog1.reload
    assert_equal @blog1.title, 'a'

    put "update", {:id => @blog5.id}, {}
    assert_template 'errors/404'
  end

  test "destroy" do
    assert_difference "Blog.count", -1 do
      delete "destroy", {:id => @blog1.id}, {:user_id => @user.id}
    end

    # TODO: js redirect_to

    assert_no_difference "Blog.count" do
      delete "destroy", {:id => @blog8.id}, {}
    end

    assert_template 'errors/404'

    assert_no_difference "Blog.count" do
      delete "destroy", {:id => @blog8.id + 100}, {}
    end

    assert_template 'errors/404'
  end

end
