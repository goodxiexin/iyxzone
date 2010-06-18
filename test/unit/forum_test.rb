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

  test "create/destroy normal topics and top topics" do
    @topic1 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :created_at => 1.days.ago
    @forum.reload
    assert_equal @forum.topics_count, 1

    @topic2 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :created_at => 2.days.ago
    @forum.reload
    assert_equal @forum.topics_count, 2

    @topic2.destroy
    @forum.reload
    assert_equal @forum.topics_count, 1

    @topic1.destroy
    @forum.reload
    assert_equal @forum.topics_count, 0
  end

  test "next/prev/top/normalcase2" do
    @topic1 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :created_at => 1.days.ago
    @topic2 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :created_at => 2.days.ago
    @topic3 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :created_at => 3.days.ago
    @topic4 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :created_at => 4.days.ago, :top => true
    @topic5 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :created_at => 5.days.ago, :top => true
    @topic6 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :created_at => 6.days.ago, :top => true
    
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
  
  test "toggle topic" do
    @topic = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :created_at => 1.days.ago
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

  test "create/destroy posts" do
    @topic = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id
    
    @post1 = PostFactory.create :poster_id => @member.id, :recipient_id => @member.id, :topic_id => @topic.id
    @topic.reload and @forum.reload
    assert_equal @forum.posts_count, 1
    assert_equal @topic.posts_count, 1
    assert_equal @post1.floor, 1

    @post2 = PostFactory.create :poster_id => @user.id, :recipient_id => @member.id, :topic_id => @topic.id
    @topic.reload and @forum.reload
    assert_equal @forum.posts_count, 2
    assert_equal @topic.posts_count, 2
    assert_equal @post2.floor, 2

    @post2.destroy
    @topic.reload and @forum.reload and @post1.reload
    assert_equal @forum.posts_count, 1
    assert_equal @topic.posts_count, 1
    assert_equal @post1.floor, 1

    @post3 = PostFactory.create :poster_id => @user.id, :recipient_id => @user.id, :topic_id => @topic.id
    @topic.reload and @forum.reload
    assert_equal @forum.posts_count, 2
    assert_equal @topic.posts_count, 2
    assert_equal @post3.floor, 2
  end

  test "sensitive topic" do
    @topic1 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id
    @forum.reload
    assert @topic1.accepted?
    assert_equal @forum.topics_count, 1 

    @topic1.unverify
    @forum.reload
    assert @topic1.rejected?
    assert_equal @forum.topics_count, 0

    @topic2 = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id, :subject => @sensitive
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

  test "sensitive topic and posts" do
    @topic = TopicFactory.create :poster_id => @member.id, :forum_id => @forum.id
    @forum.reload
    assert @topic.accepted?
    assert_equal @forum.topics_count, 1 

    @post1 = PostFactory.create :topic_id => @topic.id, :poster_id => @user.id, :recipient_id => @member.id
    @topic.reload and @forum.reload
    assert @post1.accepted?
    assert_equal @forum.posts_count, 1
    assert_equal @topic.posts_count, 1

    @post2 = PostFactory.create :topic_id => @topic.id, :poster_id => @user.id, :recipient_id => @member.id, :content => @sensitive
    @topic.reload and @forum.reload
    assert @post2.unverified?
    assert_equal @forum.posts_count, 2
    assert_equal @topic.posts_count, 2

    @post3 = PostFactory.create :topic_id => @topic.id, :poster_id => @user.id, :recipient_id => @member.id, :content => @sensitive
    @topic.reload and @forum.reload
    assert @post3.unverified?
    assert_equal @forum.posts_count, 3
    assert_equal @topic.posts_count, 3

    @post3.unverify
    @topic.reload and @forum.reload
    assert @post3.rejected?
    assert_equal @forum.posts_count, 2
    assert_equal @topic.posts_count, 2
    
    @post3.destroy
    @topic.reload and @forum.reload
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

    @topic.unverify
    @topic.destroy
    @forum.reload
    assert @forum.topics_count, 0
    assert @forum.posts_count, 0   
  end

end
