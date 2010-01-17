require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  def setup
    @game = Game.find(1)
    @area = GameArea.find(1)
    @server = GameServer.find(1)
    @user = User.find(1)
    @params = {:game_id => @game.id, :game_area_id => @area.id , :game_server_id => @server.id, :poster_id => @user.id, :title => 'event title', :start_time => 2.days.from_now.to_s(:db), :end_time => 3.days.from_now.to_s(:db), :privilege => 1, :description => 'event description'} 
    @event = Event.create(@params)
    @user.reload
    @event.reload
  end

  # 测试 app/observer/event.rb
  test "创建事件会同时创建一个相册" do
    assert_equal @event.confirmed_count, 1
    assert_not_nil @event.album
  end

  test "修改地点, 活动创建者不收到邮件，活动参加者收到" do
    # 创建2个会员
    @event.requests.create(:participant_id => 2, :status => 1).accept
    @event.requests.create(:participant_id => 3, :status => 1).accept
    assert_equal Email.count(:conditions => {:to => @user.email}), 2

    # 更改活动地点
    @event.update_attributes(:game_id => 2, :game_area_id => nil, :game_server_id => 4)
    assert_equal Email.count(:conditions => {:to => @user.email}), 2 #我们不检查邮件的内容，肯定是对的啦
    assert_not_nil Email.find_by_to(User.find(2).email)
    assert_not_nil Email.find_by_to(User.find(3).email)
  end

  test "修改时间" do
    # 创建2个会员
    @event.requests.create(:participant_id => 2, :status => 1).accept
    @event.requests.create(:participant_id => 3, :status => 1).accept
    assert_equal Email.count(:conditions => {:to => @user.email}), 2
    
    # 更改活动时间
    @event.update_attributes(:start_time => 1.days.from_now.to_s(:db))
    assert_equal Email.count(:conditions => {:to => @user.email}), 2 #我们不检查邮件的内容，肯定是对的啦
    assert_not_nil Email.find_by_to(User.find(2).email)
    assert_not_nil Email.find_by_to(User.find(3).email)
  end

  test "修改地点和时间" do
    # 创建2个会员
    @event.requests.create(:participant_id => 2, :status => 1).accept
    @event.requests.create(:participant_id => 3, :status => 1).accept
    assert_equal Email.count(:conditions => {:to => @user.email}), 2

    # 更改活动时间和地点
    @event.update_attributes(:start_time => 1.days.from_now.to_s(:db), :game_id => 2, :game_area_id => nil, :game_server_id => 4)
    assert_equal Email.count(:conditions => {:to => @user.email}), 2 #我们不检查邮件的内容，肯定是对的啦
    assert_not_nil Email.find_by_to(User.find(2).email)
    assert_not_nil Email.find_by_to(User.find(3).email)
  end

  test "取消活动" do
    # 创建2个会员
    @event.participations.create(:participant_id => 2, :status => 3)
    @event.participations.create(:participant_id => 3, :status => 3)
    
    # 取消活动
    @event.destroy
    @user.reload
    assert_equal @user.events_count, 0
    assert_equal User.find(2).upcoming_events_count, 0
    assert_equal User.find(3).upcoming_events_count, 0
    assert_not_nil Email.find_by_to(User.find(2).email)
    assert_not_nil Email.find_by_to(User.find(3).email)
  end

  # 测试validate
  test "没有作者" do
    @event = Event.create(@params.merge({:poster_id => nil}))
    assert_equal @event.errors.on_base, '没有作者'
  end

  test "没有游戏" do
    @event = Event.create(@params.merge({:game_id => nil}))
    assert_equal @event.errors.on_base, '游戏类别不能为空'
  end

  test "没有服务器" do
    @event = Event.create(@params.merge({:game_server_id => nil}))
    assert_equal @event.errors.on_base, '游戏服务器不能为空'
  end

  test "没有服务区" do
    @event = Event.create(@params.merge({:game_area_id => nil}))
    assert_equal @event.errors.on_base, '游戏服务区不能为空'
  end

  test "游戏不存在" do
    @event = Event.create(@params.merge({:game_id => 22}))
    assert_equal @event.errors.on_base, '游戏不存在'
  end

  test "对于没有服务区的游戏，游戏服务区应该为空，但是服务器不能为空，且应该存在" do
    @event = Event.create(@params.merge({:game_id => 2, :game_area_id => 1, :game_server_id => 4}))
    assert_equal @event.errors.on_base, '游戏服务区应该为空'
    @event = Event.create(@params.merge({:game_id => 2, :game_area_id => nil, :game_server_id => nil}))
    assert_equal @event.errors.on_base, '游戏服务器不能为空'
    @event = Event.create(@params.merge({:game_id => 2, :game_area_id => nil, :game_server_id => 1}))
    assert_equal @event.errors.on_base, '游戏服务器不存在或者不属于该游戏'
  end

  test "对于有服务区的游戏，游戏服务区不能为空，服务器不能为空，且应该存在" do
    @event = Event.create(@params.merge({:game_id => 1, :game_area_id => nil, :game_server_id => 2}))
    assert_equal @event.errors.on_base, '游戏服务区不能为空'
    @event = Event.create(@params.merge({:game_id => 1, :game_area_id => 1, :game_server_id => nil}))
    assert_equal @event.errors.on_base, '游戏服务器不能为空'
    @event = Event.create(@params.merge({:game_id => 1, :game_area_id => 1, :game_server_id => 4}))
    assert_equal @event.errors.on_base, '游戏服务器不存在或者不属于该区域'
  end

  test "没有标题" do
    @event = Event.create(@params.merge({:title => nil}))
    assert_equal @event.errors.on_base, '标题不能为空'
  end

  test "没有描述" do
    @event = Event.create(@params.merge({:description => nil}))
    assert_equal @event.errors.on_base, '描述不能为空'
  end

  test "开始时间为空" do
    @event = Event.create(@params.merge({:start_time => nil}))
    assert_equal @event.errors.on_base, '开始时间不能为空'
  end

  test "结束时间为空" do
    @event = Event.create(@params.merge({:end_time => nil}))
    assert_equal @event.errors.on_base, '结束时间不能为空'
  end

  test "结束时间比开始时间早" do
    @event = Event.create(@params.merge({:end_time => 1.days.from_now.to_s(:db)}))
    assert_equal @event.errors.on_base, '结束时间不能比开始时间早'
  end

  test "开始时间比现在早" do
    @event = Event.create(@params.merge({:start_time => 1.days.ago.to_s(:db)}))
    assert_equal @event.errors.on_base, '开始时间不能比现在早'
  end

end
