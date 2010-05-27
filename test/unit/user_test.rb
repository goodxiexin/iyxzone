require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "简单的创建用户" do
    assert_difference "Email.count" do
      create_user :login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    end

    user = User.last
    assert_not_nil user
    assert user.authenticated?('111111')
    assert_not_nil user.invite_code
    assert_not_nil user.qq_invite_code
    assert_not_nil user.msn_invite_code
    assert_not_nil user.remember_code
    assert_not_nil user.activation_code
  end

  test "各类参数创建用户" do
    create_user :login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'

    # 非法的邮箱无法创建
    user = create_user :login => 'gaoxh04', :email => 'gaoxh04', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    assert user.id.nil?
    assert_not_nil user.errors.on(:email)

    # 相同邮箱的无法再创建
    user = create_user :login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    assert user.id.nil?
    assert_not_nil user.errors.on(:email)

    # 非法的用户名无法创建
    user = create_user :login => '', :email => 'gaoxh05@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    assert user.id.nil?
    assert_not_nil user.errors.on(:login)
    user = create_user :login => '1', :email => 'gaoxh05@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    assert user.id.nil?
    assert_not_nil user.errors.on(:login)
    user = create_user :login => '1' * 1000, :email => 'gaoxh05@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    assert user.id.nil?
    assert_not_nil user.errors.on(:login)

    # 没有性别无法创建
    user = create_user :login => '1', :email => 'gaoxh06@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => ''
    assert user.id.nil?
    assert_not_nil user.errors.on(:gender)
    user = create_user :login => '1', :email => 'gaoxh06@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'gmail'
    assert user.id.nil?
    assert_not_nil user.errors.on(:gender)

    # 密码不对不能创建
    user = create_user :login => '1', :email => 'gaoxh07@gmail.com', :password => '', :password_confirmation => '', :gender => 'male'
    assert user.id.nil?
    assert_not_nil user.errors.on(:password)
    user = create_user :login => '1', :email => 'gaoxh07@gmail.com', :password => 'a', :password_confirmation => 'a', :gender => 'male'
    assert user.id.nil?
    assert_not_nil user.errors.on(:password)
    user = create_user :login => '1', :email => 'gaoxh07@gmail.com', :password => 'abcdef', :password_confirmation => '', :gender => 'male'
    assert user.id.nil?
    assert_not_nil user.errors.on(:password_confirmation)
    user = create_user :login => '1', :email => 'gaoxh07@gmail.com', :password => '111111', :password_confirmation => '222222', :gender => 'male'
    assert user.id.nil?
    assert_not_nil user.errors.on(:password)
  end

  test "测试激活码" do
    user = create_user :login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'

    # 激活码生成了
    assert_not_nil user.activation_code
    assert !user.active?

    # 激活
    assert_difference "Email.count" do
      user.activate
    end

    # 激活码没了
    user.reload
    assert_nil user.activation_code
    assert user.active?
  end

  test "别人邀请然后你注册激活" do
    invitor = create_user :login => 'gaoxh', :email => 'gaoxh@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'

    # 万能邀请邀请来的
    user = create_user :login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    user.invitee_code = invitor.invite_code
    user.save
    user.activate
    user.reload and invitor.reload
    assert user.has_friend?(invitor)
    assert invitor.has_friend?(user)

    # qq邀请来的
    user = create_user :login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    user.invitee_code = invitor.invite_code
    user.save
    user.activate
    user.reload and invitor.reload
    assert user.has_friend?(invitor)
    assert invitor.has_friend?(user)

    # msn邀请来的
    user = create_user :login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    user.invitee_code = invitor.invite_code
    user.save
    user.activate
    user.reload and invitor.reload
    assert user.has_friend?(invitor)
    assert invitor.has_friend?(user)
  end

  test "测试忘记密码" do
    user = create_user :login => 'gaoxh04', :email => 'gaoxh04@gmail.com', :password => '111111', :password_confirmation => '111111', :gender => 'male'
    assert_nil user.password_reset_code

    user.activate
    user.reload
    assert_nil user.activation_code
    assert user.active?

    # 忘记密码了？
    assert_difference "Email.count" do
      user.forgot_password
    end

    # 修改密码
    # 如果新密码有问题，不会创建，而且没有邮件
    assert_no_difference "Email.count" do
      user.reset_password '', ''
    end

    user.reload
    assert_not_nil user.password_reset_code
    assert user.authenticated?('111111')

    assert_no_difference "Email.count" do
      user.reset_password 'aa', 'aa'
    end

    user.reload
    assert_not_nil user.password_reset_code
    assert user.authenticated?('111111')

    assert_no_difference "Email.count" do
      user.reset_password 'abcdefg', ''
    end

    user.reload
    assert_not_nil user.password_reset_code
    assert user.authenticated?('111111')

    assert_no_difference "Email.count" do
      user.reset_password 'abcdefg', 'gfedcba'
    end

    user.reload
    assert_not_nil user.password_reset_code
    assert user.authenticated?('111111')
    
    # 最后正确的修改密码
    assert_difference "Email.count" do
      user.reset_password '20041065', '20041065'
    end

    user.reload
    assert_nil user.password_reset_code
    assert user.authenticated?('20041065')
  end

protected

  def create_user opts
    email = opts.delete(:email)
    user = User.new(opts)
    user.email = email
    user.save
    user
  end

end
