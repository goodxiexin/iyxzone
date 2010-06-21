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
    @user_sess.assert_template 'errors/404'
  end

protected

  def login user
    open_session do |session|
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end 

end
