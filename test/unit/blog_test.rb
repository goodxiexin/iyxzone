require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
  end

  test "blog counter" do
    # create blog with different privileges
    @blog = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id, 
      :game_id => @game.id,
      :draft => 0,
      :privilege => PrivilegedResource::PUBLIC)
    @user.reload
    assert_equal @user.blogs_count1, 1

    @blog = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id, 
      :game_id => @game.id,
      :draft => 0,
      :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME)
    @user.reload 
    assert_equal @user.blogs_count2, 1

    @blog = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id, 
      :game_id => @game.id,
      :draft => 0,
      :privilege => PrivilegedResource::FRIEND)
    @user.reload
    assert_equal @user.blogs_count3, 1

    @blog = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id, 
      :game_id => @game.id,
      :draft => 0,
      :privilege => PrivilegedResource::OWNER)
    @user.reload
    assert_equal @user.blogs_count4, 1

    @draft = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id,
      :game_id => @game.id,
      :draft => 1,
      :privilege => PrivilegedResource::PUBLIC)
    @user.reload
    assert_equal @user.blogs_count1, 1 # 没有变化
    assert_equal @user.drafts_count, 1
    @draft.update_attributes(:draft => 0)
    @user.reload
    assert_equal @user.blogs_count1, 2
    assert_equal @user.drafts_count, 0

    @draft = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id,
      :game_id => @game.id,
      :draft => 1,
      :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME)
    @user.reload
    assert_equal @user.blogs_count2, 1 # 没有变化
    assert_equal @user.drafts_count, 1
    @draft.update_attributes(:draft => 0)
    @user.reload
    assert_equal @user.blogs_count2, 2
    assert_equal @user.drafts_count, 0

    @draft = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id,
      :game_id => @game.id,
      :draft => 1,
      :privilege => PrivilegedResource::FRIEND)
    @user.reload
    assert_equal @user.blogs_count3, 1 # 没有变化
    assert_equal @user.drafts_count, 1
    @draft.update_attributes(:draft => 0)
    @user.reload
    assert_equal @user.blogs_count3, 2
    assert_equal @user.drafts_count, 0

    @draft = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id,
      :game_id => @game.id,
      :draft => 1,
      :privilege => PrivilegedResource::OWNER)
    @user.reload
    assert_equal @user.blogs_count4, 1 # 没有变化
    assert_equal @user.drafts_count, 1
    @draft.update_attributes(:draft => 0)
    @user.reload
    assert_equal @user.blogs_count4, 2
    assert_equal @user.drafts_count, 0
  end

  test "decrement counter" do 
    @b1 = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id,
      :game_id => @game.id,
      :draft => 0,
      :privilege => PrivilegedResource::PUBLIC)
    @b2 = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id,
      :game_id => @game.id,
      :draft => 0,
      :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME)
    @b3 = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id,
      :game_id => @game.id,
      :draft => 0,
      :privilege => PrivilegedResource::FRIEND)
    @b4 = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id,
      :game_id => @game.id,
      :draft => 0,
      :privilege => PrivilegedResource::OWNER)
    @draft = Blog.create(
      :title => 'title',
      :content => 'content',
      :poster_id => @user.id,
      :game_id => @game.id,
      :draft => 1,
      :privilege => PrivilegedResource::FRIEND)

    @user.reload
    assert_equal @user.blogs_count1, 1
    assert_equal @user.blogs_count2, 1
    assert_equal @user.blogs_count3, 1
    assert_equal @user.blogs_count4, 1
    assert_equal @user.drafts_count, 1

    @b1.destroy
    @user.reload
    assert_equal @user.blogs_count1, 0
    @b2.destroy
    @user.reload
    assert_equal @user.blogs_count2, 0
    @b3.destroy
    @user.reload
    assert_equal @user.blogs_count3, 0
    @b4.destroy
    @user.reload
    assert_equal @user.blogs_count4, 0
    @draft.destroy
    @user.reload
    assert_equal @user.drafts_count, 0

  end

end
