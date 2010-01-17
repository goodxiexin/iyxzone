require 'test_helper'

class ParticipationTest < ActiveSupport::TestCase

  fixtures :all

  def setup
    @user = User.find(1)
    @event1 = Event.create({:game_id => 1, :game_area_id => 1 , :game_server_id => 1, :poster_id => 1, :title => 'event title', :start_time => 2.days.from_now.to_s(:db), :end_time => 3.days.from_now.to_s(:db), :privilege => 1, :description => 'event description'})
    @event2 = Event.create({:game_id => 1, :game_area_id => 1 , :game_server_id => 1, :poster_id => 1, :title => 'event title', :start_time => 2.days.from_now.to_s(:db), :end_time => 3.days.from_now.to_s(:db), :privilege => 2, :description => 'event description'})
    reload
  end

  # 测试计数器, app/observer/participation_observer.rb
  test "创建活动后，活动的confirmed计数加1, 用户的计数器加1" do
    assert_equal @event1.confirmed_count, 1
    assert_equal @event2.confirmed_count, 1
    assert_equal @user.events_count, 2
  end

  test "请求参加活动后，活动的计数器加1，活动组织者的请求计数器加1" do
    @event1.participations.create(:participant_id => 2, :status => 1)
    reload
    assert_equal @event1.poster.event_requests_count, 1
    assert_equal @event1.requestors_count, 1

    @event1.participations.create(:participant_id => 3, :status => 2)
    reload
    assert_equal @event1.poster.event_requests_count, 2
    assert_equal @event1.requestors_count, 2
  end

  test "活动请求被活动组织者同意" do
    @p1 = @event1.participations.create(:participant_id => 2, :status => 1)
    @p2 = @event1.participations.create(:participant_id => 3, :status => 2)
    
    # 先同意其中一个请求
    @p1.reload and @p1.accept
    reload
    assert_equal @p1.status, 3
    assert_equal @event1.requestors_count, 1
    assert_equal @event1.poster.event_requests_count, 1
    assert_equal User.find(2).upcoming_events_count, 1

    # 再同意一个
    @p2.reload and @p2.accept
    reload
    assert_equal @p2.status, 4
    assert_equal @event1.requestors_count, 0
    assert_equal @event1.poster.event_requests_count, 0
    assert_equal User.find(2).upcoming_events_count, 1
  end

  test "活动请求被活动组织者拒绝" do
    @p1 = @event1.participations.create(:participant_id => 2, :status => 1)
    @p2 = @event1.participations.create(:participant_id => 3, :status => 2)
    
    # 先拒绝一个请求
    @p1.reload and @p1.destroy # @p1.reload 清空 association_cache
    reload
    assert_equal @event1.requestors_count, 1
    assert_equal @event1.poster.event_requests_count, 1
    assert_equal User.find(2).upcoming_events_count, 0

    # 再拒绝一个请求
    @p2.reload and @p2.destroy
    reload
    assert_equal @event1.requestors_count, 0
    assert_equal @event1.poster.event_requests_count, 0
    assert_equal User.find(2).upcoming_events_count, 0
  end

  test "活动组织者邀请好友" do
    @p1 = @event1.participations.create(:participant_id => 2, :status => 0)
    reload
    assert_equal @event1.invitees_count, 1
    assert_equal @p1.participant.event_invitations_count, 1
  end

  test "活动组织者的邀请被接受" do
    @p1 = @event1.participations.create(:participant_id => 2, :status => 0)
    @p2 = @event1.participations.create(:participant_id => 3, :status => 0)

    # 接受邀请
    @p1.reload and @p1.update_attributes(:status => 3)
    reload
    assert_equal @event1.invitees_count, 1
    assert_equal @event1.confirmed_count, 2
    assert_equal @event1.maybe_count, 0
    assert_equal @event1.declined_count, 0
    assert_equal @p1.participant.event_invitations_count, 0
    assert_equal @p1.participant.upcoming_events_count, 1

    # 接受邀请
    @p2.reload and @p2.update_attributes(:status => 4)
    reload
    assert_equal @event1.invitees_count, 0
    assert_equal @event1.confirmed_count, 2
    assert_equal @event1.maybe_count, 1
    assert_equal @event1.declined_count, 0
    assert_equal @p2.participant.event_invitations_count, 0
    assert_equal @p2.participant.upcoming_events_count, 1
  end

  test "活动组织者的邀请被拒绝" do
    @p1 = @event1.participations.create(:participant_id => 2, :status => 0)

    # 拒绝邀请
    @p1.reload and @p1.update_attributes(:status => 5)
    reload
    assert_equal @event1.invitees_count, 0
    assert_equal @event1.confirmed_count, 1
    assert_equal @event1.maybe_count, 0
    assert_equal @event1.declined_count, 1
    assert_equal @p1.participant.event_invitations_count, 0
    assert_equal @p1.participant.upcoming_events_count, 1 # 尽管是拒绝，但是在我们的设计中还是算到了upcoming_events
  end

  test "活动参与者修改状态" do
    @p = @event1.participations.find_by_participant_id(1)

    # 变成可能去
    @p.update_attributes(:status => 4)
    reload
    assert_equal @event1.confirmed_count, 0
    assert_equal @event1.maybe_count, 1
    assert_equal @event1.declined_count, 0

    # 变成不去
    @p.update_attributes(:status => 5)
    reload
    assert_equal @event1.confirmed_count, 0
    assert_equal @event1.maybe_count, 0
    assert_equal @event1.declined_count, 1
    
    # 变成肯定去
    @p.update_attributes(:status => 3)
    reload
    assert_equal @event1.confirmed_count, 1
    assert_equal @event1.maybe_count, 0
    assert_equal @event1.declined_count, 0
  end

  test "活动邀请由于过期被删除" do
  end

  test "活动请求由于过期被删除" do
  end

  # 测试validate
  test "活动为空" do
    @p = Participation.create(:participant_id => 2, :status => 0)
    assert_equal @p.errors.on_base, '活动不能为空'
  end

  test "活动不存在" do
    @p = Participation.create(:participant_id => 2, :status => 0, :event_id => 123123)
    assert_equal @p.errors.on_base, '活动不存在'
  end

  test "参与者为空" do
    @p = Participation.create(:event_id => @event1.id, :status => 0)
    assert_equal @p.errors.on_base, '参与者不能为空'
  end

  test "状态为空" do
    @p = Participation.create(:event_id => @event1.id, :participant_id => 2)
    assert_equal @p.errors.on_base, '状态不能为空'
  end

  test "状态不对" do
    @p = Participation.create(:event_id => @event1.id, :participant_id => 2, :status => 6)
    assert_equal @p.errors.on_base, '状态不对'
  end

  test "从请求变成邀请" do
    @p = Participation.create(:event_id => @event1.id, :participant_id => 2, :status => 1)
    @p.update_attributes(:status => 0)
    assert_equal @p.errors.on_base, '不能从请求变成邀请' 
  end

  test "从participation变成请求" do
    @p = @event1.participations.find_by_participant_id(1)
    @p.update_attributes(:status => 1)
    assert_equal @p.errors.on_base, '不能从参加变成请求'
  end

  test "从邀请变成请求" do
    @p = Participation.create(:event_id => @event1.id, :participant_id => 2, :status => 0)
    @p.update_attributes(:status => 1)
    assert_equal @p.errors.on_base, '不能从邀请变成请求'
  end

  test "从participation变成邀请" do
    @p = @event1.participations.find_by_participant_id(1)
    @p.update_attributes(:status => 0, :participant_id => 1)
    assert_equal @p.errors.on_base, '不能从参加变成邀请'
  end

  # 测试validate_on_create
  test "邀请不是好友的人" do
    @p1 = @event1.invitations.create(:participant_id => 4)
    @p2 = @event1.invitations.create(:participant_id => 2)
    reload
    assert_equal @p1.errors.on_base, '不能邀请非好友'
    assert_equal User.find(2).event_invitations_count, 1
    assert_equal @event1.invitees_count, 1
  end

  test "请求不能参加的活动，就是活动只对好友开放，但是请求者不是好友" do
    @p = @event2.requests.create(:participant_id => 4)
    assert_equal @p.errors.on_base, '权限不够'
  end

  test "已经发送活动请求的，无法再发送活动请求" do
    @event1.requests.create(:participant_id => 2)
    @p = @event1.requests.create(:participant_id => 2) 
    reload
    assert_equal @p.errors.on_base, '已经发送请求了'
    assert_equal @user.event_requests_count, 1
    assert_equal @event1.requestors_count, 1
  end

  test "已经发送活动请求的，无法被邀请" do
    @event1.requests.create(:participant_id => 2)
    @p = @event1.invitations.create(:participant_id => 2)
    reload
    assert_equal @p.errors.on_base, '已经发送请求了'
    assert_equal @user.event_requests_count, 1
    assert_equal User.find(2).event_invitations_count, 0
    assert_equal @event1.requestors_count, 1
    assert_equal @event1.invitees_count, 0
  end

  test "已经发送活动请求的，无法再创建participation" do
    @event1.requests.create(:participant_id => 2)
    @p = @event1.participations.create(:participant_id => 2, :status => 3)
    reload
    assert_equal @p.errors.on_base, '已经发送请求了'
    assert_equal @user.event_requests_count, 1
    assert_equal User.find(2).upcoming_events_count, 0
    assert_equal @event1.requestors_count, 1
    assert_equal @event1.confirmed_count, 1
  end

  test "已经邀请的，无法再邀请" do
    @event1.invitations.create(:participant_id => 2)
    @p = @event1.invitations.create(:participant_id => 2)
    reload
    assert_equal @p.errors.on_base, '已经被邀请了'
    assert_equal User.find(2).event_invitations_count, 1
    assert_equal @event1.invitees_count, 1
  end

  test "已经被邀请的，无法发送活动请求" do
    @event1.invitations.create(:participant_id => 2)
    @p = @event1.requests.create(:participant_id => 2)
    reload
    assert_equal @p.errors.on_base, '已经被邀请了'
    assert_equal @user.event_requests_count, 0
    assert_equal User.find(2).event_invitations_count, 1
    assert_equal @event1.invitees_count, 1
    assert_equal @event1.requestors_count, 0
  end

  test "已经被邀请的，无法再创建participation" do
    @event1.invitations.create(:participant_id => 2)
    @p = @event1.participations.create(:participant_id => 2, :status => 3)
    reload
    assert_equal @p.errors.on_base, '已经被邀请了'
    assert_equal User.find(2).event_invitations_count, 1
    assert_equal User.find(2).upcoming_events_count, 0
    assert_equal @event1.invitees_count, 1
    assert_equal @event1.confirmed_count, 1
  end

  test "已经参加活动的，无法再发送请求" do
    @p = @event1.requests.create(:participant_id => 1)
    reload
    assert_equal @p.errors.on_base, '已经参加了该活动'
    assert_equal @user.events_count, 2
    assert_equal @user.upcoming_events_count, 0
    assert_equal @event1.requestors_count, 0
  end

  test "已经参加活动的，无法被邀请" do
    @p = @event1.invitations.create(:participant_id => 1)
    reload
    assert_equal @p.errors.on_base, '已经参加了该活动'
    assert_equal @user.events_count, 2
    assert_equal @user.upcoming_events_count, 0
    assert_equal @event1.invitees_count, 0
  end

  test "已经参加活动的，无法再参加" do
    @p = @event1.participations.create(:participant_id => 1, :status => 3)
    reload
    assert_equal @p.errors.on_base, '已经参加了该活动'
    assert_equal @user.events_count, 2
    assert_equal @user.upcoming_events_count, 0
    assert_equal @event1.confirmed_count, 1  
  end

protected

  def reload
    @user.reload
    @event1.reload
    @event2.reload
  end

end
