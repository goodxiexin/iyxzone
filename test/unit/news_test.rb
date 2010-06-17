require 'test_helper'

class NewsTest < ActiveSupport::TestCase

	def setup
		# create an admin user
		@admin = AdminFactory.create
		
    # create a user with game character
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

	end
  
  test "发布文字新闻" do
		# admin user 发布

		# admin user edit

		# user 查看
		
  end

  test "发布图片新闻" do
		#
  end

  test "发布视频新闻" do
		#
  end

end
