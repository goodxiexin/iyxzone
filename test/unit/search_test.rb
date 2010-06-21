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
		users1 = GameCharacter.search("feng").group_by(&:user_id).select{|user_id, characters| User.activated.exists?(user_id)}.to_a
		assert_equal users1, [[1,[@character1]],[3, [@character3]]]

		users3 = GameCharacter.search("hehe").group_by(&:user_id).select{|user_id, characters| User.activated.exists?(user_id)}.to_a
		assert_equal users3, []

		# 中文搜索
		users2 = GameCharacter.search("风").group_by(&:user_id).select{|user_id, characters| User.activated.exists?(user_id)}.to_a
		assert_equal users2, [[1,[@character1]]]

		users4 = GameCharacter.search("不要").group_by(&:user_id).select{|user_id, characters| User.activated.exists?(user_id)}.to_a
		assert_equal users4, []
	end
end
