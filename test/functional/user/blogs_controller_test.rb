require 'test_helper'

# 如何测试page.redirect_to
class User::BlogsControllerTest < ActionController::TestCase

  include AuthenticatedTestHelper

  def setup
    @u1 = UserFactory.create
    @g = @u1.games.first

    # create blogs
    @b1 = BlogFactory.create :privilege => 1, :poster_id => @u1.id, :game_id => @g.id, :created_at => 1.minutes.ago
    @b2 = BlogFactory.create :privilege => 2, :poster_id => @u1.id, :game_id => @g.id, :created_at => 2.minutes.ago
    @b3 = BlogFactory.create :privilege => 3, :poster_id => @u1.id, :game_id => @g.id, :created_at => 3.minutes.ago 
    @b4 = BlogFactory.create :privilege => 4, :poster_id => @u1.id, :game_id => @g.id, :created_at => 4.minutes.ago
    
    # friend
    @u2 = UserFactory.create
    FriendshipFactory.create_friend @u1, @u2

    # same game
    @u3 = UserFactory.create
    @c = @u1.characters.first
    GameCharacterFactory.create :game_id => @c.game_id, :area_id => @c.area_id, :server_id => @c.server_id, :race_id => @c.race_id, :profession_id => @c.profession_id, :user_id => @u3.id

    # stranger
    @u4 = UserFactory.create
  end
  
  test "自己观看" do
    get 'index', {:uid => @u1.id}, {:user_id => @u1.id}
    
    blogs = assigns(:blogs)
 
    assert_template 'user/blogs/index'
    assert_equal blogs, [@b1, @b2, @b3, @b4]
   
    blogs.each do |b|
      assert_tag :tag => 'a', :attributes => {:href => edit_blog_url(b)}
    end

    blogs.each do |b|
      assert_tag :tag => 'a', :attributes => {:href => blog_url(b), :rel => 'facebox'}
    end
  end

  test "好友观看" do
    get 'index', {:uid => @u1.id}, {:user_id => @u2.id}

    blogs = assigns(:blogs)

    assert_template 'user/blogs/index'
    assert_equal blogs, [@b1, @b2, @b3]
    blogs.each do |b|
      assert_no_tag :tag => 'a', :attributes => {:href => edit_blog_url(b)}
    end
    blogs.each do |b|
      assert_no_tag :tag => 'a', :attributes => {:href => blog_url(b), :rel => 'facebox'}
    end
  end
  
  test "非好友，但是有相同游戏的人观看" do
    get 'index', {:uid => @u1.id}, {:user_id => @u3.id}

    # 不能看到，必须先成为好友
    assert_redirected_to new_friend_url(:uid => @u1.id)
  end

  test "完全陌生人观看" do
    get 'index', {:uid => @u1.id}, {:user_id => @u4.id}

    # 不能看到，必须先成为好友
    assert_redirected_to new_friend_url(:uid => @u1.id)
  end

  test "@u1 观看 @b1" do
    get 'show', {:id => @b1.id}, {:user_id => @u1.id}

    assert_template 'user/blogs/show'
    assert_tag 'a', :attributes => {:href => edit_blog_url(@b1)}
    assert_tag 'a', :attributes => {:href => blog_url(@b1), :rel => 'facebox_confirm'}
  end

  test "@u2 观看 @b1" do
    get 'show', {:id => @b1.id}, {:user_id => @u2.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b1)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b1), :rel => 'facebox_confirm'}
  end

  test "@u3 观看 @b1" do
    get 'show', {:id => @b1.id}, {:user_id => @u3.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b1)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b1), :rel => 'facebox_confirm'}
  end

  test "@u4 观看 @b1" do
    get 'show', {:id => @b1.id}, {:user_id => @u1.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b1)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b1), :rel => 'facebox_confirm'}
  end

  test "@u1 观看 @b2" do
    get 'show', {:id => @b2.id}, {:user_id => @u1.id}

    assert_template 'user/blogs/show'
    assert_tag 'a', :attributes => {:href => edit_blog_url(@b2)}
    assert_tag 'a', :attributes => {:href => blog_url(@b2), :rel => 'facebox_confirm'}
  end

  test "@u2 观看 @b2" do
    get 'show', {:id => @b2.id}, {:user_id => @u2.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b2)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b2), :rel => 'facebox_confirm'}
  end

  test "@u3 观看 @b2" do
    get 'show', {:id => @b2.id}, {:user_id => @u3.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b2)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b2), :rel => 'facebox_confirm'}
  end

  test "@u4 观看 @b2" do
    get 'show', {:id => @b2.id}, {:user_id => @u1.id}

    assert_redirected_to new_friend_url(:uid => @u1.id)
  end

  test "@u1 观看 @b3" do
    get 'show', {:id => @b3.id}, {:user_id => @u1.id}

    assert_template 'user/blogs/show'
    assert_tag 'a', :attributes => {:href => edit_blog_url(@b3)}
    assert_tag 'a', :attributes => {:href => blog_url(@b3), :rel => 'facebox_confirm'}
  end

  test "@u2 观看 @b3" do
    get 'show', {:id => @b3.id}, {:user_id => @u2.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b3)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b3), :rel => 'facebox_confirm'}
  end

  test "@u3 观看 @b3" do
    get 'show', {:id => @b3.id}, {:user_id => @u3.id}

    assert_redirected_to new_friend_url(:uid => @u3.id)
  end

  test "@u4 观看 @b3" do
    get 'show', {:id => @b3.id}, {:user_id => @u4.id}

    assert_redirected_to new_friend_url(:uid => @u1.id)
  end

  test "@u1 观看 @b4" do
    get 'show', {:id => @b3.id}, {:user_id => @u1.id}

    assert_template 'user/blogs/show'
    assert_tag 'a', :attributes => {:href => edit_blog_url(@b3)}
    assert_tag 'a', :attributes => {:href => blog_url(@b3), :rel => 'facebox_confirm'}
  end

  test "@u2 观看 @b4" do
    get 'show', {:id => @b3.id}, {:user_id => @u2.id}
    assert_template 'errors/404'
  end

  test "@u3 观看 @b4" do
    get 'show', {:id => @b3.id}, {:user_id => @u3.id}
    assert_template 'errors/404'  
  end

  test "@u4 观看 @b4" do
    get 'show', {:id => @b3.id}, {:user_id => @u4.id}
    assert_template 'errors/404'
  end

=begin
  # 测试create
  test "创建博客" do
    # 正确的params
    post 'create', {:blog => @params}, {:user_id => 3}
    @user3.reload
    assert_equal @user3.blogs_count, 1
   
    # 带有tag的博客
    post 'create', {:blog => @params.merge({:friend_tags => [1]})}
    @user3.reload
    blog = assigns(:blog)
    blog.reload
    assert_equal @user3.blogs_count, 2
    assert_equal blog.tags_count, 1
 
    # 错误的params
    post 'create', {:blog => nil}
    @user3.reload
    assert_equal @user3.blogs_count, 2
  end

  test "将草稿保存为博客" do
    put 'update', {:id => @draft.id}, {:user_id => 2}
    @user2.reload
    assert_equal @user2.blogs_count, 5
    assert_equal @user2.drafts_count, 0
  end

  # 测试edit
  test "编辑自己的博客" do
    get 'edit', {:id => @blog1.id}, {:user_id => 2}
    assert_template 'user/blogs/edit'
  end

  test "编辑别人的博客" do
    get 'edit', {:id => @blog1.id}, {:user_id => 4}
    assert_not_found
  end

  # 测试update
  test "更新自己博客" do
    # 正确的params
    put 'update', {:blog => @params, :id => @blog2.id}, {:user_id => 2}
    @blog2.reload
    assert_equal @blog2.privilege, 1
    
    # 错误的params
    put 'update', {:blog => {:privilege => 3, :title => nil}, :id => @blog2.id}
    @blog2.reload
    assert_equal @blog2.privilege, 1 
  end

  test "更新别人的博客" do
    put 'update', {:blog => @params, :id => @blog1.id}, {:user_id => 4}
    assert_not_found
  end

  # 测试destroy
  test "删除自己的博客" do
    delete 'destroy', {:id => @blog1.id}, {:user_id => 2}
    @user2.reload
    assert_equal @user2.blogs_count, 3
  end

  test "删除别人的博客" do
    delete 'destroy', {:id => @blog1.id}, {:user_id => 4}
    assert_not_found
  end

  # 测试hot, recent和friends
  test "热门博客" do
    get 'hot', {:id => 1}, {:user_id => 1}

    # 返回的是hot页面
    assert_template 'user/blogs/hot'

    # 返回3篇日志，按照digs_count排列
    blogs = assigns(:blogs)
    assert_equal blogs.count, 3
    assert_equal blogs[0], @blog3
    assert_equal blogs[1], @blog2
    assert_equal blogs[2], @blog1
  end
    
  test "最新博客" do
    get 'recent', {:id => 1}, {:user_id => 1}
  
    # 返回的是recent页面
    assert_template 'user/blogs/recent'
    
    # 返回3篇日志，按照digs_count排列
    blogs = assigns(:blogs)
    assert_equal blogs.count, 3
    assert_equal blogs[0], @blog1
    assert_equal blogs[1], @blog2
    assert_equal blogs[2], @blog3
  end
    
  test "好友博客" do
    get 'friends', {}, {:user_id => 1}

    # 返回friends页面
    assert_template 'user/blogs/friends'

    # 共3篇日志，按照时间排列
    blogs = assigns(:blogs)
    assert_equal blogs.count, 3
    assert_equal blogs[0], @blog1
    assert_equal blogs[1], @blog2
    assert_equal blogs[2], @blog3
  end
  
=end
end
