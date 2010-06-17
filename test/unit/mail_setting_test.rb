require 'test_helper'

class MailSettingTest < ActiveSupport::TestCase
	def setup
		@user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

		@setting = @user.mail_setting
	end

	test "初始值" do
		assert_equal @setting.request_to_be_friend, 1
		assert_equal @setting.comment_my_status, 0
		assert_equal @setting.tag_me_in_photo, 1
	end

	test "update" do
		@setting.update_attributes({:comment_my_status => 1, :tag_me_in_photo => 0})
		@setting.reload
		assert_equal @setting.request_to_be_friend, 1
		assert_equal @setting.comment_my_status, 1
		assert_equal @setting.tag_me_in_photo, 0

		# not able to enhence the data within the range of 0-1

	end

end

