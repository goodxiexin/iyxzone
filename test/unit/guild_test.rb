require 'test_helper'

class GuildTest < ActiveSupport::TestCase

  fixtures :all

  def setup
    @game = Game.find(1)
    @user = User.find(1)
    @params = {:game_id => @game.id, :name => 'guild name', :description => 'guild description', :president_id => @user.id}
  end

  # 测试app/observer/guild_observer.rb
  test "创建工会，同时创建一个相册和一个论坛，用户的计数器加1" do
    @guild = Guild.create(@params)
    @user.reload
    assert_not_nil @guild.album
    assert_not_nil @guild.forum
    assert_equal @user.guilds_count, 1
  end

  test "改名字，通知除了会长的所有会员" do
    @guild = Guild.create(@params)
    @guild.memberships.create(:user_id => 2, :status => 1).accept_request
    @guild.memberships.create(:user_id => 3, :status => 2).accept_request
    assert_equal Email.count(:conditions => {:to => @user.email}), 2
    @guild.update_attributes(:name => '123123123')
    assert_equal Email.count(:conditions => {:to => @user.email}), 2
    assert_not_nil Email.find_by_to(User.find(2).email)
    assert_not_nil Email.find_by_to(User.find(3).email)
  end

  test "删除工会" do
  end

  # 测试validate
  test "没有名字" do
    @guild = Guild.create(@params.merge({:name => nil}))
    assert_equal @guild.errors.on_base, "名字不能为空"
  end

  test "没有游戏" do
    @guild = Guild.create(@params.merge({:game_id => nil}))
    assert_equal @guild.errors.on_base, "游戏类别不能为空"
  end

  test "没有描述" do
    @guild = Guild.create(@params.merge({:description => nil}))
    assert_equal @guild.errors.on_base, "描述不能为空"
  end

  test "游戏不存在" do
    @guild = Guild.create(@params.merge({:game_id => 3}))
    assert_equal @guild.errors.on_base, "游戏不存在"
  end

end
