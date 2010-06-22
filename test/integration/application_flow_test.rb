require 'test_helper'

class ApplicationFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @user_sess = login @user
    @application = ApplicationFactory.create
  end

  test "GET /applications/:id" do
    @user_sess.get "/applications/invalid"
    @user_sess.assert_template 'errors/404'
  
    @user_sess.get "/applications/#{@application.id}"
    @user_sess.assert_template 'user/applications/show'
    assert_equal @user_sess.assigns(:application), @application
  end

end
