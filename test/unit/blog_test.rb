require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  def setup
    # create a user with game character
    @user = UserFactory.create
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
    
    # create stranger
    @stranger = UserFactory.create

    # create same-game-user
    @same_game_user = UserFactory.create
    @character2 = GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_user.id
    
    # create 2 guilds
    @guild1 = GuildFactory.create :character_id => @character.id, :president_id => @user.id
    @guild2 = GuildFactory.create :character_id => @character2.id, :president_id => @same_game_user.id
    @guild2.memberships.create :user_id => @user.id, :character_id => @character.id, :status => Membership::Member    
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
    
    assert_no_difference "FriendTag.count" do
      @blog.update_attributes(:new_friend_tags => [@stranger.id, @same_game_user.id])
    end
  end 

  #
  # case 5
  # view blog
  #
  test "case5" do
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id, @friend2.id]
    assert_equal @blog.viewings_count, 0

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
  # dig blog
  #
  test "case6" do
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    assert @blog.is_diggable_by?(@user)
    assert @blog.is_diggable_by?(@friend1)
    assert @blog.is_diggable_by?(@same_game_user)
    assert @blog.is_diggable_by?(@stranger)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    assert @blog.is_diggable_by?(@user)
    assert @blog.is_diggable_by?(@friend1)
    assert @blog.is_diggable_by?(@same_game_user)
    assert !@blog.is_diggable_by?(@stranger)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    assert @blog.is_diggable_by?(@user)
    assert @blog.is_diggable_by?(@friend1)
    assert !@blog.is_diggable_by?(@same_game_user)
    assert !@blog.is_diggable_by?(@stranger)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    assert @blog.is_diggable_by?(@user)
    assert !@blog.is_diggable_by?(@friend1)
    assert !@blog.is_diggable_by?(@same_game_user)
    assert !@blog.is_diggable_by?(@stranger)

    @blog = DraftFactory.create :poster_id => @user.id, :game_id => @game.id
    assert !@blog.is_diggable_by?(@user)
    assert !@blog.is_diggable_by?(@friend1)
    assert !@blog.is_diggable_by?(@same_game_user)
    assert !@blog.is_diggable_by?(@stranger)
  end 

  #
  # case 7
  # feeds about blog
  #
  test "case7" do
    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    assert @friend1.recv_feed? @blog1
    assert @guild1.recv_feed? @blog1
    assert @guild2.recv_feed? @blog1

    @blog1.update_attributes :privilege => PrivilegedResource::OWNER
    @friend1.reload
    @guild1.reload
    @guild2.reload
    assert !@friend1.recv_feed?(@blog1)
    assert !@guild1.recv_feed?(@blog1)
    assert !@guild2.recv_feed?(@blog1)    

    @blog2 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @friend1.reload
    @guild1.reload
    @guild2.reload
    assert @friend1.recv_feed? @blog2
    assert @guild1.recv_feed? @blog2
    assert @guild2.recv_feed? @blog2

    @blog3 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    @friend1.reload
    @guild1.reload
    @guild2.reload
    assert @friend1.recv_feed?(@blog3)
    assert @guild1.recv_feed? @blog3
    assert @guild2.recv_feed? @blog3

    @blog4 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    @friend1.reload
    @guild1.reload
    @guild2.reload
    assert !@friend1.recv_feed?(@blog4)
    assert !@guild1.recv_feed?(@blog4)
    assert !@guild2.recv_feed?(@blog4)
  
    @blog4.update_attributes(:privilege => PrivilegedResource::PUBLIC)
    @friend1.reload
    @guild1.reload
    @guild2.reload
    assert @friend1.recv_feed? @blog4
    assert @guild1.recv_feed? @blog4
    assert @guild2.recv_feed? @blog4    
  
    @draft1 = DraftFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    @friend1.reload
    @guild1.reload
    @guild2.reload
    assert !@friend1.recv_feed?(@draft1)
    assert !@guild1.recv_feed?(@draft1)
    assert !@guild2.recv_feed?(@draft1)
 
    @draft1.update_attributes(:privilege => PrivilegedResource::FRIEND)
    @friend1.reload
    @guild1.reload
    @guild2.reload
    assert !@friend1.recv_feed?(@draft1)
    assert !@guild1.recv_feed?(@draft1)
    assert !@guild2.recv_feed?(@draft1)
 
    @draft1.update_attributes(:draft => 0, :privilege => PrivilegedResource::OWNER)
    @friend1.reload
    @guild1.reload
    @guild2.reload
    assert !@friend1.recv_feed?(@draft1)
    assert !@guild1.recv_feed?(@draft1)
    assert !@guild2.recv_feed?(@draft1)

    @draft2 = DraftFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    @draft2.update_attributes(:draft => 0)
    @friend1.reload
    @guild1.reload
    @guild2.reload
    assert @friend1.recv_feed?(@draft2)
    assert @guild1.recv_feed?(@draft2)
    assert @guild2.recv_feed?(@draft2)
  end

  #
  # case 8
  # test share case
  #
  test "case8" do
    @blog = BlogFactory.create

    type, id = Share.get_type_and_id "/blogs/#{@blog.id}"

    assert_equal type, 'Blog'
    assert_equal id.to_i, @blog.id

    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    assert @blog1.is_shareable_by?(@user)
    assert @blog1.is_shareable_by?(@friend1)
    assert @blog1.is_shareable_by?(@same_game_user)
    assert @blog1.is_shareable_by?(@stranger)

    @blog2 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    assert @blog2.is_shareable_by?(@user)
    assert @blog2.is_shareable_by?(@friend1)
    assert @blog2.is_shareable_by?(@same_game_user)
    assert !@blog2.is_shareable_by?(@stranger)    

    @blog3 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    assert @blog3.is_shareable_by?(@user)
    assert @blog3.is_shareable_by?(@friend1)
    assert !@blog3.is_shareable_by?(@same_game_user)
    assert !@blog3.is_shareable_by?(@stranger)    

    @blog4 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    assert @blog4.is_shareable_by?(@user)
    assert !@blog4.is_shareable_by?(@friend1)
    assert !@blog4.is_shareable_by?(@same_game_user)
    assert !@blog4.is_shareable_by?(@stranger)    

    @draft = DraftFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    assert !@draft.is_shareable_by?(@user)
    assert !@draft.is_shareable_by?(@friend)
    assert !@draft.is_shareable_by?(@same_game_user)
    assert !@draft.is_shareable_by?(@stranger)       
  end
  
  #
  # case 9
  # comment blog
  #
  test "case9" do
    # TODO
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC

    assert @blog.is_commentable_by?(@user)
    assert @blog.is_commentable_by?(@friend1)
    assert @blog.is_commentable_by?(@same_game_user)
    assert @blog.is_commentable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @friend1.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @same_game_user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert @comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @stranger.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert @comment.is_deleteable_by?(@stranger)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME

    assert @blog.is_commentable_by?(@user)
    assert @blog.is_commentable_by?(@friend1)
    assert @blog.is_commentable_by?(@same_game_user)
    assert !@blog.is_commentable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @friend1.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @same_game_user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert @comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @stranger.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.id.nil?

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND

    assert @blog.is_commentable_by?(@user)
    assert @blog.is_commentable_by?(@friend1)
    assert !@blog.is_commentable_by?(@same_game_user)
    assert !@blog.is_commentable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @friend1.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @same_game_user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.id.nil?

    @comment = @blog.comments.create :poster_id => @stranger.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.id.nil?

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER

    assert @blog.is_commentable_by?(@user)
    assert !@blog.is_commentable_by?(@friend1)
    assert !@blog.is_commentable_by?(@same_game_user)
    assert !@blog.is_commentable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @friend1.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.id.nil?

    @comment = @blog.comments.create :poster_id => @same_game_user.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.id.nil?

    @comment = @blog.comments.create :poster_id => @stranger.id, :recipient_id => @user.id, :content => 'a'
    assert @comment.id.nil?
  end
  
  #
  # case 10
  # relative blogs
  #
  test "case10" do
    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 1.day.ago, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id]
    @blog2 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 2.days.ago, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@friend1.id]
    @blog3 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 3.days.ago, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend1.id]
    @blog4 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 4.days.ago, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@friend1.id]
    @draft = DraftFactory.create :poster_id => @user.id, :game_id => @game.id, :created_at => 3.days.ago, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend1.id]

    # blog index
    @blogs = @user.blogs.for('owner')
    assert_equal @blogs, [@blog1, @blog2, @blog3, @blog4]

    @blogs = @user.blogs.for('friend')
    assert_equal @blogs, [@blog1, @blog2, @blog3]

    @blogs = @user.blogs.for('same_game')
    assert_equal @blogs, [@blog1, @blog2]

    @blogs = @user.blogs.for('stranger')
    assert_equal @blogs, [@blog1]

    # friend blogs
    @blogs = Blog.by(@friend1.friend_ids)
    assert_equal @blogs, [@blog1, @blog2, @blog3, @blog4]
    
    @blogs = Blog.by(@friend1.friend_ids).for('friend')
    assert_equal @blogs, [@blog1, @blog2, @blog3]

    # relative blogs
    @blogs = @friend1.relative_blogs
    assert_equal @blogs, [@blog1, @blog2, @blog3, @blog4]

    @blogs = @friend1.relative_blogs.for('friend')
    assert_equal @blogs, [@blog1, @blog2, @blog3]
  end
  
  #
  # case 11
  # sensitive blogs
  #
  test "case11" do
    @sensitive = "政府"
    
    @blog = BlogFactory.create :title => '和谐', :poster_id => @user.id, :game_id => @game.id
    @user.reload
    @friend1.reload
    assert @blog.accepted? # 自动通过了应该
    assert @friend1.recv_feed? @blog
    assert_equal @user.blogs_count, 1

    @blog.update_attributes(:title => @sensitive)
    assert @blog.unverified?

    # 验证通过
    @blog.verify
    @user.reload
    @friend1.reload
    assert_equal @user.blogs_count, 1
    assert @friend1.recv_feed? @blog

    # 又让他不通过
    @blog.unverify
    @user.reload
    @friend1.reload
    assert_equal @user.blogs_count, 0
    assert !@friend1.recv_feed?(@blog)
 
    # 又让他通过
    @blog.verify
    @user.reload
    @friend1.reload
    assert_equal @user.blogs_count, 1
    assert @friend1.recv_feed? @blog    
  end 

end
