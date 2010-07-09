require 'test_helper'

class AttentionTest < ActiveSupport::TestCase

  def setup
    @user1 = UserFactory.create
    @user2 = UserFactory.create
  end

  test "counter" do
    assert @user1.followed_by(@user2)
    assert_equal @user1.reload.attentions_count, 1
    assert @user1.unfollowed_by(@user2)
    assert_equal @user1.reload.attentions_count, 0
  end

  test "follow repeatedly" do
    assert @user1.followed_by(@user2)
    assert_equal @user1.reload.attentions_count, 1
    assert !@user1.followed_by(@user2)
    assert_equal @user1.reload.attentions_count, 1
  end

  test "follow" do
    assert_difference "Attention.count" do
      assert @user1.followed_by(@user2)
    end

    assert @user1.followed_by?(@user2)
    assert !@user2.followed_by?(@user1)

    assert_difference "Attention.count" do
      assert @user2.followed_by(@user1)
    end

    assert @user1.followed_by?(@user2)
    assert @user2.followed_by?(@user1)
  end

end
