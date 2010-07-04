require 'test_helper'

class MiniTopicTest < ActiveSupport::TestCase

  def setup
    @me = UserFactory.create
  end

  test 'uniqueness' do
    assert_no_difference "MiniTopic.count" do
      MiniTopic.create :name => nil
    end

    assert_difference "MiniTopic.count" do
      MiniTopic.create :name => 'topic'
    end

    assert_no_difference "MiniTopic.count" do
      MiniTopic.create :name => 'topic'
    end
  end

  test "reference count" do
    @blog1 = MiniBlogFactory.create :poster => @me, :content => '#topic#'
    @topic = MiniTopic.last
    assert_equal @topic.reference_count, 1
 
    @blog2 = MiniBlogFactory.create :poster => @me, :content => '#topic#haha#topic#'
    assert_equal @topic.reload.reference_count, 3

    @blog1.destroy
    assert_equal @topic.reload.reference_count, 2

    @blog2.destroy
    assert_equal @topic.reload.reference_count, 0
  end

end
