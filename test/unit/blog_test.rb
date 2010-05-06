require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  def setup
    @user       = Factory.create :user
    @game       = Factory.create :game
    @area       = Factory.create :game_area, :game_id => @game.id
    @server     = Factory.create :game_server, :game_id => @game.id, :area_id => @area.id
    @race       = Factory.create :game_race, :game_id => @game.id
    @profession = Factory.create :game_profession, :game_id => @game.id
    @character  = Factory.create :game_character, :user_id => @user.id, :game_id => @game.id, :area_id => @area.id, :server_id => @server.id, :race_id => @race.id, :profession_id => @profession.id  
    @friend     = Factory.create :user
    @sensitive  = "政府"
    Factory.create :friendship, :user_id => @user.id, :friend_id => @friend.id
    Factory.create :friendship, :user_id => @friend.id, :friend_id => @user.id
  end

  test "日志标题包含敏感词" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => @sensitive,
      :content  => '牛比'
    })
    
    assert_equal blog.verified, 0 
    assert_equal blog.poster.blogs_count1, 1
  end
  
  test "日志内容包含敏感词" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => 'zhengfu',
      :content  => @sensitive
    })

    assert_equal blog.verified, 0 
    assert_equal blog.poster.blogs_count1, 1
  end

  test "日志标题和内容不包含敏感词" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => 'sb',
      :content  => 'sb'
    })

    assert_equal blog.verified, 1 
    assert_equal blog.poster.blogs_count1, 1
  end

  test "屏蔽某篇待审核的日志" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => @sensitive,
      :content  => @sensitive
    })

    assert_equal blog.verified, 0 
    assert_equal blog.poster.blogs_count1, 1
  
    blog.unverify
    blog.reload

    assert_equal blog.verified, 2
    assert_equal blog.poster.blogs_count1, 0
  end

  test "将审核通过的日志变为审核不通过" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => 'sb',
      :content  => 'sb'
    })

    assert_equal blog.verified, 1 
    assert_equal blog.poster.blogs_count1, 1

    blog.unverify
    blog.reload

    assert_equal blog.verified, 2
    assert_equal blog.poster.blogs_count1, 0
  end

  test "将审核不通过的日志变成审核通过" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => @sensitive,
      :content  => @sensitive
    })

    assert_equal blog.verified, 0 
    assert_equal blog.poster.blogs_count1, 1
  
    blog.unverify
    blog.reload

    assert_equal blog.verified, 2
    assert_equal blog.poster.blogs_count1, 0

    blog.verify
    blog.reload

    assert_equal blog.verified, 1
    assert_equal blog.poster.blogs_count1, 1    
  end

  test "删除审核通过的日志" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => 'sb',
      :content  => 'sb'
    })

    assert_equal blog.verified, 1 
    assert_equal blog.poster.blogs_count1, 1
  
    blog.destroy
    @user.reload

    assert_equal @user.blogs_count1, 0
  end

  test "删除审核不通过的日志" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => @sensitive,
      :content  => @sensitive
    })

    assert_equal blog.verified, 0 
    assert_equal blog.poster.blogs_count1, 1
  
    blog.unverify
    blog.reload

    assert_equal blog.verified, 2
    assert_equal blog.poster.blogs_count1, 0

    blog.destroy
    @user.reload

    assert_equal @user.blogs_count1, 0
  end

  test "我的日志列表中不包括审核不通过的日志" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => @sensitive,
      :content  => @sensitive
    })

    assert_equal blog.verified, 0 
    assert_equal blog.poster.blogs_count1, 1
  
    blog.unverify
    @user.reload

    assert @user.blogs_count1, 0
    assert @user.blogs.blank?
  end

  test "好友日志不包括审核不通过的日志" do
    assert @friend.has_friend? @user    

    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => @sensitive,
      :content  => @sensitive
    })

    assert_equal blog.verified, 0 
    assert_equal @friend.friend_blogs, [blog] 

    blog.unverify
    @friend.reload

    assert @friend.friend_blogs.blank?
  end

  test "相关日志不包括审核不通过的日志" do
    blog = Blog.create({
      :poster_id  => @user.id,
      :game_id  => @game.id,
      :title    => @sensitive,
      :content  => @sensitive,
      :friend_tags => [@friend.id]
    })

    assert_equal blog.verified, 0
    assert_equal @friend.relative_blogs, [blog] 

    blog.unverify
    @friend.reload

    assert @friend.relative_blogs.blank?
  end

end
