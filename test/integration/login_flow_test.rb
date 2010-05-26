require 'test_helper'

class LoginFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @invitor = UserFactory.create
    @game = GameFactory.create
    @gid = @game.id
    @aid = @game.areas.first.id
    @sid = @game.servers.first.id
    @rid = @game.races.first.id
    @pid = @game.professions.first.id
  end

  test "login" do
    get "/login"
    assert_template "sessions/new"

    # 错误密码登录 
    post "/sessions", {:email => @user.email, :password => "invalid"}
    assert_template "sessions/new"
    assert_not_nil flash[:error]

    # 错误用户名登录
    post "/sessions", {:email => "invalid", :password => @user.password}
    assert_template "sessions/new"
    assert_not_nil flash[:error]

    # 正确用户名密码登录
    post "/sessions", {:email => @user.email, :password => @user.password}
    assert_redirected_to home_url
    assert_equal session[:user_id], @user.id

    # 如果用户还没激活
    @user.activation_code = 'a'
    @user.save
    post "/sessions", {:email => @user.email, :password => @user.password}
    assert_redirected_to activation_mail_sent_url(:email => @user.email)
    assert session[:user_id].nil?
    
    #session[:user_id] = nil
    #get '/home'
    #assert_redirected_to login_url
  end

=begin 
  test "login and remember me" do
    get "/login"
    assert_template "sessions/new"
  
    # 登录并记住我
    post "/sessions", {:email => @user.email, :password => @user.password, :remember_me => 1}
    assert_redirected_to home_url
    assert_equal session[:user_id], @user.id
    assert_equal cookies[:auth_token], @user.remember_code
    assert_equal cookies[:auth_token].expires_at, 2.weeks.from_now
    
    sleep 3  

    # 这个是用来模拟已经结束了本次session
    get "/home", {}
    assert_template 'user/home/show'
    assert_equal cookies[:auth_token].value, @user.remember_code
    assert_equal cookies[:auth_token].expires_at, 2.weeks.from_now # 从当前开始再续2周
    assert_equal session[:user_id], @user.id
  end
=end

  test "logout" do
    post "/sessions", {:email => @user.email, :password => @user.password}
    assert_redirected_to home_url
    #assert !cookies[:auth_token].nil?
    assert !session[:user_id].nil?

    # 登出
    get '/logout'
    assert_redirected_to login_url
    #assert cookies[:auth_token].nil?
    assert session[:user_id].nil?
  end

end
