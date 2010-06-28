require 'test_helper'

class MiniBlogTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
  end

  test "create simple mini blog" do
    @mini_blog = MiniBlog.new :poster_id => @user.id, :content => 'content', :category => MiniBlog::Category[0]
    assert @mini_blog.save
    assert_equal @mini_blog.poster, @user
  end

  test "create mini blog with topics" do
    @mini_blog = MiniBlog.new :poster_id => @user.id, :content => '#topic1#', :category => MiniBlog::Category[0]
    assert @mini_blog.save
    assert_equal @mini_blog.poster, @user
    @topic = MiniTopic.find_by_name('topic1')
    assert_not_nil @topic
    assert_equal @mini_blog.mini_topics, [@topic] 
  end

  test "create mini blog with multiple topics" do
    @mini_blog = MiniBlog.new :poster_id => @user.id, :content => '##topic1#####topic2###topic3##topic4', :category => MiniBlog::Category[0]
    assert @mini_blog.save
    assert_equal @mini_blog.poster, @user
    @topic1 = MiniTopic.find_by_name('topic1')
    @topic2 = MiniTopic.find_by_name('topic2')
    @topic3 = MiniTopic.find_by_name('topic3')
    @topic4 = MiniTopic.find_by_name('topic4')
    assert_not_nil @topic1
    assert_not_nil @topic2
    assert_not_nil @topic3
    assert_nil @topic4    
    assert_equal @mini_blog.mini_topics, [@topic1, @topic2, @topic3]
  end

  test "create picture mini blog" do
    @mini_blog = MiniBlog.new :poster_id => @user.id, :content => '#好图#', :category => MiniBlog::Category[1]
    assert @mini_blog.save
    @mini_blog_image = PhotoFactory.create :mini_blog_id => @mini_blog.id, :type => 'MiniBlogImage'
    assert @mini_blog.reload.image, @mini_blog_image
  end

  test "create video mini blog" do
  end

  test "create mini blog containing some normal links" do
  end

  test "comment mini blog" do
  end

  test "forward mini blog" do
    @user1 = UserFactory.create
    @user2 = UserFactory.create
    @user3 = UserFactory.create
    @user4 = UserFactory.create

    @mini_blog = MiniBlog.create :poster_id => @user.id, :content => '#好图#', :category => MiniBlog::Category[0]
    @mini_blog1 = @mini_blog.forward @user1, "forward user's mini blog"
    assert_equal @mini_blog1.forwarders, []
    assert_equal @mini_blog1.initiator, @user
    assert_equal @mini_blog1.poster, @user1
    @mini_blog2 = @mini_blog1.forward @user2, "forward user1's mini blog"
    assert_equal @mini_blog2.forwarders, [@user1]
    assert_equal @mini_blog2.initiator, @user
    assert_equal @mini_blog2.poster, @user2
    @mini_blog3 = @mini_blog2.forward @user3, "forward user2's mini blog"
    assert_equal @mini_blog3.forwarders, [@user1, @user2]
    assert_equal @mini_blog3.initiator, @user
    assert_equal @mini_blog3.poster, @user3
    @mini_blog4 = @mini_blog3.forward @user4, "forward user3's mini blog"
    assert_equal @mini_blog4.forwarders, [@user1, @user2, @user3]
    assert_equal @mini_blog4.initiator, @user
    assert_equal @mini_blog4.poster, @user4
  end

end
