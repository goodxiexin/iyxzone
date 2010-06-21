require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  def setup
    # create a user with game character
    @user = UserFactory.create_idol
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
    [@user, @friend1, @friend2, @friend3, @frien4].each {|f| f.reload}
    
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

  test "create, edit, destroy" do
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

  test "create a draft, edit it and finnally publish" do
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
 
  test "create/destroy a draft" do
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

  test "friend tags" do
    # tested in test/unit/friend_tag_test.rb
    assert_difference "Notice.count" do
      BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id]
    end
    @tag = FriendTag.last
    @friend1.reload
    assert @friend1.recv_notice?(@tag)

    # tested in test/unit/friend_tag_test.rb
    assert_difference "Notice.count" do
      BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@friend1.id]
    end
    @tag = FriendTag.last
    @friend1.reload
    assert @friend1.recv_notice?(@tag)

    assert_difference "Notice.count" do
      BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend1.id]
    end
    @tag = FriendTag.last
    @friend1.reload
    assert @friend1.recv_notice?(@tag)

    assert_no_difference "Notice.count" do
      BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@friend1.id]
    end
    @tag = FriendTag.last
    @friend1.reload
    assert !@friend1.recv_notice?(@tag)

    assert_no_difference "Notice.count" do
      DraftFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@friend1.id]
    end
    @tag = FriendTag.last
    @friend1.reload
    assert !@friend1.recv_notice?(@tag)
  end 

  test "view blogs" do
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id, @friend2.id]

    assert @blog.is_viewable_by?(@user)
    assert @blog.is_viewable_by?(@friend1)
    assert @blog.is_viewable_by?(@same_game_user)
    assert @blog.is_viewable_by?(@stranger)
    assert @blog.is_viewable_by?(@fan)
    assert @blog.is_viewable_by?(@idol)
  end

  test "dig blog" do
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    assert @blog.is_diggable_by?(@user)
    assert @blog.is_diggable_by?(@friend1)
    assert @blog.is_diggable_by?(@same_game_user)
    assert @blog.is_diggable_by?(@stranger)
    assert @blog.is_diggable_by?(@fan)
    assert @blog.is_diggable_by?(@idol)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    assert @blog.is_diggable_by?(@user)
    assert @blog.is_diggable_by?(@friend1)
    assert @blog.is_diggable_by?(@same_game_user)
    assert !@blog.is_diggable_by?(@stranger)
    assert @blog.is_diggable_by?(@fan)
    assert @blog.is_diggable_by?(@idol)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    assert @blog.is_diggable_by?(@user)
    assert @blog.is_diggable_by?(@friend1)
    assert !@blog.is_diggable_by?(@same_game_user)
    assert !@blog.is_diggable_by?(@stranger)
    assert @blog.is_diggable_by?(@fan)
    assert @blog.is_diggable_by?(@idol)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    assert @blog.is_diggable_by?(@user)
    assert !@blog.is_diggable_by?(@friend1)
    assert !@blog.is_diggable_by?(@same_game_user)
    assert !@blog.is_diggable_by?(@stranger)
    assert !@blog.is_diggable_by?(@fan)
    assert !@blog.is_diggable_by?(@idol)

    @blog = DraftFactory.create :poster_id => @user.id, :game_id => @game.id
    assert !@blog.is_diggable_by?(@user)
    assert !@blog.is_diggable_by?(@friend1)
    assert !@blog.is_diggable_by?(@same_game_user)
    assert !@blog.is_diggable_by?(@stranger)
    assert !@blog.is_diggable_by?(@fan)
    assert !@blog.is_diggable_by?(@idol)
  end 

  test "blog feed" do
    # create 2 guilds first
    @guild1 = GuildFactory.create :character_id => @character.id, :president_id => @user.id
    @guild2 = GuildFactory.create :character_id => @character2.id, :president_id => @same_game_user.id
    @guild2.memberships.create :user_id => @user.id, :character_id => @character.id, :status => Membership::Member    

    # let @user be a super star
    @user.is_idol = true
    @user.save
    @fan = UserFactory.create
    @fanship = Fanship.create :fan_id => @fan.id, :idol_id => @user.id

    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    assert @friend1.recv_feed? @blog1
    assert @guild1.recv_feed? @blog1
    assert @guild2.recv_feed? @blog1
    assert @fan.recv_feed? @blog1
    assert !@idol.recv_feed?(@blog1)

    @blog1.update_attributes :privilege => PrivilegedResource::OWNER
    @friend1.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@blog1)
    assert !@guild1.recv_feed?(@blog1)
    assert !@guild2.recv_feed?(@blog1)    
    assert !@fan.recv_feed?(@blog1)
    assert !@idol.recv_feed?(@blog1)

    @blog2 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    @friend1.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert @friend1.recv_feed? @blog2
    assert @guild1.recv_feed? @blog2
    assert @guild2.recv_feed? @blog2
    assert @fan.recv_feed? @blog2
    assert !@idol.recv_feed?(@blog2)

    @blog2.unverify
    @friend1.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@blog1)
    assert !@guild1.recv_feed?(@blog1)
    assert !@guild2.recv_feed?(@blog1)    
    assert !@fan.recv_feed?(@blog1)
    assert !@idol.recv_feed?(@blog1)

    @blog2.verify
    @friend1.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert @friend1.recv_feed? @blog2
    assert @guild1.recv_feed? @blog2
    assert @guild2.recv_feed? @blog2
    assert @fan.recv_feed? @blog2
    assert !@idol.recv_feed?(@blog1)

    @blog3 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    @friend1.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert @friend1.recv_feed? @blog3
    assert @guild1.recv_feed? @blog3
    assert @guild2.recv_feed? @blog3
    assert @fan.recv_feed? @blog3
    assert !@idol.recv_feed?(@blog3)

    @blog4 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    @friend1.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@blog4)
    assert !@guild1.recv_feed?(@blog4)
    assert !@guild2.recv_feed?(@blog4)
    assert !@fan.recv_feed?(@blog4)
    assert !@idol.recv_feed?(@blog4)

    @blog4.update_attributes(:privilege => PrivilegedResource::PUBLIC)
    @friend1.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert @friend1.recv_feed? @blog4
    assert @guild1.recv_feed? @blog4
    assert @guild2.recv_feed? @blog4    
    assert @fan.recv_feed? @blog4
    assert !@idol.recv_feed?(@blog4)

    @draft1 = DraftFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    @friend1.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@draft1)
    assert !@guild1.recv_feed?(@draft1)
    assert !@guild2.recv_feed?(@draft1)
    assert !@fan.recv_feed?(@draft1)
    assert !@idol.recv_feed?(@draft1)

    @draft1.update_attributes(:privilege => PrivilegedResource::FRIEND)
    @friend1.reload and @guild1.reload and @guild2.reload and @fan.reload
    assert !@friend1.recv_feed?(@draft1)
    assert !@guild1.recv_feed?(@draft1)
    assert !@guild2.recv_feed?(@draft1)
    assert !@fan.recv_feed?(@draft1)
    assert !@idol.recv_feed?(@draft1)
  end

  test "share blog" do
    @blog = BlogFactory.create

    type, id = Share.get_type_and_id "/blogs/#{@blog.id}"

    assert_equal type, 'Blog'
    assert_equal id.to_i, @blog.id

    @blog1 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC
    assert @blog1.is_shareable_by?(@user)
    assert @blog1.is_shareable_by?(@friend1)
    assert @blog1.is_shareable_by?(@same_game_user)
    assert @blog1.is_shareable_by?(@stranger)
    assert @blog1.is_shareable_by?(@fan)
    assert @blog1.is_shareable_by?(@idol)

    @blog2 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME
    assert @blog2.is_shareable_by?(@user)
    assert @blog2.is_shareable_by?(@friend1)
    assert @blog2.is_shareable_by?(@same_game_user)
    assert !@blog2.is_shareable_by?(@stranger)    
    assert @blog1.is_shareable_by?(@fan)
    assert @blog1.is_shareable_by?(@idol)

    @blog3 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    assert @blog3.is_shareable_by?(@user)
    assert @blog3.is_shareable_by?(@friend1)
    assert !@blog3.is_shareable_by?(@same_game_user)
    assert !@blog3.is_shareable_by?(@stranger)    
    assert @blog1.is_shareable_by?(@fan)
    assert @blog1.is_shareable_by?(@idol)

    @blog4 = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER
    assert @blog4.is_shareable_by?(@user)
    assert !@blog4.is_shareable_by?(@friend1)
    assert !@blog4.is_shareable_by?(@same_game_user)
    assert !@blog4.is_shareable_by?(@stranger)    
    assert !@blog4.is_shareable_by?(@fan)
    assert !@blog4.is_shareable_by?(@idol)

    @draft = DraftFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND
    assert !@draft.is_shareable_by?(@user)
    assert !@draft.is_shareable_by?(@friend)
    assert !@draft.is_shareable_by?(@same_game_user)
    assert !@draft.is_shareable_by?(@stranger)
    assert !@draft.is_shareable_by?(@fan)
    assert !@draft.is_shareable_by?(@idol)
  end
 
  test "comment blog" do
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC

    assert @blog.is_commentable_by?(@user)
    assert @blog.is_commentable_by?(@friend1)
    assert @blog.is_commentable_by?(@same_game_user)
    assert @blog.is_commentable_by?(@stranger)
    assert @blog.is_commentable_by?(@fan)
    assert @blog.is_commentable_by?(@idol)

    assert_no_difference "Comment.count" do
      @blog.comments.create :poster_id => @user.id, :recipient_id => nil, :content => 'a'
    end

    @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @friend1.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @same_game_user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert @comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @stranger.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert @comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @fan.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert @comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @idol.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert @comment.is_deleteable_by?(@idol)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME

    assert @blog.is_commentable_by?(@user)
    assert @blog.is_commentable_by?(@friend1)
    assert @blog.is_commentable_by?(@same_game_user)
    assert !@blog.is_commentable_by?(@stranger)
    assert @blog.is_commentable_by?(@fan)
    assert @blog.is_commentable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @friend1.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @same_game_user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert @comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @blog.comments.create :poster_id => @fan.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert @comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @idol.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert @comment.is_deleteable_by?(@idol)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND

    assert @blog.is_commentable_by?(@user)
    assert @blog.is_commentable_by?(@friend1)
    assert !@blog.is_commentable_by?(@same_game_user)
    assert !@blog.is_commentable_by?(@stranger)
    assert @blog.is_commentable_by?(@fan)
    assert @blog.is_commentable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @friend1.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @fan.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert @comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @idol.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert @comment.is_deleteable_by?(@idol)

    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER

    assert @blog.is_commentable_by?(@user)
    assert !@blog.is_commentable_by?(@friend1)
    assert !@blog.is_commentable_by?(@same_game_user)
    assert !@blog.is_commentable_by?(@stranger)
    assert !@blog.is_commentable_by?(@fan)
    assert !@blog.is_commentable_by?(@idol)

    @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend1)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)
    assert !@comment.is_deleteable_by?(@fan)
    assert !@comment.is_deleteable_by?(@idol)
  end
  
  test "blogs index / friend blogs / relative blogs" do
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
  
  test "sensitive blogs" do
    @sensitive = "政府"
    
    @blog = BlogFactory.create :title => '和谐', :poster_id => @user.id, :game_id => @game.id
    @user.reload and @friend1.reload
    assert @blog.accepted? # 自动通过了应该
    assert_equal @user.blogs_count, 1

    @blog.update_attributes(:title => @sensitive)
    assert @blog.unverified?

    # 验证通过
    @blog.verify
    @user.reload and @friend1.reload
    assert_equal @user.blogs_count, 1

    # 又让他不通过
    @blog.unverify
    @user.reload and @friend1.reload
    assert_equal @user.blogs_count, 0
 
    # 又让他通过
    @blog.verify
    @user.reload and @friend1.reload
    assert_equal @user.blogs_count, 1
  end 

  test "comment notice" do
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend1.id, @friend2.id]

    assert_difference "Notice.count", 2 do
      @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload and @friend1.reload and @friend2.reload
    assert !@user.recv_notice?(@comment)
    assert @friend1.recv_notice?(@comment)
    assert @friend2.recv_notice?(@comment)

    assert_difference "Notice.count", 2 do
      @comment = @blog.comments.create :poster_id => @friend1.id, :recipient_id => @user.id, :content => 'a'
    end
    @user.reload and @friend1.reload and @friend2.reload
    assert @user.recv_notice?(@comment)
    assert !@friend1.recv_notice?(@comment)
    assert @friend2.recv_notice?(@comment)

    assert_difference "Notice.count", 3 do
      @comment = @blog.comments.create :poster_id => @fan.id, :recipient_id => @friend1.id, :content => 'a'
    end
    @user.reload and @friend1.reload and @friend2.reload
    assert @user.recv_notice?(@comment)
    assert @friend1.recv_notice?(@comment)
    assert @friend2.recv_notice?(@comment)

    assert_difference "Notice.count", 3 do
      @comment = @blog.comments.create :poster_id => @user.id, :recipient_id => @fan.id, :content => 'a'
    end
    @user.reload and @friend1.reload and @friend2.reload and @fan.reload
    assert !@user.recv_notice?(@comment)
    assert @fan.recv_notice?(@comment)
    assert @friend1.recv_notice?(@comment)
    assert @friend2.recv_notice?(@comment)

  end

end
