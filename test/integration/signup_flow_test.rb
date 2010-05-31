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

  test "create account with valid character" do
    get "/signup"
    assert_template "users/new"

    # 正确的参数创建用户
    assert_difference "User.count" do
      post "/users", {:agree_contact => 1, :user => {:login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => @rid, :profession_id => @pid, :area_id => @aid, :server_id => @sid, :game_id => @gid, :name => 'character1', :level => 11}}}}
    end

    assert_equal User.last.characters_count, 1

    # 正确的参数, 但是邮箱已经被注册
    assert_no_difference "User.count" do
      post "/users", {:agree_contact => 1, :user => {:login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => @rid, :profession_id => @pid, :area_id => @aid, :server_id => @sid, :game_id => @gid, :name => 'character1', :level => 11}}}}
    end


    # 错误的游戏角色信息创建用户
    assert_no_difference "User.count" do
      post "/users", {:agree_contact => 1, :user => {:login => 'gaoxh04', :email => 'gaoxh05@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => @rid, :profession_id => @pid, :area_id => @aid, :server_id => nil, :game_id => @gid, :name => 'character1', :level => 11}}}}
    end

    # 没有游戏角色信息创建用户
    assert_no_difference "User.count" do
      post "/users", {:agree_contact => 1, :user => {:login => 'gaoxh04', :email => 'gaoxh06@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}}
    end
  end
  
  test "signup" do
    get "/signup"
    assert_template "users/new"

    # 注册用户
    assert_difference "User.count" do
      post "/users", {:agree_contact => 1, :user => {:login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => @rid, :profession_id => @pid, :area_id => @aid, :server_id => @sid, :game_id => @gid, :name => 'character1', :level => 11}}}}
    end

    user = User.find_by_email('gaoxh04@gmail.com')
    assert !user.active?
    assert_equal user.characters_count, 1

    # 要求重发
    assert_difference "Email.count" do
      post "/resend_activation_mail", {:email => 'gaoxh04@gmail.com'}
    end

    assert_difference "Email.count" do
      post "/resend_activation_mail", {:email => 'gaoxh04@gmail.com'}
    end

    # 尝试登录
    post "/sessions/create", {:email => 'gaoxh04@gmail.com', :password => '111111'}
    assert_redirected_to activation_mail_sent_url(:email => 'gaoxh04@gmail.com')

    # ask for resending
    assert_difference "Email.count" do
      post "/resend_activation_mail", {:email => 'gaoxh04@gmail.com'}
    end
    
    # 用非法的验证码激活
    post "/activate/invalid"
    assert_redirected_to login_url
    assert_not_nil flash[:error]
    user.reload
    assert !user.active?

    # 激活
    post "/activate/#{user.activation_code}"
    assert_redirected_to login_url
    assert_not_nil flash[:notice]
    user.reload
    assert user.active?

    # 最后登录成功
    post "/sessions/create", {:email => 'gaoxh04@gmail.com', :password => '111111'}
    assert_redirected_to home_url
  end

  test "别人发邮件邀请来的" do
    # 发送邀请
    assert_difference "Email.count" do
      SignupInvitation.create :sender_id => @invitor.id, :recipient_email => 'gaoxh04@gmail.com'
    end
      
    invitation = SignupInvitation.last
    
    # 非法的邀请码
    get "/invite?token=invalid"
    assert_template 'errors/404'
  
    # 合法的邀请码查看
    get "/invite?token=#{invitation.token}"
    assert_template 'register/invite'
    assert_equal assigns(:sender), @invitor

    # 用该邀请码注册
    get "/signup", {:invite_token => invitation.token}
    assert_template 'users/new'

    assert_difference "User.count" do
      post "/users", {:invite_token => invitation.token, :user => {:login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => @rid, :profession_id => @pid, :area_id => @aid, :server_id => @sid, :game_id => @gid, :name => 'character1', :level => 11}}}}
    end

    # 还没激活，所以还不是好友
    user = User.last
    @invitor.reload
    assert !user.has_friend?(@invitor)
    assert !@invitor.has_friend?(user)
    assert user.invitee_code, invitation.token
    
    # 激活，自动添加了好友
    post "/activate/#{user.activation_code}"
    assert_redirected_to login_url
    
    user.reload
    @invitor.reload
    assert user.has_friend?(@invitor)
    assert @invitor.has_friend?(user)

    # 如果用非法的邀请码注册，仍然会注册成功但不会有好友
    get "/signup", {:invite_token => 'invalid'}
    assert_template 'users/new'

    assert_difference "User.count" do
      post "/users", {:invite_token => 'invalid', :user => {:login => 'gaoxh04', :email => 'gaoxh05@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => @rid, :profession_id => @pid, :area_id => @aid, :server_id => @sid, :game_id => @gid, :name => 'character1', :level => 11}}}}
    end

    user = User.last

    post "/activate/#{user.activation_code}"
    assert_redirected_to login_url

    user.reload
    assert_equal user.friends_count, 0
    assert_equal user.invitee_code, 'invalid'
  end

  test "别人发万能邀请" do
    # 合法的邀请码查看
    get "/invite?token=#{@invitor.invite_code}"
    assert_template 'register/invite'
    assert_equal assigns(:sender), @invitor

    # 用该邀请码注册
    get "/signup", {:invite_token => @invitor.invite_code}
    assert_template 'users/new'

    assert_difference "User.count" do
      post "/users", {:invite_token => @invitor.invite_code, :user => {:login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => @rid, :profession_id => @pid, :area_id => @aid, :server_id => @sid, :game_id => @gid, :name => 'character1', :level => 11}}}}
    end

    # 还没激活，所以还不是好友
    user = User.last
    @invitor.reload
    assert !user.has_friend?(@invitor)
    assert !@invitor.has_friend?(user)
    assert user.invitee_code, @invitor.invite_code
    
    # 激活，自动添加了好友
    post "/activate/#{user.activation_code}"
    assert_redirected_to login_url
    
    user.reload
    @invitor.reload
    assert user.has_friend?(@invitor)
    assert @invitor.has_friend?(user)
  end

  test "别人发qq邀请" do
    # 合法的邀请码查看
    get "/invite?token=#{@invitor.qq_invite_code}"
    assert_template 'register/invite'
    assert_equal assigns(:sender), @invitor

    # 用该邀请码注册
    get "/signup", {:invite_token => @invitor.qq_invite_code}
    assert_template 'users/new'

    assert_difference "User.count" do
      post "/users", {:invite_token => @invitor.qq_invite_code, :user => {:login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => @rid, :profession_id => @pid, :area_id => @aid, :server_id => @sid, :game_id => @gid, :name => 'character1', :level => 11}}}}
    end

    # 还没激活，所以还不是好友
    user = User.last
    @invitor.reload
    assert !user.has_friend?(@invitor)
    assert !@invitor.has_friend?(user)
    assert user.invitee_code, @invitor.qq_invite_code
    
    # 激活，自动添加了好友
    post "/activate/#{user.activation_code}"
    assert_redirected_to login_url
    
    user.reload
    @invitor.reload
    assert user.has_friend?(@invitor)
    assert @invitor.has_friend?(user)
  end

  test "别人发msn邀请" do
    # 合法的邀请码查看
    get "/invite?token=#{@invitor.msn_invite_code}"
    assert_template 'register/invite'
    assert_equal assigns(:sender), @invitor

    # 用该邀请码注册
    get "/signup", {:invite_token => @invitor.msn_invite_code}
    assert_template 'users/new'

    assert_difference "User.count" do
      post "/users", {:invite_token => @invitor.msn_invite_code, :user => {:login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :gender => 'male', :password => '111111', :password_confirmation => '111111'}, :profile => {:new_characters => {"1" => {:race_id => @rid, :profession_id => @pid, :area_id => @aid, :server_id => @sid, :game_id => @gid, :name => 'character1', :level => 11}}}}
    end

    # 还没激活，所以还不是好友
    user = User.last
    @invitor.reload
    assert !user.has_friend?(@invitor)
    assert !@invitor.has_friend?(user)
    assert user.invitee_code, @invitor.msn_invite_code
    
    # 激活，自动添加了好友
    post "/activate/#{user.activation_code}"
    assert_redirected_to login_url
    
    user.reload
    @invitor.reload
    assert user.has_friend?(@invitor)
    assert @invitor.has_friend?(user)
  end


end
