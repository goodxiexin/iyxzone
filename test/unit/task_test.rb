require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
    @friend = UserFactory.create
    FriendFactory.create @user, @friend
    @character = GameCharacterFactory.create :user_id => @user.id
    @character2 = GameCharacterFactory.create :game_id => @character.game_id, :area_id => @character.area_id, :server_id => @character.server_id, :race_id => @character.race_id, :profession_id => @character.profession_id, :user_id => @friend.id
    @game = @character.game
  end

	test "simple task" do
		t = Task.create(
			:prerequisite	=> {},
			:requirement	=> {},
			:description	=> {:title => "测试任务1", :thumbnail => "default_event_large.png",
												:text => "这是一个很无聊的测试任务", :image => ["default_event_large.png"]},
			:reward				=> {"gold" => 1},
			:starts_at 		=> DateTime.now,
			:expires_at		=> DateTime.now+10,
			:duration			=> 1000,
			:catagory	=> 2
#			:state	=> 1
			)
    assert t.prerequisites.blank?
	end

  test "simple task with only one prerequisite" do 
    t = Task.create(
      :prerequisite => {:blog_more_than => 2},
      :requirement  => {},
      :description  => {:title => "测试任务1", :thumbnail => "default_event_large.png",
                        :text => "这是一个很无聊的测试任务", :image => ["default_event_large.png"]},
      :reward       => {"gold" => 1},
      :starts_at    => DateTime.now,
      :expires_at   => DateTime.now+10,
      :duration     => 1000,
      :catagory => 2
#     :state  => 1
      )

    assert_equal t.prerequisites.count, 1
    p = t.prerequisites.first
    assert p.is_a? BlogMoreThanPrerequisite

    assert !t.is_selectable_by?(@user)

    BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @user.reload
    assert !t.is_selectable_by?(@user)

    BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @user.reload
    assert !t.is_selectable_by?(@user)

    BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @user.reload
    assert t.is_selectable_by?(@user)
  end

  #
  # simple task 1
  # 创建2个博客
  #
  test "simple task 1" do 
    t = Task.create(
      :prerequisite => {},
      :requirement  => {:blog_more_than => 2},
      :description  => {:title => "测试任务1", :thumbnail => "default_event_large.png",
                        :text => "这是一个很无聊的测试任务", :image => ["default_event_large.png"]},
      :reward       => {"gold" => 1},
      :starts_at    => DateTime.now,
      :expires_at   => DateTime.now+10,
      :duration     => 1000,
      :catagory => 2
#     :state  => 1
      )

    assert_equal t.requirements.count, 1
    r = t.requirements.first
    assert r.is_a? BlogMoreThanRequirement

    @user_task = UserTask.create :user_id => @user.id, :task_id => t.id
    assert @user_task
    assert_equal @user_task.achievement[:blogs_count], 0

    BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @user_task.reload
    assert_equal @user_task.achievement[:blogs_count], 1
    assert !@user_task.is_done?

    BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @user_task.reload
    assert_equal @user_task.achievement[:blogs_count], 2
    assert !@user_task.is_done?

    BlogFactory.create :poster_id => @user.id, :game_id => @game.id
    @user_task.reload
    assert_equal @user_task.achievement[:blogs_count], 3
    assert @user_task.is_done?
  end


  #
  # simple task 2
  # 评论10篇别人的不同的资源
  #
  test "simple task 2" do
    t = Task.create(
      :prerequisite => {},
      :requirement  => {:comment_different_blogs => 2},
      :description  => {:title => "测试任务1", :thumbnail => "default_event_large.png",
                        :text => "这是一个很无聊的测试任务", :image => ["default_event_large.png"]},
      :reward       => {"gold" => 1},
      :starts_at    => DateTime.now,
      :expires_at   => DateTime.now+10,
      :duration     => 1000,
      :catagory => 2
#     :state  => 1
      )

    assert_equal t.requirements.count, 1
    r = t.requirements.first
    assert r.is_a? CommentDifferentBlogsRequirement

    @user_task = UserTask.create :user_id => @user.id, :task_id => t.id
    @user_task.reload
    assert @user_task
    assert_equal @user_task.achievement[:comment_blogs], []

    @blog1 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id
    @comment = @blog1.comments.create :poster_id => @user.id, :content => 'comment blog1', :recipient_id => @friend.id
    @user_task.reload
    assert_equal @user_task.achievement[:comment_blogs], [@blog1.id]
    assert !@user_task.is_done?

    @blog2 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id
    @blog2.comments.create :poster_id => @user.id, :content => 'comment blog2', :recipient_id => @friend.id
    @user_task.reload
    assert_equal @user_task.achievement[:comment_blogs], [@blog1.id, @blog2.id]
    assert !@user_task.is_done?

    @blog2.comments.create :poster_id => @user.id, :content => 'comment blog2', :recipient_id => @friend.id
    @user_task.reload
    assert_equal @user_task.achievement[:comment_blogs], [@blog1.id, @blog2.id]
    assert !@user_task.is_done?

    @blog3 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id
    @blog3.comments.create :poster_id => @user.id, :content => 'comment blog3', :recipient_id => @friend.id
    @user_task.reload
    assert_equal @user_task.achievement[:comment_blogs], [@blog1.id, @blog2.id, @blog3.id]
    assert @user_task.is_done?    
  end

  test "prerequisite: some pretasks" do
    pre = Task.create(
      :prerequisite => {},
      :requirement  => {:comment_different_blogs => 2},
      :description  => {:title => "测试任务1", :thumbnail => "default_event_large.png",
                        :text => "这是一个很无聊的测试任务", :image => ["default_event_large.png"]},
      :reward       => {"gold" => 1},
      :starts_at    => DateTime.now,
      :expires_at   => DateTime.now+10,
      :duration     => 1000,
      :catagory => 2
#     :state  => 1
      )
    t = Task.create(
      :prerequisite => {:pretasks => [pre.id]},
      :requirement => {:comment_different_blogs => 10},
      :description  => {:title => "测试任务1", :thumbnail => "default_event_large.png",
                        :text => "这是一个很无聊的测试任务", :image => ["default_event_large.png"]},
      :reward       => {"gold" => 1},
      :starts_at    => DateTime.now,
      :expires_at   => DateTime.now+10,
      :duration     => 1000,
      :catagory => 2
    )

    t.reload
    assert !t.prerequisites.blank?
    assert t.prerequisites.first.is_a?(PretasksPrerequisite)
    assert !t.is_selectable_by?(@user)

    @user_task = UserTask.create :user_id => @user.id, :task_id => pre.id
    @blog1 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id
    @comment = @blog1.comments.create :poster_id => @user.id, :content => 'comment blog1', :recipient_id => @friend.id
    @blog2 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id
    @blog2.comments.create :poster_id => @user.id, :content => 'comment blog2', :recipient_id => @friend.id
    @blog3 = BlogFactory.create :poster_id => @friend.id, :game_id => @game.id
    @blog3.comments.create :poster_id => @user.id, :content => 'comment blog3', :recipient_id => @friend.id

    @user_task.reload
    assert @user_task.is_done?
    @user.reload
    assert t.is_selectable_by?(@user)
  end

end
