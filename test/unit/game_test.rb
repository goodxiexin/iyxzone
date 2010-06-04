require 'test_helper'

class GameTest < ActiveSupport::TestCase

	def setup
		# create a game
		@game = GameFactory.create

		# create a user that have one character in this tame
		@user1 = UserFactory.create
		@character1 = GameCharacterFactory.create :user_id => @user1.id, :game_id => @game.id

		# create a user do not related to that game
		@user2 = UserFactory.create
		@character2 = GameCharacterFactory.create :user_id => @user2.id
	end

	# 确定初始值是正确的
	test "初始值" do
		@game.reload
		assert_equal @game.characters_count, 1
	end

	# 做用户对游戏角色的相关操作，并检查游戏人数计数器的正确性
	test "游戏角色操作" do
		# 新增相关一个游戏角色
		new_character = GameCharacterFactory.create :user_id => @user1.id, :game_id => @game.id
		@game.reload
		assert_equal @game.characters_count, 2

		# 新增一个不相关的游戏角色
		new_character2 = GameCharacterFactory.create :user_id => @user1.id
		@game.reload
		assert_equal @game.characters_count, 2

		# 更改游戏角色的属性, 只有等级和在玩与否是可以修改的
		new_character.level = 56
		@game.reload
		assert_equal @game.characters_count, 2

		new_character.playing = false
		@game.reload
		assert_equal @game.characters_count, 2
		
		# 删除相关游戏角色
		new_character.destroy
		@game.reload
		assert_equal @game.characters_count, 1
		
		# 删除不相关游戏角色
		new_character2.destroy
		@game.reload
		assert_equal @game.characters_count, 1
	end

	test "关注" do
		# 已经玩了游戏的关注此游戏 (是不是应该这样？已经玩了游戏的再关注貌似没有任何意义)
		attention1 = GameAttention.create(:user_id => @user1.id, :game_id => @game.id)
		@game.reload
		assert_equal @game.attentions_count, 1

		# 没有玩这个游戏的关注此游戏
		attention2 = GameAttention.create(:user_id => @user2.id, :game_id => @game.id)
		@game.reload
		assert_equal @game.attentions_count, 2

		# 取消关注
		attention1.destroy
		@game.reload
		assert_equal @game.attentions_count, 1

		attention2.destroy
		@game.reload
		assert_equal @game.attentions_count, 0
	end

	test "打分" do
		# 玩了游戏的给这个游戏打分
		assert @game.is_rateable_by? @user1

		# 没玩游戏的给这个游戏打分
		assert !@game.is_rateable_by?(@user2)

		# 玩了游戏的立刻再次打分
		rating1 = Rating.create(:user_id => @user1.id, :rateable_id => @game.id, :rateable_type => 'Game', :rating => 5)
		assert !@game.is_rateable_by?(@user1)
		
		# 玩了这个游戏的在9天后打分
		rating1.created_at = 9.days.ago
		rating1.save
		assert !@game.is_rateable_by?(@user1)

		# 玩了这个游戏的在10天后打分
		rating1.created_at = 10.days.ago
		rating1.save
		assert @game.is_rateable_by? @user1

	end

	test "标签" do
		# 玩游戏的写标签
		assert @game.is_taggable_by? @user1

		# 不玩这个游戏的写标签
		assert @game.is_taggable_by?(@user2)

		# 立刻再写一次标签
		tag1 = Tag.create(:name => "好玩", :taggable_type => 'Game')
		tagging1 = Tagging.create(:tag_id => tag1.id, :poster_id => @user1.id, :taggable_id => @game.id, :taggable_type => 'Game')
		assert !@game.is_taggable_by?(@user1)

		# 9天后写标签
		tagging1.created_at = 9.days.ago
		tagging1.save
		assert !@game.is_taggable_by?(@user1)

		# 10天后写标签
		tagging1.created_at = 10.days.ago
		tagging1.save
		assert @game.is_taggable_by?(@user1)
	end

	test "留言" do
		# 玩家用户留言
		assert @game.is_commentable_by?(@user1)

		# 非玩家用户留言
		assert @game.is_commentable_by?(@user2)

	end

	test "分享" do
		# 游戏分享的基本测试
    type, id = Share.get_type_and_id "/games/#{@game.id}"

    assert_equal type, 'Game'
    assert_equal id.to_i, @game.id

		# 玩家分享
		assert @game.is_shareable_by? @user1

		# 非玩家分享
		assert @game.is_shareable_by? @user2
		
	end

  # 以下为非用户才能进行的操作
  test "加入服务区" do
		#初始值
		assert_equal @game.areas_count, 1
		assert !@game.no_areas

		# 增加服务区
		area = GameArea.create(:name => 'halo', :game_id => @game.id)
		@game.reload
		assert_equal @game.areas_count, 2

		# 删除服务区
		area.destroy
		@game.reload
		assert_equal @game.areas_count, 1
  end

  test "加入服务器" do
		# 初始值
		assert_equal @game.servers_count, 1
		assert !@game.no_servers

		# 增加服务器(目前不能确保server的area_id的正确性)
		server = GameServer.create(:name => 'jj', :game_id => @game.id, :area_id => @game.areas.first.id)
		@game.reload
		assert_equal @game.servers_count, 2
		
		# 删除服务器
		server.destroy
		@game.reload
		assert_equal @game.servers_count, 1
  end

  test "加入职业" do
		# 初始值
		assert_equal @game.professions_count, 1
		assert !@game.no_professions

		# 增加服务区
		profession = GameProfession.create(:name => 'halo', :game_id => @game.id)
		@game.reload
		assert_equal @game.professions_count, 2

		# 删除服务区
		profession.destroy
		@game.reload
		assert_equal @game.professions_count, 1
  end

  test "加入种族" do
		# 初始值
		assert_equal @game.races_count, 1
		assert !@game.no_races

		# 增加服务区
		race = GameRace.create(:name => 'halo', :game_id => @game.id)
		@game.reload
		assert_equal @game.races_count, 2

		# 删除服务区
		race.destroy
		@game.reload
		assert_equal @game.races_count, 1
  end

end
