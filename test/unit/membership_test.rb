require 'test_helper'

class MembershipTest < ActiveSupport::TestCase

  fixtures :all

  def setup
    @user = User.find(1)
    @guild = Guild.create({:game_id => 1, :name => 'guild name', :description => 'guild description', :president_id => 1})
  end

  # 测试 app/observer/membership_observer.rb
  test "请求加入工会，工会的计数器加1，会长的计数器加1" do
    @m = Membership.create(:user_id => 2, :status => 1, :guild_id => @guild.id)
    reload
    assert_equal @user.guild_requests_count, 1
    assert_equal @guild.requestors_count, 1
  end

  test "加入工会的请求被拒绝" do
    @m1 = Membership.create(:user_id => 2, :status => 1, :guild_id => @guild.id)
    @m2 = Membership.create(:user_id => 3, :status => 2, :guild_id => @guild.id)
    @m1.reload and @m1.destroy
    reload
    assert_equal @user.guild_requests_count, 1
    assert_equal User.find(2).participated_guilds_count, 0
    assert_equal @guild.requestors_count, 1
    @m2.reload and @m2.destroy
    reload
    assert_equal @user.guild_requests_count, 0
    assert_equal User.find(3).participated_guilds_count, 0
    assert_equal @guild.requestors_count, 0
  end

  test "加入工会的请求被接受" do
    @m1 = Membership.create(:user_id => 2, :status => 1, :guild_id => @guild.id)
    @m2 = Membership.create(:user_id => 3, :status => 2, :guild_id => @guild.id) 
    @m1.reload and @m1.accept_request
    reload
    assert_equal @m1.status, 4
    assert_equal @user.guild_requests_count, 1
    assert_equal User.find(2).participated_guilds_count, 1
    assert_equal @guild.requestors_count, 1
    @m2.reload and @m2.accept_request
    reload
    assert_equal @m2.status, 5
    assert_equal @user.guild_requests_count, 0
    assert_equal User.find(3).participated_guilds_count, 1
    assert_equal @guild.requestors_count, 0
  end

  test "会长邀请好友加入" do
    @m = @guild.invitations.create(:user_id => 2)
    reload
    assert_equal User.find(2).guild_invitations_count, 1
    assert_equal @guild.invitees_count, 1
  end

  test "会长的邀请被接受" do
    @m = @guild.invitations.create(:user_id => 2)
    @m.accept_invitation
    reload
    assert_equal @m.status, 5
    assert_equal User.find(2).guild_invitations_count, 0
    assert_equal User.find(2).participated_guilds_count, 1
    assert_equal @guild.invitees_count, 0
    assert_equal @guild.members_count, 1
  end

  test "会长的邀请被拒绝" do
    @m = @guild.invitations.create(:user_id => 2)
    @m.destroy
    reload
    assert_equal User.find(2).guild_invitations_count, 0
    assert_equal User.find(2).participated_guilds_count, 0
    assert_equal @guild.invitees_count, 0
    assert_equal @guild.members_count, 0
  end

  test "会长对手下进行任命" do
    @m = @guild.invitations.create(:user_id => 2)
    @m.accept_invitation
    @m.update_attributes(:status => 4)
    reload
    assert_equal @guild.invitees_count, 0
    assert_equal @guild.members_count, 0
    assert_equal @guild.veterans_count, 1
    @m.update_attributes(:status => 5)
    reload
    assert_equal @guild.members_count, 1
    assert_equal @guild.veterans_count, 0
  end

  # 测试 validate 
  test "工会为空" do
    @m = Membership.create(:user_id => 2, :status => 4)
    assert_equal @m.errors.on_base, "没有工会"
  end

  test "用户为空" do
    @m = Membership.create(:guild_id => @guild.id, :status => 4)
    assert_equal @m.errors.on_base, "用户不能为空"  
  end

  test "状态为空" do
    @m = Membership.create(:guild_id => @guild.id, :user_id => 2)
    assert_equal @m.errors.on_base, "状态不能为空"
  end

  test "状态不对" do
    @m = Membership.create(:guild_id => @guild.id, :user_id => 2, :status => 8)
    assert_equal @m.errors.on_base, "状态不对"
  end

  # 测试 validate_on_update
  test "从请求变成邀请" do
    @m = Membership.create(:user_id => 2, :status => 1, :guild_id => @guild.id)
    @m.update_attributes(:status => 0, :guild_id => @guild.id)
    reload
    assert_equal @guild.requestors_count, 1
    assert_equal @guild.invitees_count, 0
    assert_equal @m.errors.on_base, "不能从请求变成邀请"
  end 

  test "从参加变成邀请" do
    @m = @guild.memberships.find_by_user_id(1)
    @m.update_attributes(:status => 0, :guild_id => @guild.id)
    reload
    assert_equal @guild.requestors_count, 0
    assert_equal @guild.invitees_count, 0
    assert_equal @m.errors.on_base, "不能从参加变成邀请"
  end

  test "从邀请变成请求" do
    @m = @guild.invitations.create(:user_id => 2)
    @m.update_attributes(:status => 1, :guild_id => @guild.id)
    reload
    assert_equal @guild.requestors_count, 0
    assert_equal @guild.invitees_count, 1
    assert_equal @m.errors.on_base, "不能从邀请变成请求"
  end

  test "从参加变成请求" do
    @m = @guild.memberships.find_by_user_id(1)
    @m.update_attributes(:status => 1, :guild_id => @guild.id)
    reload
    assert_equal @guild.requestors_count, 0
    assert_equal @guild.invitees_count, 0
    assert_equal @m.errors.on_base, "不能从参加变成请求"
  end

  # 测试 validate_on_create
  test "邀请不是好友的人" do
    Membership.create(:user_id => 4, :status => 0, :guild_id => @guild.id)
    assert_equal @guild.invitees_count, 0
    assert_equal User.find(4).event_invitations_count, 0
  end

  test "已经发送工会请求的，无法再发送工会请求" do
    @m = Membership.create(:user_id => 2, :status => 1, :guild_id => @guild.id)
    @m = Membership.create(:user_id => 2, :status => 2, :guild_id => @guild.id)
    reload
    assert_equal @user.guild_requests_count, 1
    assert_equal @guild.requestors_count, 1
    assert_equal @m.errors.on_base, "已经发送请求了"
  end

  test "已经发送工会请求的，无法被邀请" do
    @m = Membership.create(:user_id => 2, :status => 1, :guild_id => @guild.id)
    @m = Membership.create(:user_id => 2, :status => 0, :guild_id => @guild.id)
    reload
    assert_equal @user.guild_requests_count, 1
    assert_equal User.find(2).event_invitations_count, 0
    assert_equal @guild.requestors_count, 1
    assert_equal @guild.invitees_count, 0
    assert_equal @m.errors.on_base, "已经发送请求了"
  end

  test "已经发送工会请求的，无法再创建membership" do
    @m = Membership.create(:user_id => 2, :status => 1, :guild_id => @guild.id)
    @m = Membership.create(:user_id => 2, :status => 4, :guild_id => @guild.id)
    reload
    assert_equal @user.guild_requests_count, 1
    assert_equal @guild.requestors_count, 1
    assert_equal @guild.invitees_count, 0
    assert_equal @guild.veterans_count, 0
    assert_equal @m.errors.on_base, "已经发送请求了"
    @m = Membership.create(:user_id => 2, :status => 5, :guild_id => @guild.id)
    reload
    assert_equal @user.guild_requests_count, 1
    assert_equal @guild.requestors_count, 1
    assert_equal @guild.invitees_count, 0
    assert_equal @guild.members_count, 0
    assert_equal @m.errors.on_base, "已经发送请求了"
  end

  test "已经邀请的，无法再邀请" do
    @m = Membership.create(:user_id => 2, :status => 0, :guild_id => @guild.id)
    @m = Membership.create(:user_id => 2, :status => 0, :guild_id => @guild.id)
    reload
    assert_equal User.find(2).guild_invitations_count, 1
    assert_equal @guild.invitees_count, 1
    assert_equal @m.errors.on_base, "已经被邀请了"
  end

  test "已经被邀请的，无法再创建请求" do
    @m = Membership.create(:user_id => 2, :status => 0, :guild_id => @guild.id)
    @m = Membership.create(:user_id => 2, :status => 1, :guild_id => @guild.id)
    reload
    assert_equal @user.guild_requests_count, 0
    assert_equal @guild.requestors_count, 0
    assert_equal @guild.invitees_count, 1
    assert_equal @m.errors.on_base, "已经被邀请了"
  end

  test "已经被邀请的，无法再创建membership" do
    @m = Membership.create(:user_id => 2, :status => 0, :guild_id => @guild.id)
    @m = Membership.create(:user_id => 2, :status => 4, :guild_id => @guild.id)
    reload
    assert_equal User.find(2).guild_invitations_count, 1
    assert_equal @guild.invitees_count, 1
    assert_equal @guild.veterans_count, 0
    assert_equal @m.errors.on_base, "已经被邀请了"
  end

  test "已经参加工会的，无法再发送请求" do
    @m = Membership.create(:user_id => 1, :status => 1, :guild_id => @guild.id)
    reload
    assert_equal @m.errors.on_base, "已经加入了该工会"
    assert_equal @guild.requestors_count, 0
  end

  test "已经参加工会的，无法被邀请" do
    @m = Membership.create(:user_id => 1, :status => 0, :guild_id => @guild.id)
    reload
    assert_equal @m.errors.on_base, "已经加入了该工会"
    assert_equal @guild.invitees_count, 0
  end
 
  test "已经参加工会的，无法再参加" do
    @m = Membership.create(:user_id => 1, :status => 4, :guild_id => @guild.id)
    reload
    assert_equal @m.errors.on_base, "已经加入了该工会"
    assert_equal @guild.veterans_count, 0
  end

protected

  def reload
    @user.reload
    @guild.reload
  end

end
