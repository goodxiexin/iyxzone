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

    # admin
    @admin = AdminFactory.create
	end

	# 确定初始值是正确的
	test "初始值" do
		@game.reload
		assert_equal @game.characters_count, 1
	end

	test "关注" do
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
    @game.add_tag @user1, '好玩'
		assert !@game.is_taggable_by?(@user1)
    tagging1 = Tagging.last

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

    # 只有admin能删除游戏的评论
    @comment = @game.comments.create :poster_id => @user1.id, :content => 'a'
    assert !@comment.is_deleteable_by?(@user1)
    assert !@comment.is_deleteable_by?(@user2)
    assert @comment.is_deleteable_by?(@admin)
	end

  # 以下为非用户才能进行的操作
  test "加入服务区" do
		#初始值
		assert_equal @game.areas_count, 1
		assert !@game.no_areas

		# 增加服务区
    assert_difference "@game.reload.areas_count" do
		  @area = GameArea.create(:name => 'halo', :game_id => @game.id)
    end

		# 删除服务区
    assert_difference "@game.reload.areas_count", -1 do
		  @area.destroy
    end
  end

  test "加入服务器" do
		# 初始值
		assert_equal @game.servers_count, 1
		assert !@game.no_servers

		# 增加服务器(目前不能确保server的area_id的正确性)
    assert_difference "@game.reload.servers_count" do
		  @server = GameServer.create(:name => 'jj', :game_id => @game.id, :area_id => @game.areas.first.id)
    end
		
		# 删除服务器
    assert_difference "@game.reload.servers_count", -1 do
		  @server.destroy
    end
  end

  test "加入职业" do
		# 初始值
		assert_equal @game.professions_count, 1
		assert !@game.no_professions

		# 增加服务区
    assert_difference "@game.reload.professions_count" do
		  @profession = GameProfession.create(:name => 'halo', :game_id => @game.id)
    end

		# 删除服务区
    assert_difference "@game.reload.professions_count", -1 do
		  @profession.destroy
    end
  end

  test "加入种族" do
		# 初始值
		assert_equal @game.races_count, 1
		assert !@game.no_races

		# 增加服务区
    assert_difference "@game.reload.races_count" do
		  @race = GameRace.create(:name => 'halo', :game_id => @game.id)
    end

		# 删除服务区
    assert_difference "@game.reload.races_count", -1 do
		  @race.destroy
    end
  end

end
