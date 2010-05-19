require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
    @friend1 = UserFactory.create
    @friend2 = UserFactory.create
    @friend3 = UserFactory.create
    @friend4 = UserFactory.create
    FriendFactory.create @user, @friend1
    FriendFactory.create @user, @friend2
    FriendFactory.create @user, @friend3
    FriendFactory.create @user, @friend4
  end

  #
  # case 1:
  # create a blog, edit the blog and finally destroy it
  #
  test "case1" do
    # 创建一个博客
    blog = BlogFactory.create :privilege => PrivilegedResource::PUBLIC
    user = blog.poster(true)
    assert_equal user.blogs_count1, 1
    
    # 更新博客，修改权限
    blog.update_attributes(:privilege => PrivilegedResource::FRIEND_OR_SAME_GAME)
    user.reload
    assert_equal user.blogs_count1, 0
    assert_equal user.blogs_count2, 1

    # 更新博客，修改title
    blog.update_attributes(:title => '')
    assert_not_nil blog.errors.on(:title)
    blog.update_attributes(:title => 'new title')
    assert_nil blog.errors.on(:title)

    # 更新博客，修改content
    blog.update_attributes(:content => '')
    assert_not_nil blog.errors.on(:content)
    blog.update_attributes(:content => 'new content')
    assert_nil blog.errors.on(:content)

    # 删除博客
    blog.destroy
    user.reload
    assert_equal user.blogs_count2, 0
  end

  # 
  # case 2:
  # create a draft, edit draft and then publish it
  #
  test "case2" do
    # 创建博客  
    draft = DraftFactory.create :privilege => PrivilegedResource::PUBLIC
    user = draft.poster(true)
    assert_equal user.drafts_count, 1
    assert_equal user.blogs_count1, 0    

    # 发布
    draft.update_attributes(:draft => 0)
    user.reload
    assert_equal user.drafts_count, 0
    assert_equal user.blogs_count1, 1
  end
 
  #
  # case 3:
  # create a draft and then destroy it
  #
  test "case3" do
    # 创建博客  
    draft = DraftFactory.create :privilege => PrivilegedResource::PUBLIC
    user = draft.poster(true)
    assert_equal user.drafts_count, 1
    assert_equal user.blogs_count1, 0

    # 删除
    draft.destroy
    user.reload
    assert_equal user.drafts_count, 0
    assert_equal user.blogs_count1, 0
  end

  #
  # case 4
  # add/delete relative users
  #
  test "case4" do
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id, @friend2.id] 
    assert_equal @blog.relative_users, [@friend1, @friend2]

    @tag = @blog.tags.find_by_tagged_user_id(@friend2.id)
    @blog.update_attributes(:del_friend_tags => [@tag.id])
    @blog.reload
    assert_equal @blog.relative_users, [@friend1] 

    @blog.update_attributes(:new_friend_tags => [@friend3.id])
    @blog.reload
    assert_equal @blog.relative_users, [@friend1, @friend3] 

    @tag = @blog.tags.find_by_tagged_user_id(@friend1.id)
    @blog.update_attributes(:del_friend_tags => [@tag.id], :new_friend_tags => [@friend4.id])
    @blog.reload
    assert_equal @blog.relative_users, [@friend3, @friend4] 
  end 

  
 
end
