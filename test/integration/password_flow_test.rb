require 'test_helper'

class PasswordFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @user2 = UserFactory.create
    @user2.activation_code = 'a'
    @user2.save 
  end

  test "忘记密码" do
    get '/forgot_password'
    assert_template 'passwords/new'

    # 如果是非法的邮件
    post '/passwords/create', {:email => 'invalid@gmail.com'}
    assert_template 'passwords/new'
    assert_not_nil flash[:error]

    # 如果用户是没有激活的
    post '/passwords/create', {:email => @user2.email}
    assert_redirected_to activation_mail_sent_url(:email => @user2.email)

    # 如果用户是合法的
    assert_difference "Email.count" do
      post '/passwords/create', {:email => @user.email}
    end
    assert_redirected_to login_url
    assert_not_nil flash[:notice]
    @user.reload

    # 点击邮件链接来试图重置密码
    # 如果激活码是非法的
    get "/reset_password/invalid"
    assert_template 'errors/404'

    # 合法的激活码
    get "/reset_password/#{@user.password_reset_code}"
    assert_template 'passwords/edit'

    # 更新密码
    # 如果更新码是非法的
    assert_no_difference "Email.count" do
      put "/passwords/update", {:password => '20041065', :password_confirmation => '20041065', :password_reset_code => 'invalid'}
    end

    @user.reload
    assert_template 'passwords/edit'
    assert !@user.authenticated?('20041065')

    # 用合法更新码, 但是密码非法
    assert_no_difference "Email.count" do
      put "/passwords/update", {:password => '', :password_confirmation => '', :password_reset_code => @user.password_reset_code}
    end
     
    @user.reload
    assert_template 'passwords/edit'
    assert !@user.authenticated?('')

    # 用合法更新码, 但是没有确认密码
    assert_no_difference "Email.count" do
      put "/passwords/update", {:password => 'nishi2b', :password_confirmation => '', :password_reset_code => @user.password_reset_code}
    end
     
    @user.reload
    assert_template 'passwords/edit'
    assert !@user.authenticated?('nishi2b')

    
    # 用合法更新码, 但是密码2此不一致
    assert_no_difference "Email.count" do
      put "/passwords/update", {:password => 'nishi2b', :password_confirmation => 'nicaishi2b', :password_reset_code => @user.password_reset_code}
    end
     
    @user.reload
    assert_template 'passwords/edit'
    assert !@user.authenticated?('nishi2b')

    # 正确的重置了密码
    assert_difference "Email.count" do
      put "/passwords/update", {:password => '20041065', :password_confirmation => '20041065', :password_reset_code => @user.password_reset_code}
    end

    @user.reload
    assert_redirected_to login_url
    assert @user.authenticated?('20041065')
  end

end
