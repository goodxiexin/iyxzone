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
	end

	test "评论" do
	end

	test "标签" do
	end

	test "留言" do
	end

  # 以下为非用户才能进行的操作
  test "加入服务区" do
  end

  test "加入服务器" do
  end

  test "加入职业" do
  end

  test "加入种族" do
  end

end
