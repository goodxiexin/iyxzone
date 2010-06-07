require 'test_helper'

class SubdomainTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
    @user2 = UserFactory.create
  end

  test "create subdomain" do
    assert_difference "Subdomain.count" do
      Subdomain.create :user_id => @user.id, :name => 'haha'
    end

    assert_no_difference "Subdomain.count" do
      Subdomain.create :user_id => @user.id, :name => 'heihei'
    end

    assert_no_difference "Subdomain.count" do
      Subdomain.create :user_id => @user2.id, :name => 'haha'
    end
  end

end
