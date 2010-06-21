require 'test_helper'

class DigTest < ActiveSupport::TestCase

  # 只用blog来测试
  # 具体什么时候能挖，在具体的diggable类里测试
  # 这里只测试基本的计数器和是否是重复挖
  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
  
    # create 4 friends
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    @user.reload and @friend.reload
  end

  test "counter" do
    assert @blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1

    assert @blog.dug_by(@friend)
    @blog.reload
    assert_equal @blog.digs_count, 2
  end

  test "dig repeatedly" do
    assert @blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1

    assert !@blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1

    assert !@blog.dug_by(@user)
    @blog.reload
    assert_equal @blog.digs_count, 1
  end

end
