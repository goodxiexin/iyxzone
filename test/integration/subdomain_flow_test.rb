require 'test_helper'

class SubdomainFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @user_sess = login @user
    @idol = UserFactory.create_idol
    @idol_sess = login @idol
    Subdomain.create :user_id => @idol.id, :name => 'haitao'
  end

  test "" do
    @user_sess.get "/haitao"
    @user_sess.assert_template 'user/profiles/show'
    assert_equal @user_sess.assigns(:user), @idol

    @idol_sess.get "/haitao"
    @idol_sess.assert_template 'user/profiles/show'
    assert_equal @idol_sess.assigns(:user), @idol
  
    @user_sess.get "/non_exist_subdoamin"
    @user_sess.assert_not_found
  end

end
