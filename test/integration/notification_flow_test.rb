require 'test_helper'

class NotificationFlowTest < ActionController::IntegrationTest
	
	def setup
    @user = UserFactory.create
		@user_sess = login @user
    @notification1 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 1)
	end

	test "GET index" do
    assert_no_difference "@user.reload.notifications_count" do
			assert_difference "@user.reload.unread_notifications_count", -1 do
				@user_sess.get "/notifications"
			end
		end
		@user_sess.assert_template "user/notifications/index"
		assert_equal @user_sess.assigns(:notifications), [@notification1]

		sleep 1
    @notification2 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 2)
		@user_sess.get "/notifications"
		assert_equal @user_sess.assigns(:notifications), [@notification2, @notification1]
	end

	test "GET first_five" do
    assert_no_difference "@user.reload.notifications_count" do
			assert_difference "@user.reload.unread_notifications_count", -1 do
				@user_sess.get "/notifications/first_five"
			end
		end
		@user_sess.assert_template "user/notifications/first_five"

    assert_no_difference "@user.reload.notifications_count" do
			assert_no_difference "@user.reload.unread_notifications_count" do
				@user_sess.get "/notifications/first_five"
			end
		end

		sleep 1
    @notification2 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 2)
		sleep 1
    @notification3 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 3)
		sleep 1
    @notification4 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 4)
		sleep 1
    @notification5 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 5)
		sleep 1
    @notification6 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 6)
		sleep 1
    @notification7 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 7)
    assert_no_difference "@user.reload.notifications_count" do
			assert_difference "@user.reload.unread_notifications_count", -5 do
				@user_sess.get "/notifications/first_five"
			end
		end
		assert_equal @user_sess.assigns(:notifications), [@notification7, @notification6, @notification5, @notification4, @notification3]
	end

	test "DELETE destroy" do
    @user_sess.delete "/blogs/invalid"
    @user_sess.assert_not_found

    assert_difference "@user.reload.notifications_count", -1 do
			@user_sess.delete "/notifications/#{@notification1.id}"
		end

	end

	test "DELETE destroy_all" do
    @notification2 = Notification.create(:user_id => @user.id, :data => 'haha', :category => 2)

		@user_sess.delete "/notifications/destroy_all"
		assert_equal @user.notifications_count, 0
		assert_equal @user.unread_notifications_count, 0
	end
end
