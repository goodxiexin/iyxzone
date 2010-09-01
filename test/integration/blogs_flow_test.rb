require 'test_helper'

class BlogsFlowTest < ActionController::IntegrationTest

  def setup
    # create a user with game character
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game

    # create friend
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @friend.id
    
    # create stranger
    @stranger = UserFactory.create

    # create same-game-user
    @same_game_user = UserFactory.create
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_user.id

    # create stranger
    @stranger = UserFactory.create

    # login
    @user_sess = login @user
    @friend_sess = login @friend
    @same_game_user_sess = login @same_game_user
    @stranger_sess = login @stranger
  
    # create 4 blogs for user
    @blog1 = BlogFactory.create :poster_id => @user.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend.id], :created_at => 1.days.ago
    @blog2 = BlogFactory.create :poster_id => @user.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@friend.id], :created_at => 2.days.ago
    @blog3 = BlogFactory.create :poster_id => @user.id, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend.id], :created_at => 3.days.ago
    @blog4 = BlogFactory.create :poster_id => @user.id, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@friend.id], :created_at => 4.days.ago
    @draft = DraftFactory.create :poster_id => @user.id

    # create 4 blogs for friend  
    @blog5 = BlogFactory.create :poster_id => @friend.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@user.id], :created_at => 5.days.ago
    @blog6 = BlogFactory.create :poster_id => @friend.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@user.id], :created_at => 6.days.ago
    @blog7 = BlogFactory.create :poster_id => @friend.id, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@user.id], :created_at => 7.days.ago
    @blog8 = BlogFactory.create :poster_id => @friend.id, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@user.id], :created_at => 8.days.ago

    @nil_id = @blog8.id + 100
  end

  test "GET recent" do
    @user_sess.get "/blogs/recent"
    @user_sess.assert_template 'user/blogs/recent'
    assert_equal @user_sess.assigns(:blogs), [@blog1, @blog2, @blog3, @blog5, @blog6, @blog7]
  end

  test "GET hot" do
    assert_difference "@blog1.digs.count" do
      @user_sess.post "/digs", {:diggable_type => 'Blog', :diggable_id => @blog1.id}
    end

    assert_difference "@blog5.digs.count" do
      @user_sess.post "/digs", {:diggable_type => 'Blog', :diggable_id => @blog5.id}
    end

    assert_difference "@blog1.digs.count" do
      @friend_sess.post "/digs", {:diggable_type => 'Blog', :diggable_id => @blog1.id}
    end

    assert_difference "@blog3.digs.count" do
      @friend_sess.post "/digs", {:diggable_type => 'Blog', :diggable_id => @blog3.id}
    end

    @user_sess.get "/blogs/hot"
    @user_sess.assert_template "user/blogs/hot"
    assert_equal @user_sess.assigns(:blogs), [@blog1, @blog3, @blog5, @blog2, @blog6, @blog7]

    @blog5.unverify
    @blog2.unverify

    @user_sess.get "/blogs/hot"
    @user_sess.assert_template "user/blogs/hot"
    assert_equal @user_sess.assigns(:blogs), [@blog1, @blog3, @blog6, @blog7]
  end

  test "GET index" do
    # 不同的人看index
    @user_sess.get "/blogs?uid=invalid"
    @user_sess.assert_not_found
    
    @user_sess.get "/blogs?uid=#{@user.id}"
    @user_sess.assert_template 'user/blogs/index'
    assert_equal @user_sess.assigns(:blogs), [@blog1, @blog2, @blog3, @blog4]

    @friend_sess.get "/blogs?uid=#{@user.id}"
    @friend_sess.assert_template 'user/blogs/index'
    assert_equal @friend_sess.assigns(:blogs), [@blog1, @blog2, @blog3]

    @blog3.unverify
    
    @friend_sess.get "/blogs?uid=#{@user.id}"
    @friend_sess.assert_template 'user/blogs/index'
    assert_equal @friend_sess.assigns(:blogs), [@blog1, @blog2]

    @same_game_user_sess.get "/blogs?uid=#{@user.id}"
    @same_game_user_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @stranger_sess.get "/blogs?uid=#{@user.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)
  end

  test "GET relative" do
    # 不同的人看relative
    @user_sess.get "/blogs/relative?uid=invalid"
    @user_sess.assert_not_found

    @user_sess.get "/blogs/relative?uid=#{@user.id}"
    @user_sess.assert_template 'user/blogs/relative'
    assert_equal @user_sess.assigns(:blogs), [@blog5, @blog6, @blog7]

    @blog5.unverify
    @user_sess.get "/blogs/relative?uid=#{@user.id}"
    @user_sess.assert_template 'user/blogs/relative'
    assert_equal @user_sess.assigns(:blogs), [@blog6, @blog7]

    @user_sess.get "/blogs/relative?uid=#{@friend.id}"
    @user_sess.assert_template 'user/blogs/relative'
    assert_equal @user_sess.assigns(:blogs), [@blog1, @blog2, @blog3]

    @user_sess.get "/blogs/relative?uid=#{@same_game_user.id}"
    @user_sess.assert_redirected_to new_friend_url(:uid => @same_game_user.id)

    @user_sess.get "/blogs/relative?uid=#{@stranger.id}"
    @user_sess.assert_redirected_to new_friend_url(:uid => @stranger.id)
  end

  test "GET show" do
    # 自己看不同权限的日志
    @user_sess.get "/blogs/invalid"
    @user_sess.assert_template "errors/404"

    @user_sess.get "/blogs/#{@blog1.id}"
    @user_sess.assert_template "user/blogs/show"
    assert_equal @user_sess.assigns(:blog), @blog1

    @user_sess.get "/blogs/#{@blog2.id}"
    @user_sess.assert_template "user/blogs/show"
    assert_equal @user_sess.assigns(:blog), @blog2

    @user_sess.get "/blogs/#{@blog3.id}"
    @user_sess.assert_template "user/blogs/show"
    assert_equal @user_sess.assigns(:blog), @blog3

    @user_sess.get "/blogs/#{@blog4.id}"
    @user_sess.assert_template "user/blogs/show"
    assert_equal @user_sess.assigns(:blog), @blog4

    @user_sess.get "/blogs/#{@draft.id}"
    @user_sess.assert_template "errors/404"

    @user_sess.get "/blogs/#{@nil_id}"
    @user_sess.assert_template "errors/404"

    # 好友看自己的日志
    @friend_sess.get "/blogs/#{@blog1.id}"
    @friend_sess.assert_template "user/blogs/show"
    assert_equal @friend_sess.assigns(:blog), @blog1

    @friend_sess.get "/blogs/#{@blog2.id}"
    @friend_sess.assert_template "user/blogs/show"
    assert_equal @friend_sess.assigns(:blog), @blog2

    @friend_sess.get "/blogs/#{@blog3.id}"
    @friend_sess.assert_template "user/blogs/show"
    assert_equal @friend_sess.assigns(:blog), @blog3

    @friend_sess.get "/blogs/#{@blog4.id}"
    @friend_sess.assert_template "errors/404"

    @friend_sess.get "/blogs/#{@draft.id}"
    @friend_sess.assert_template "errors/404"

    # 相同游戏的人看自己的日志
    @same_game_user_sess.get "/blogs/#{@blog1.id}"
    @same_game_user_sess.assert_template "user/blogs/show"
    assert_equal @same_game_user_sess.assigns(:blog), @blog1

    @same_game_user_sess.get "/blogs/#{@blog2.id}"
    @same_game_user_sess.assert_template "user/blogs/show"
    assert_equal @same_game_user_sess.assigns(:blog), @blog2

    @same_game_user_sess.get "/blogs/#{@blog3.id}"
    @same_game_user_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @same_game_user_sess.get "/blogs/#{@blog4.id}"
    @same_game_user_sess.assert_template "errors/404"

    @same_game_user_sess.get "/blogs/#{@draft.id}"
    @same_game_user_sess.assert_template "errors/404"

    # 陌生人看自己的日志
    @stranger_sess.get "/blogs/#{@blog1.id}"
    @stranger_sess.assert_template "user/blogs/show"
    assert_equal @stranger_sess.assigns(:blog), @blog1

    @stranger_sess.get "/blogs/#{@blog2.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @stranger_sess.get "/blogs/#{@blog3.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @stranger_sess.get "/blogs/#{@blog4.id}"
    @stranger_sess.assert_template "errors/404"

    @stranger_sess.get "/blogs/#{@draft.id}"
    @stranger_sess.assert_template "errors/404"

    # 日志被和谐
    @blog1.unverify
    @user_sess.get "/blogs/#{@blog1.id}"
    @user_sess.assert_template "errors/404"
  end

  test "POST create" do
    @user_sess.get "/blogs/new"
    @user_sess.assert_template "user/blogs/new"

    assert_difference "Blog.count" do
      @user_sess.post "/blogs", {:blog => {:title => 't', :content => 'c'}}
    end
    # TODO: assert js ?

    assert_no_difference "Blog.count" do
      @user_sess.post "/blogs", {:blog => {:content => 'c'}}
    end
    # TODO: assert js ?
  end

  test "GET edit & PUT update" do
    # 编辑更新自己的日志
    @user_sess.get "/blogs/#{@blog1.id}/edit"
    @user_sess.assert_template "user/blogs/edit"
    @user_sess.put "/blogs/#{@blog1.id}", {:blog => {:title => 'new title'}}
    @blog1.reload
    assert_equal @blog1.title, 'new title'

    # 编辑更新别人的日志
    @user_sess.get "/blogs/#{@blog5.id}/edit" 
    @user_sess.assert_template "errors/404"
    @user_sess.put "/blogs/#{@blog5.id}", {:blog => {:title => 'new title'}}
    @user_sess.assert_not_found
  
    @user_sess.get "/blogs/invalid/edit" 
    @user_sess.assert_template "errors/404"
    @user_sess.put "/blogs/invalid", {:blog => {:title => 'new title'}}
    @user_sess.assert_not_found
  end

  test "DELETE destroy" do
    # 删除自己／其他人的日志
    @user_sess.delete "/blogs/#{@blog1.id}"
    @user.reload
    assert_equal @user.blogs_count1, 0

    @user_sess.delete "/blogs/#{@blog5.id}"
    @user_sess.assert_not_found

    @user_sess.delete "/blogs/invalid"
    @user_sess.assert_not_found

    @blog1.unverify
    @user_sess.delete "/blogs/#{@blog1.id}"
    @user_sess.assert_not_found
  end

end
