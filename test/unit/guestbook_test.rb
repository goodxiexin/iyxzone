require 'test_helper'

class GuestbookTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
  end
  
  test "create guestbook" do
    assert_difference "Guestbook.count" do
      Guestbook.create :user_id => @user.id, :priority => Guestbook::Urgent, :description => 'guestbook', :catagory => '日志'
    end

    assert_no_difference "Guestbook.count" do
      Guestbook.create :user_id => 'invalid', :priority => Guestbook::Urgent, :description => 'guestbook', :catagory => '日志'
    end

    assert_difference "Guestbook.count" do
      Guestbook.create :email => 'gaoxh04@gmail.com', :priority => Guestbook::Justsoso, :description => 'guestbook', :catagory => '日志'
    end
  end

  test "admin reply guestbook" do
    @guestbook = Guestbook.create :user_id => @user.id, :priority => Guestbook::Urgent, :description => 'guestbook', :catagory => '日志'
    assert_difference "Email.count" do
      @guestbook.set_reply 'haha'
    end
  end

end
