require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase

  def setup
    @application = ApplicationFactory.create  
    @user1 = UserFactory.create
    @user2 = UserFactory.create
  end

  test "comment application" do
    assert @application.is_commentable_by?(@user1)
    assert @application.is_commentable_by?(@user2)
    
    assert_difference "Comment.count" do
      @comment = @application.comments.create :poster_id => @user1.id, :recipient_id => nil, :content => 'a'
    end
    @user1.reload
    assert @comment.is_deleteable_by?(@user1)
    assert !@comment.is_deleteable_by?(@user2)
    assert !@user1.recv_notice?(@comment)

    assert_difference "Comment.count" do
      @comment = @application.comments.create :poster_id => @user2.id, :recipient_id => @user1.id, :content => 'a'
    end
    @user1.reload and @user2.reload
    assert !@comment.is_deleteable_by?(@user1)
    assert @comment.is_deleteable_by?(@user2)
    assert @user1.recv_notice?(@comment)
    assert !@user2.recv_notice?(@comment)
  end

end
