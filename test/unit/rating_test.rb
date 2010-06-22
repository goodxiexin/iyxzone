require 'test_helper'

class RatingTest < ActiveSupport::TestCase
	def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
		
		@user1 = UserFactory.create
		@character1 = GameCharacterFactory.create :user_id => @user1.id, :game_id => @game.id
	end

	test "合法性" do
		# 没有用户id
		rating1 = Rating.create(:user_id => nil, :rating => 5, :rateable_id => @game.id, :rateable_type => 'Game')
		assert !rating1.save

		# 没有rating
		rating2 = Rating.create(:user_id => @user.id, :rating => nil, :rateable_id => @game.id, :rateable_type => 'Game')
		assert !rating2.save
		
		# ratable 信息不全
		rating3 = Rating.create(:user_id => @user.id, :rating => 5, :rateable_id => nil, :rateable_type => 'Game')
		assert !rating3.save

		rating4 = Rating.create(:user_id => @user.id, :rating => 5, :rateable_id => @game.id, :rateable_type => nil)
		assert !rating4.save
		
		# 信息齐全
		rating5 = Rating.create(:user_id => @user.id, :rating => 5, :rateable_id => @game.id, :rateable_type => 'Game')
		assert rating5.save

	end

	test "打分的计数器和平均值" do
		# 给一个游戏打分
		rating6 = Rating.create(:user_id => @user.id, :rating => 5, :rateable_id => @game.id, :rateable_type => 'Game')
		@game.reload
		assert_equal @game.ratings_count, 1
		assert_equal @game.average_rating, 5
		assert @game.rated_by? @user
		assert !@game.rated_by?(@user1)
		assert_equal @game.average_rating_by(@user.id), 5

		# 另一个人打分
		rating7 = Rating.create(:user_id => @user1.id, :rating => 4, :rateable_id => @game.id, :rateable_type => 'Game')
		@game.reload
		assert_equal @game.ratings_count, 2
		assert @game.rated_by?(@user1)
		assert_equal @game.average_rating, 4.5
		assert_equal @game.average_rating_by([@user.id,@user1.id]), 4.5

		# 第一个人打第二次分
		rating6.created_at = 11.days.ago
		rating6.save
		rating8 = Rating.create(:user_id => @user.id, :rating => 3, :rateable_id => @game.id, :rateable_type => 'Game')
		@game.reload
		assert_equal @game.ratings_count, 3
		assert_equal @game.average_rating, 4
		assert_equal @game.average_rating_by(@user.id), 4

	end
end
