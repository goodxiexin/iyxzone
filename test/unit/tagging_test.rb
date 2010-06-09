require 'test_helper'

class TaggingTest < ActiveSupport::TestCase

  # 只用game来测试
  # 具体什么时候能tag，在具体的taggable类里测试
  # 这里只测试基本的计数器和数据合法性

  def setup
		# create a taggable
    @game = GameFactory.create

		# create a user that have one character in this tame
		@user1 = UserFactory.create
		@character1 = GameCharacterFactory.create :user_id => @user1.id, :game_id => @game.id
		
		# create a user do not related to that game
		@user2 = UserFactory.create
		@character2 = GameCharacterFactory.create :user_id => @user2.id

		@tag = Tag.create(:name => 'haliluya', :taggable_type => 'Game')
  end

  test "标签合法性" do
    tagging2 = Tagging.create(:poster_id => nil, :taggable_type => 'Game', :taggable_id => 1, :tag_id => @tag.id)
    assert !tagging2.save

		# 没有被标记的资源
    tagging3 = Tagging.create(:poster_id => @user1.id, :taggable_type => nil, :taggable_id => @game.id, :tag_id => @tag.id)
    assert !tagging3.save

    tagging4 = Tagging.create(:poster_id => @user1.id, :taggable_type => 'Game', :taggable_id => nil, :tag_id => @tag.id)
    assert !tagging4.save

		# 被标记的资源不存在
    tagging5 = Tagging.create(:poster_id => @user1.id, :taggable_type => 'Game', :taggable_id => 12345, :tag_id => @tag.id)
    assert !tagging5.save
  end

  # 标记(游戏)
  test "标记计数器" do
		# 标记一次
		@game.add_tag @user1, "hallo"
    @game.reload
		tag = Tag.find_by_name("hallo")
    assert_equal tag.taggings_count, 1
    assert_equal @game.taggings.count, 1

		# 标记已有标签
		@game.add_tag @user2, "haliluya"
    @game.reload
		@tag.reload
    assert_equal @tag.taggings_count, 1
    assert_equal @game.taggings.count, 2

		@game.taggings.destroy_all
		tag.reload
    @game.reload
		@tag.reload
		assert_equal tag.taggings_count, 0
    assert_equal @tag.taggings_count, 0
    assert_equal @game.taggings.count, 0

  end

end
