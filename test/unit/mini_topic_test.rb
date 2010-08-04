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

end
