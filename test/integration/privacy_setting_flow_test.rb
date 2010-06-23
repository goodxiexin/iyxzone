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

	test "GET edit" do 
		@user_sess.get "/privacy_setting/edit?type=0"
		@user_sess.assert_template "user/privacy_setting/profile_privacy"
		@user_sess.get "/privacy_setting/edit?type=1"
		@user_sess.assert_template "user/privacy_setting/going_privacy"
		@user_sess.get "/privacy_setting/edit?type=2"
		@user_sess.assert_template "user/privacy_setting/outside_privacy"
	end

private

  def login user
    open_session do |session|
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end 

end
