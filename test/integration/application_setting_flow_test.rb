require 'test_helper'

class ApplicationSettingFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

    # login
    @user_sess = login @user
	end

	test "GET show" do 
		@user_sess.get "/application_setting"
		@user_sess.assert_template "user/application_setting/show"
	end

	test "GET edit" do 
		@user_sess.get "/application_setting/edit?type=0"
		@user_sess.assert_template "user/application_setting/edit"
    assert_equal @user_sess.assigns(:type), 'blog'
    assert_equal @user_sess.assigns(:name), '日志'
		@user_sess.get "/application_setting/edit?type=1"
		@user_sess.assert_template "user/application_setting/edit"
    assert_equal @user_sess.assigns(:type), 'video'
    assert_equal @user_sess.assigns(:name), '视频'
		@user_sess.get "/application_setting/edit?type=2"
		@user_sess.assert_template "user/application_setting/edit"
    assert_equal @user_sess.assigns(:type), 'photo'
    assert_equal @user_sess.assigns(:name), '照片'
		@user_sess.get "/application_setting/edit?type=3"
		@user_sess.assert_template "user/application_setting/edit"
    assert_equal @user_sess.assigns(:type), 'poll'
    assert_equal @user_sess.assigns(:name), '投票'
		@user_sess.get "/application_setting/edit?type=4"
		@user_sess.assert_template "user/application_setting/edit"
    assert_equal @user_sess.assigns(:type), 'event'
    assert_equal @user_sess.assigns(:name), '活动'
		@user_sess.get "/application_setting/edit?type=5"
		@user_sess.assert_template "user/application_setting/edit"
    assert_equal @user_sess.assigns(:type), 'guild'
    assert_equal @user_sess.assigns(:name), '公会'
		@user_sess.get "/application_setting/edit?type=6"
		@user_sess.assert_template "user/application_setting/edit"
    assert_equal @user_sess.assigns(:type), 'sharing'
    assert_equal @user_sess.assigns(:name), '分享'
	end

private

  def login user
    open_session do |session|
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end 

end
