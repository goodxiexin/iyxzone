require 'test_helper'

class LoginFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @game = GameFactory.create
  end

  test "login" do
    get "/login"
    assert_template "sessions/new"

    post "/sessions", {:email => @user.email, :password => "#{@user.password}invalid"}
    assert_template "sessions/new"

    post "/sessions", {:email => "invalid#{@user.email}", :password => @user.password}
    assert_template "sessions/new"

    post "/sessions", {:email => @user.email, :password => @user.password}
    assert_redirected_to home_url
  end
  
  test "signup" do
    get "/signup"
    assert_template "users/new"

    # first create an account
    gid = @game.id
    aid = @game.areas.first.id
    sid = @game.servers.first.id
    rid = @game.races.first.id
    pid = @game.professions.first.id

    assert_difference "User.count" do
      post "/users", {:agree_contact => 1, :user => {:login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => rid, :profession_id => pid, :area_id => aid, :server_id => sid, :game_id => gid, :name => 'character1', :level => 11}}}}
    end

    user = User.find_by_email('gaoxh04@gmail.com')
    assert !user.active?

    # ask for resending activation email, repeatedly
    assert_difference "Email.count" do
      post "/resend_activation_mail", {:email => 'gaoxh04@gmail.com'}
    end

    assert_difference "Email.count" do
      post "/resend_activation_mail", {:email => 'gaoxh04@gmail.com'}
    end

    # try to login
    post "/sessions/create", {:email => 'gaoxh04@gmail.com', :password => '111111'}
    assert_redirected_to activation_mail_sent_url(:email => 'gaoxh04@gmail.com', :show => 1)

    # ask for resending
    assert_difference "Email.count" do
      post "/resend_activation_mail", {:email => 'gaoxh04@gmail.com'}
    end

    # activate with invalid code
    post "/activate", {:activation_code => "invalid#{user.activation_code}"}
    assert_redirected_to login_url
    #assert_not_nil flash[:error]
    user.reload
    assert !user.active?

    post "/activate", {:activation_code => user.activation_code}
    assert_redirected_to login_url
    assert_not_nil flash[:notice]
    user.reload
    assert user.active?

    # then login
    post "/sessions/create", {:email => 'gaoxh04@gmail.com', :password => '111111'}
    assert_redirected_to home_url
  end

end
