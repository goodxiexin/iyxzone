require 'test_helper'

class PrivacySettingFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

    # login
    @user_sess = login @user
	end

	test "GET show" do 
		@user_sess.get "/privacy_setting"
		@user_sess.assert_template "user/privacy_setting/show"
	end

	test "GET edit & PUT update" do
		@setting = @user.privacy_setting
		
		@user_sess.get "/privacy_setting/edit", {:type => 0}
		@user_sess.assert_template "user/privacy_setting/profile_privacy"
		@user_sess.put "/privacy_setting", {:type => 0, :setting => {:profile => 3}}
		assert_equal @setting.reload.profile, 3
		
		@user_sess.get "/privacy_setting/edit", {:type => 1}
		@user_sess.assert_template "user/privacy_setting/going_privacy"
		@user_sess.put "/privacy_setting", {:type => 1, :setting => {"send_mail"=>"1", "poke"=>"1", "add_me_as_friend"=>"1", "leave_wall_message"=>"1"}}
		assert_equal @user.reload.privacy_setting.leave_wall_message, 1

		@user_sess.get "/privacy_setting/edit", {:type => 2}
		@user_sess.assert_template "user/privacy_setting/outside_privacy"
		@user_sess.put "/privacy_setting", {:type => 2, :setting => {:search => 0}}
		@user.reload
		assert_equal @user.reload.privacy_setting.search, 0

	end
  
end
