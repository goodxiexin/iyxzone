require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  
  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    @same_game_user = UserFactory.create
    GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @same_game_user.id
    @stranger = UserFactory.create
    @profile = @user.profile
    @sensitive = '政府'
  end

  #
  # case1
  # create a status and then destroy it
  #
  test "case1" do
    @status1 = Status.create :poster_id => @user.id, :content => 'status'
    @user.reload
    assert_equal @user.statuses_count, 1

    @status2 = Status.create :poster_id => @user.id, :content => '<div>status</div>'
    @user.reload
    assert_equal @user.statuses_count, 2
    assert_equal @status2.content, CGI.escapeHTML('<div>status</div>')
  
    @status2.destroy
    @user.reload
    assert_equal @user.statuses_count, 1
  end

  #
  # case2
  # status feed
  #
  test "case2" do
    @status = Status.create :poster_id => @user.id, :content => 'status'
    assert @friend.recv_feed?(@status)
    assert @profile.recv_feed?(@status) 
  
    @status.destroy
    @friend.reload and @profile.reload
    assert !@friend.recv_feed?(@status)
    assert !@profile.recv_feed?(@status)
  end

  #
  # case3
  # comment status
  #
  test "case3" do
    @status = Status.create :poster_id => @user.id, :content => 'status'
    
    assert @status.is_commentable_by?(@user)
    assert @status.is_commentable_by?(@friend)
    assert !@status.is_commentable_by?(@same_game_user)
    assert !@status.is_commentable_by?(@stranger)
  
    @comment = @status.comments.create :content => 'comment', :recipient_id => @user.id, :poster_id => @user.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert !@comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @status.comments.create :content => 'comment', :recipient_id => @user.id, :poster_id => @friend.id
    assert !@comment.id.nil?
    assert @comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@friend)
    assert !@comment.is_deleteable_by?(@same_game_user)
    assert !@comment.is_deleteable_by?(@stranger)

    @comment = @status.comments.create :content => 'comment', :recipient_id => @user.id, :poster_id => @same_game_user.id
    assert @comment.id.nil?

    @comment = @status.comments.create :content => 'comment', :recipient_id => @user.id, :poster_id => @stranger.id
    assert @comment.id.nil?
  end
  
  #
  # case4
  # friend statuses
  #
  test "case4" do
    @status1 = Status.create :poster_id => @user.id, :content => 'status', :created_at => 1.days.ago 
    @status2 = Status.create :poster_id => @user.id, :content => 'status', :created_at => 2.days.ago
    @status3 = Status.create :poster_id => @user.id, :content => 'status', :created_at => 3.days.ago
  
    assert_equal Status.by(@user.id).nonblocked, [@status1, @status2, @status3]
  end

  #
  # case5
  # sensitive statuses
  #
  test "case5" do
    @status = Status.create :poster_id => @user.id, :content => 'status' 
    assert @status.accepted?

    @status = Status.create :poster_id => @user.id, :content => @sensitive
    assert @status.unverified?
    @status.verify
    @user.reload
    assert_equal @user.statuses_count, 2

    @status = Status.create :poster_id => @user.id, :content => @sensitive
    assert @status.unverified?
    @status.verify
    @user.reload and @friend.reload and @profile.reload
    assert_equal @user.statuses_count, 3
    assert @profile.recv_feed?(@status)
    assert @friend.recv_feed?(@status)
    @status.unverify
    @user.reload and @friend.reload and @profile.reload
    assert_equal @user.statuses_count, 2
    assert !@profile.recv_feed?(@status)
    assert !@friend.recv_feed?(@status)

    @status.destroy
    @user.reload
    assert_equal @user.statuses_count, 2    
  end

end
