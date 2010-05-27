require 'test_helper'

class ForumTest < ActiveSupport::TestCase

  def setup
    @guild = GuildFactory.create
    @forum = @guild.forum
    @character = @guild.president_character
    @member = @character.user
    @user = UserFactory.create
    @sensitive = '政府'
  end

  #
  # case1
  # create/destroy normal topics and top topics
  #
  test "case1" do
    @topic1 = @forum.topics.create :poster_id => @member.id, :subject => 'topic', :content => 'topic', :created_at => 1.days.ago
    @forum.reload
    assert_equal @forum.topics_count, 1

    @topic2 = @forum.topics.top.create :poster_id => @member.id, :subject => 'topic', :content => 'topic', :created_at => 2.days.ago
    @forum.reload
    assert_equal @forum.topics_count, 2

    @topic2.destroy
    @forum.reload
    assert_equal @forum.topics_count, 1

    @topic1.destroy
    @forum.reload
    assert_equal @forum.topics_count, 0
  end

  # 
  # case2
  # create topics, check next/prev/top/normal
  test "case2" do
    @topic1 = @forum.topics.create :poster_id => @member.id, :subject => 'topic1', :content => 'topic', :created_at => 1.days.ago
    @topic2 = @forum.topics.create :poster_id => @member.id, :subject => 'topic2', :content => 'topic', :created_at => 2.days.ago
    @topic3 = @forum.topics.create :poster_id => @member.id, :subject => 'topic3', :content => 'topic', :created_at => 3.days.ago
    @topic4 = @forum.topics.top.create :poster_id => @member.id, :subject => 'topic4', :content => 'topic', :created_at => 4.days.ago
    @topic5 = @forum.topics.top.create :poster_id => @member.id, :subject => 'topic5', :content => 'topic', :created_at => 5.days.ago
    @topic6 = @forum.topics.top.create :poster_id => @member.id, :subject => 'topic6', :content => 'topic', :created_at => 6.days.ago
    
    @forum.reload
    assert_equal @forum.topics_count, 6
    assert_equal @forum.topics.normal, [@topic1, @topic2, @topic3]
    assert_equal @forum.topics.top, [@topic4, @topic5, @topic6]

    assert_equal @topic1.next(:top => 0), @topic3
    assert_equal @topic2.next(:top => 0), @topic1
    assert_equal @topic3.next(:top => 0), @topic2
    assert_equal @topic4.next(:top => 1), @topic6
    assert_equal @topic5.next(:top => 1), @topic4
    assert_equal @topic6.next(:top => 1), @topic5

    assert_equal @topic1.prev(:top => 0), @topic2
    assert_equal @topic2.prev(:top => 0), @topic3
    assert_equal @topic3.prev(:top => 0), @topic1
    assert_equal @topic4.prev(:top => 1), @topic5
    assert_equal @topic5.prev(:top => 1), @topic6
    assert_equal @topic6.prev(:top => 1), @topic4
  end
  
  #
  # case3
  # toggle topic
  # 
  test "case3" do
    @topic = @forum.topics.create :poster_id => @member.id, :subject => 'topic1', :content => 'topic', :created_at => 1.days.ago
    @forum.reload
    assert_equal @forum.topics.normal, [@topic]
    assert @forum.topics.top.blank?

    @topic.toggle_top
    @topic.reload
    @forum.reload
    assert_equal @forum.topics.top, [@topic]
    assert @forum.topics.normal.blank?

    @topic.toggle_top
    @forum.reload
    assert_equal @forum.topics.normal, [@topic]
    assert @forum.topics.top.blank?
  end

  #
  # case4
  # simply create/destroy posts of one topic
  #
  test "case4" do
    @topic = @forum.topics.create :poster_id => @member.id, :subject => 'topic1', :content => 'topic'
    
    @post1 = @topic.posts.create :content => 'post1', :poster_id => @member.id, :recipient_id => @member.id
    @topic.reload and @forum.reload
    assert_equal @forum.posts_count, 1
    assert_equal @topic.posts_count, 1
    assert_equal @post1.floor, 1

    @post2 = @topic.posts.create :content => 'post1', :poster_id => @user.id, :recipient_id => @member.id
    @topic.reload and @forum.reload
    assert_equal @forum.posts_count, 2
    assert_equal @topic.posts_count, 2
    assert_equal @post2.floor, 2

    @post2.destroy
    @topic.reload and @forum.reload and @post1.reload
    assert_equal @forum.posts_count, 1
    assert_equal @topic.posts_count, 1
    assert_equal @post1.floor, 1

    @post3 = @topic.posts.create :content => 'post1', :poster_id => @user.id, :recipient_id => @user.id
    @topic.reload and @forum.reload
    assert_equal @forum.posts_count, 2
    assert_equal @topic.posts_count, 2
    assert_equal @post3.floor, 2
  end

  #
  # case5
  # sensitvie topic
  #
  test "case5" do
    @topic1 = @forum.topics.create :poster_id => @member.id, :subject => 'topic1', :content => 'topic'
    @forum.reload
    assert @topic1.accepted?
    assert_equal @forum.topics_count, 1 

    @topic1.unverify
    @forum.reload
    assert @topic1.rejected?
    assert_equal @forum.topics_count, 0

    @topic2 = @forum.topics.create :poster_id => @member.id, :subject => @sensitive, :content => 'topic'
    @forum.reload
    assert @topic2.unverified?
    assert_equal @forum.topics_count, 1 

    @topic2.verify
    @forum.reload
    assert @topic2.accepted?
    assert_equal @forum.topics_count, 1 

    @topic2.unverify
    @forum.reload
    assert @topic2.rejected?
    assert_equal @forum.topics_count, 0

    @topic1.verify
    @forum.reload
    assert @topic1.accepted?
    assert_equal @forum.topics_count, 1
  end

  #
  # case 6
  # sensitive topic and posts
  #
  test "case6" do
    @topic = @forum.topics.create :poster_id => @member.id, :subject => 'topic1', :content => 'topic'
    @forum.reload
    assert @topic.accepted?
    assert_equal @forum.topics_count, 1 

    @post1 = @topic.posts.create :poster_id => @user.id, :recipient_id => @member.id, :content => 'reply'
    @topic.reload and @forum.reload
    assert @post1.accepted?
    assert_equal @forum.posts_count, 1
    assert_equal @topic.posts_count, 1

    @post2 = @topic.posts.create :poster_id => @user.id, :recipient_id => @member.id, :content => @sensitive
    @topic.reload and @forum.reload
    assert @post2.unverified?
    assert_equal @forum.posts_count, 2
    assert_equal @topic.posts_count, 2

    @post2.unverify
    @topic.reload and @forum.reload
    assert @post2.rejected?
    assert_equal @forum.posts_count, 1
    assert_equal @topic.posts_count, 1

    @post1.unverify
    @topic.reload and @forum.reload
    assert @post1.rejected?
    assert_equal @forum.posts_count, 0
    assert_equal @topic.posts_count, 0

    @post2.verify
    @topic.reload and @forum.reload
    assert @post2.accepted?
    assert_equal @forum.posts_count, 1
    assert_equal @topic.posts_count, 1
    
    @topic.unverify
    @topic.reload and @forum.reload and @post1.reload and @post2.reload
    assert @topic.posts_count, 0
    assert @post1.rejected?
    assert @post2.rejected?
    assert @forum.topics_count, 0
    assert @forum.posts_count, 0

    @topic.verify
    @topic.reload and @forum.reload and @post1.reload and @post2.reload
    assert @topic.posts_count, 2
    assert @post1.accepted?
    assert @post2.accepted?
    assert @forum.topics_count, 1
    assert @forum.posts_count, 2
  end

end
