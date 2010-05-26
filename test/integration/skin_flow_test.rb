require 'test_helper'

class SkinFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @user_sess = login @user
    @skin1 = SkinFactory.create :privilege => Skin::PRIVATE, :category => 'Profile'
    sleep 1
    @skin2 = SkinFactory.create :privilege => Skin::PRIVATE, :category => 'Profile'
    sleep 1
    @skin3 = SkinFactory.create :privilege => Skin::PRIVATE, :category => 'Profile'
    sleep 1
    @skin4 = SkinFactory.create :privilege => Skin::PUBLIC, :category => 'Profile'
    @skin1.access_list = [@user.profile.id]
    @skin1.save
  end

  test "update skin" do
    @user_sess.get '/skins'
    @user_sess.assert_template 'user/profiles/skins/index' 
    assert_equal @user_sess.assigns(:skins), [@skin1, @skin4]

    # click on one skin
    @user_sess.get "/skins/#{@skin1.id}"
    @user_sess.assert_template "user/profiles/skins/show"
    assert_equal @user_sess.assigns(:skin), @skin1
    assert_equal @user_sess.assigns(:next), @skin4
    assert_equal @user_sess.assigns(:prev), @skin4
    assert_equal @user_sess.assigns(:profile), @user.profile

    # inaccessible skin
    @user_sess.get "/skins/#{@skin2.id}"
    @user_sess.assert_template "errors/404"

    @skin2.access_list = [@user.profile.id]
    @skin2.save

    @user_sess.get "/skins/#{@skin2.id}"
    @user_sess.assert_template "user/profiles/skins/show"
    assert_equal @user_sess.assigns(:skin), @skin2
    assert_equal @user_sess.assigns(:next), @skin4
    assert_equal @user_sess.assigns(:prev), @skin1
    assert_equal @user_sess.assigns(:profile), @user.profile    
   
    # set a skin
    @user_sess.put "/skins/#{@skin1.id}"
    @user_sess.assert_redirected_to profile_url(@user.profile)
    assert_equal @user.profile.skin_id, @skin1.id

    # set an inaccessible skin
    @user_sess.put "/skins/#{@skin3.id}"
    @user_sess.assert_template 'errors/404'
    assert_equal @user.profile.skin_id, @skin1.id
  end

protected

  def login user
    open_session do |session|
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end 

end
