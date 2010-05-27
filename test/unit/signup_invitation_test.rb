require 'test_helper'

class SignupInvitationTest < ActiveSupport::TestCase
  
  test "发邮件邀请，对方接受并注册" do
    # 发送邀请
    invitor = UserFactory.create
    invitation = SignupInvitation.create :sender_id => invitor.id, :recipient_email => 'gaoxh04@gmail.com'

    # 接受邀请并注册
    user = UserFactory.create :invitee_code => invitation.token
  
    # 激活
    user.activate
    
    # 是否成为了好友？
    user.reload
    assert user.active?
    assert user.has_friend?(invitor)
    assert invitor.has_friend?(user)
  end

end
