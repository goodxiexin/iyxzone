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
    @stranger = UserFactory.create
    @same_game_user = UserFactory.create
    @character2 = GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_user.id
    @guild1 = GuildFactory.create :character_id => @character.id, :president_id => @user.id
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
  end 

  #
  # case 5
  # create a blog, some one view the blog
  #
  test "case5" do
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id, @friend2.id]
    assert_equal @blog.digs_count, 0

    @blog.viewed_by @user
    @blog.reload
    assert_equal @blog.viewings_count, 1

    @blog.viewed_by @friend1
    @blog.reload
    assert_equal @blog.viewings_count, 2

    @blog.viewed_by @stranger
    @blog.reload
    assert_equal @blog.viewings_count, 3

    @blog.viewed_by @same_game_user
    @blog.reload
    assert_equal @blog.viewings_count, 4
  end

  #
  # case 6
  # create a public blog, everyone can dig it only once
  # then create a friend-or-same-game-viewable blog, try digging
  # then create a friend-viewable blog, try digging
  # then create a owner-viewable blog, try digging
  #
  test "case6" do
    # 创建public日志
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    assert_equal @blog.digs_count, 0
 
    assert @blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1
    assert !@blog.dug_by(@user) 
    @blog.reload
    assert_equal @blog.digs_count, 1
    
    assert @blog.dug_by(@friend1)
    @blog.reload
    assert_equal @blog.digs_count, 2
    assert !@blog.dug_by(@friend1)
    @blog.reload
    assert_equal @blog.digs_count, 2
    
    assert @blog.dug_by(@same_game_user)
    @blog.reload
    assert_equal @blog.digs_count, 3
    assert !@blog.dug_by(@same_game_user)
    @blog.reload
    assert_equal @blog.digs_count, 3

    assert @blog.dug_by(@stranger)
    @blog.reload
    assert_equal @blog.digs_count, 4
    assert !@blog.dug_by(@stranger)
    @blog.reload
    assert_equal @blog.digs_count, 4

    # 创建friend or same game日志
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @blog.reload
    assert_equal @blog.digs_count, 0

    assert @blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1
    assert !@blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1
    
    assert @blog.dug_by(@friend1)
    @blog.reload
    assert_equal @blog.digs_count, 2
    assert !@blog.dug_by(@friend1)
    @blog.reload
    assert_equal @blog.digs_count, 2
    assert @blog.dug_by(@same_game_user)
    @blog.reload
    assert_equal @blog.digs_count, 3
    assert !@blog.dug_by(@same_game_user)
    @blog.reload
    assert_equal @blog.digs_count, 3

    assert !@blog.dug_by(@stranger)
    @blog.reload
    assert_equal @blog.digs_count, 3
    assert !@blog.dug_by(@stranger)
    @blog.reload
    assert_equal @blog.digs_count, 3

    # 创建friend日志
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    @blog.reload
    assert_equal @blog.digs_count, 0

    assert @blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1
    assert !@blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1

    assert @blog.dug_by(@friend1)
    @blog.reload
    assert_equal @blog.digs_count, 2
    assert !@blog.dug_by(@friend1)
    @blog.reload
    assert_equal @blog.digs_count, 2

    assert !@blog.dug_by(@same_game_user)
    @blog.reload
    assert_equal @blog.digs_count, 2
    assert !@blog.dug_by(@same_game_user)
    @blog.reload
    assert_equal @blog.digs_count, 2

    assert !@blog.dug_by(@stranger)
    @blog.reload
    assert_equal @blog.digs_count, 2
    assert !@blog.dug_by(@stranger)
    @blog.reload
    assert_equal @blog.digs_count, 2

    # 创建owner日志
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    @blog.reload
    assert_equal @blog.digs_count, 0

    assert @blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1
    assert !@blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1

    assert !@blog.dug_by(@friend1)
    @blog.reload
    assert_equal @blog.digs_count, 1
    assert !@blog.dug_by(@friend1)
    @blog.reload
    assert_equal @blog.digs_count, 1

    assert !@blog.dug_by(@same_game_user)
    @blog.reload
    assert_equal @blog.digs_count, 1
    assert !@blog.dug_by(@same_game_user)
    @blog.reload
    assert_equal @blog.digs_count, 1

    assert !@blog.dug_by(@stranger)
    @blog.reload
    assert_equal @blog.digs_count, 1
    assert !@blog.dug_by(@stranger)
    @blog.reload
    assert_equal @blog.digs_count, 1
  end 

  #
  # case 7
  # create a blog, poster's friends and guilds will receive the feed
  #
  test "case7" do
    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    assert @friend1.recv_feed? @blog1
    assert @guild1.recv_feed? @blog1

    @blog2 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    assert @friend1.recv_feed? @blog2
    assert @guild1.recv_feed? @blog2

    @blog3 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    assert @friend1.recv_feed? @blog3
    assert @guild1.recv_feed? @blog3

    @blog4 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    assert @friend1.recv_feed?(@blog4)
    assert @guild1.recv_feed?(@blog4)

    @blog4.update_attributes(:privilege => PrivilegedResource::PUBLIC)
    assert @friend1.recv_feed?(@blog4)
    assert @guild1.recv_feed?(@blog4)

    @draft = DraftFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    assert !@friend1.recv_feed?(@draft)
    assert !@guild1.recv_feed?(@draft)

    @draft.update_attributes(:draft => 0)
    assert @friend1.recv_feed?(@draft)
    assert @guild1.recv_feed?(@draft)
 
  end
 
end
