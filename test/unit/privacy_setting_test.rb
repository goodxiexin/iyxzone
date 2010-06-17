require 'test_helper'

class PrivacySettingTest < ActiveSupport::TestCase
	def setup
		@user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

		@setting = @user.privacy_setting
	end

	test "初始值" do
		assert_equal @setting.profile, 2
		assert_equal @setting.email, 3
		assert_equal @setting.poke, 1
	end

	test "update" do
		@setting.update_attributes({:profile => 3, :email => 2, :poke => 3})
		@setting.reload
		assert_equal @setting.profile, 3
		assert_equal @setting.email, 2
		assert_equal @setting.poke, 3

		# not able to enhence the data within the range of 1-3
		#assert @setting.update_attributes({:profile => 4})
		#@setting.reload
		#assert_equal @setting.profile, 3
	end

end
