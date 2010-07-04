require 'test_helper'

class SearchTest < ActiveSupport::TestCase

	def setup
		Pinyin.init_db

    @user1 = UserFactory.create :login => "风中", :email => "feng@gmail.com"
    @character1 = GameCharacterFactory.create :user_id => @user1.id, :name => "风中"
	
    @user2 = UserFactory.create :login => "fengzhong"
    @character2 = GameCharacterFactory.create :user_id => @user2.id, :name => "windnap"
	
    @user3 = UserFactory.create :login => "雨人", :email => "yu@gmail.com"
    @character3 = GameCharacterFactory.create :user_id => @user3.id, :name => "fengzhong"
	end

	test "user搜索" do
		# 英文搜索
		users1 = User.search("feng")
		assert_equal @user1.pinyin, "fengzhong"
		assert_equal users1, [@user1, @user2]

		users2 = User.search("hehe")
		assert_equal users2, []

		# 中文搜索
		users3 = User.search("风")
		assert_equal users3, [@user1]

		users4 = User.search("不要")
		assert_equal users4, []

	end

	test "character搜索" do

		# 英文搜索
		characters1 = GameCharacter.search("feng")
		assert_equal characters1, [@character1, @character3]

		characters2 = GameCharacter.match({:game_id => @character1.game_id}).search("feng")
		assert_equal characters2, [@character1]

		characters8 = GameCharacter.match({:game_id => @character1.game_id, :area_id => @character2.area_id}).search("feng")
		assert_equal characters8, []

		characters9 = GameCharacter.match({:area_id => @character1.area_id}).search("feng")
		assert_equal characters9, [@character1]

		characters10 = GameCharacter.match({:server_id => @character1.server_id}).search("feng")
		assert_equal characters10, [@character1]

		characters3 = GameCharacter.match({:game_id => @character1.game_id, :area_id => @character1.area_id, :server_id => @character1.server_id}).search("feng")
		assert_equal characters3, [@character1]

		characters4 = GameCharacter.search("hehe")
		assert_equal characters4, []

		# 中文搜索
		characters5 = GameCharacter.search("风")
		assert_equal characters5, [@character1]

		characters6 = GameCharacter.match({:game_id => @character2.game_id}).search("风")
		assert_equal characters6, []


		characters7 = GameCharacter.search("不要")
		assert_equal characters7, []
	end
end
