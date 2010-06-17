require 'test_helper'

class SearchTest < ActiveSupport::TestCase

	def setup
    @user1 = UserFactory.create :login => "风中", :email => "feng@gmail.com"
    @character1 = GameCharacterFactory.create :user_id => @user1.id, :name => "风中"
	
    @user2 = UserFactory.create :login => "fengzhong"
    @character2 = GameCharacterFactory.create :user_id => @user2.id, :name => "windnap"
	
    @user3 = UserFactory.create :login => "雨人", :email => "yu@gmail.com"
    @character3 = GameCharacterFactory.create :user_id => @user3.id, :name => "fengzhong"
	end

	test "user英文搜索" do
		users1 = User.search("feng")
		assert_equal @user1.pinyin, "fengzhong"
		assert_equal users1, [@user1, @user2]

		users2 = User.search("hehe")
		assert_equal users2, []
	end

	test "user中文搜索" do
		users1 = User.search("风")
		assert_equal users1, [@user1]

		users2 = User.search("不要")
		assert_equal users2, []
	end

end
