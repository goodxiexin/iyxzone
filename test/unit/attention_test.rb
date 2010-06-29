require 'test_helper'

class AttentionTest < ActiveSupport::TestCase

  def setup
    @user1 = UserFactory.create
    @user2 = UserFactory.create
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

    assert_no_difference "Attention.count" do
      assert !@user1.followed_by(@user2)
    end
  
    assert_no_difference "Attention.count" do
      assert !@user2.followed_by(@user1)
    end
  end

end
