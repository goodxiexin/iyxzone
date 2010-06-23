require 'test_helper'

class ApplicationSettingTest < ActiveSupport::TestCase
	def setup
		@user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

		@setting = @user.application_setting
	end

	test "初始值" do
		assert_equal @setting.emit_blog_feed, 1
		assert_equal @setting.recv_blog_feed, 1
		assert_equal @setting.emit_poll_feed, 1
	end

	test "update" do
		@setting.update_attributes({:recv_blog_feed => 0, :emit_poll_feed => 0})
		@setting.reload
		assert_equal @setting.emit_blog_feed, 1
		assert_equal @setting.recv_blog_feed, 0
		assert_equal @setting.emit_poll_feed, 0

		# not able to enhence the data within the range of 0-1

	end

end

