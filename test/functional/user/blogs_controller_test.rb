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
  
  test "自己观看index" do
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

  test "好友观看index" do
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
  
  test "非好友，但是有相同游戏的人观看index" do
    get 'index', {:uid => @u1.id}, {:user_id => @u3.id}

    # 不能看到，必须先成为好友
    assert_redirected_to new_friend_url(:uid => @u1.id)
  end

  test "陌生人观看index" do
    get 'index', {:uid => @u1.id}, {:user_id => @u4.id}

    # 不能看到，必须先成为好友
    assert_redirected_to new_friend_url(:uid => @u1.id)
  end
  
  test "@u1 观看 @b1" do
    get 'show', {:id => @b1.id}, {:user_id => @u1.id}

    assert_template 'user/blogs/show'
    assert_tag 'a', :attributes => {:href => edit_blog_url(@b1)}
    assert_tag 'a', :attributes => {:href => blog_url(@b1), :rel => 'facebox'}
  end

  test "@u2 观看 @b1" do
    get 'show', {:id => @b1.id}, {:user_id => @u2.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b1)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b1), :rel => 'facebox'}
  end

  test "@u3 观看 @b1" do
    get 'show', {:id => @b1.id}, {:user_id => @u3.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b1)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b1), :rel => 'facebox'}
  end

  test "@u4 观看 @b1" do
    get 'show', {:id => @b1.id}, {:user_id => @u4.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b1)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b1), :rel => 'facebox'}
  end
  
  test "@u1 观看 @b2" do
    get 'show', {:id => @b2.id}, {:user_id => @u1.id}

    assert_template 'user/blogs/show'
    assert_tag 'a', :attributes => {:href => edit_blog_url(@b2)}
    assert_tag 'a', :attributes => {:href => blog_url(@b2), :rel => 'facebox'}
  end

  test "@u2 观看 @b2" do
    get 'show', {:id => @b2.id}, {:user_id => @u2.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b2)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b2), :rel => 'facebox'}
  end

  test "@u3 观看 @b2" do
    get 'show', {:id => @b2.id}, {:user_id => @u3.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b2)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b2), :rel => 'facebox'}
  end

  test "@u4 观看 @b2" do
    get 'show', {:id => @b2.id}, {:user_id => @u4.id}

    assert_redirected_to new_friend_url(:uid => @u1.id)
  end
  
  test "@u1 观看 @b3" do
    get 'show', {:id => @b3.id}, {:user_id => @u1.id}

    assert_template 'user/blogs/show'
    assert_tag 'a', :attributes => {:href => edit_blog_url(@b3)}
    assert_tag 'a', :attributes => {:href => blog_url(@b3), :rel => 'facebox'}
  end

  test "@u2 观看 @b3" do
    get 'show', {:id => @b3.id}, {:user_id => @u2.id}

    assert_template 'user/blogs/show'
    assert_no_tag 'a', :attributes => {:href => edit_blog_url(@b3)}
    assert_no_tag 'a', :attributes => {:href => blog_url(@b3), :rel => 'facebox'}
  end

  test "@u3 观看 @b3" do
    get 'show', {:id => @b3.id}, {:user_id => @u3.id}

    assert_redirected_to new_friend_url(:uid => @u1.id)
  end

  test "@u4 观看 @b3" do
    get 'show', {:id => @b3.id}, {:user_id => @u4.id}

    assert_redirected_to new_friend_url(:uid => @u1.id)
  end

  test "@u1 观看 @b4" do
    get 'show', {:id => @b4.id}, {:user_id => @u1.id}

    assert_template 'user/blogs/show'
    assert_tag 'a', :attributes => {:href => edit_blog_url(@b4)}
    assert_tag 'a', :attributes => {:href => blog_url(@b4), :rel => 'facebox'}
  end

  test "@u2 观看 @b4" do
    get 'show', {:id => @b4.id}, {:user_id => @u2.id}
    assert_template 'errors/404'
  end

  test "@u3 观看 @b4" do
    get 'show', {:id => @b4.id}, {:user_id => @u3.id}
    assert_template 'errors/404'  
  end

  test "@u4 观看 @b4" do
    get 'show', {:id => @b4.id}, {:user_id => @u4.id}
    assert_template 'errors/404'
  end

  test "@u2 创建了关于 @u1 的博客, @u1 去看 相关博客页面" do
    b = BlogFactory.create :poster_id => @u2.id, :game_id => @u2.games.first.id, :new_friend_tags => [@u1.id]
    get 'relative', {:uid => @u1.id}, {:user_id => @u1.id}
    assert_template 'user/blogs/relative'
    assert_equal assigns(:blogs), [b] 
  end

end
