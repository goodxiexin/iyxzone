require 'test_helper'

class ViewingTest < ActiveSupport::TestCase
  
  def setup
    @user = UserFactory.create :is_idol => true
    @profile = @user.profile
    @stranger = UserFactory.create
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    @fan = UserFactory.create
    Fanship.create :fan_id => @fan.id, :idol_id => @user.id
    @idol = UserFactory.create :is_idol => true
    Fanship.create :fan_id => @user.id, :idol_id => @idol.id
  end

  test "viewed by someone" do
    @blog = BlogFactory.create

    assert_difference "@blog.reload.viewings_count" do
      @blog.viewed_by @user
    end
    
    assert_difference "@blog.reload.viewings_count" do
      @blog.viewed_by @stranger
    end

    assert_difference "@blog.reload.viewings_count" do
      @blog.viewed_by @friend
    end

    assert_difference "@blog.reload.viewings_count" do
      @blog.viewed_by @idol
    end

    assert_difference "@blog.reload.viewings_count" do
      @blog.viewed_by @fan
    end
   
    # 看过后就无法删除了 
  end

end
