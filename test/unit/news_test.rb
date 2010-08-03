require 'test_helper'

class NewsTest < ActiveSupport::TestCase

	def setup
		# create an admin user
		@admin = AdminFactory.create
		
    # create a user with game character
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
		@game = @character.game
	end
  
	test "合法性测试" do
		news2 = News.new :game_id => @game.id, :poster_id => @admin.id, :news_type => "text", :title => "haha", :data => "blabla"
		assert news2.save

		# need game id
		news3 = News.new :game_id => nil, :poster_id => @admin.id, :news_type => "text", :title => "haha", :data => "blabla"
		assert !news3.save

		# need news_type
		news4 = News.new :game_id => @game.id, :poster_id => @admin.id, :news_type => "", :title => "haha", :data => "blabla"
		assert !news4.save
	end

  test "发布文字新闻" do
		# 发布
		news1 = News.new :game_id => @game.id, :poster_id => @admin.id, :news_type => "text", :title => "haha", :data => "blabla"
		assert news1.save

    # abstract
    assert_not_nil news1.data_abstract

		# 编辑 标题不能为空
		assert !news1.update_attributes(:title => '')

		# 编辑 data不能为空
		assert !news1.update_attributes(:data => '')

		# user 留言
		assert news1.is_commentable_by? @user
	  @comment = news1.comments.create :poster_id => @user.id, :content => 'a'
    assert !@comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@admin)
		
    # user 顶
		assert news1.is_diggable_by? @user
  end

  test "发布视频新闻" do
		# 发布
		news1 = News.new :game_id => @game.id, :poster_id => @admin.id, :news_type => "video", :title => "haha", :video_url => "http://v.youku.com/v_show/id_XMTgyMTA5NzUy.html", :data => "blabla"
		assert news1.save

    # abstract
    assert_nil news1.data_abstract

		# 编辑 标题不能为空
		assert !news1.update_attributes(:title => '')

		# 编辑 data不能为空
		assert !news1.update_attributes(:data => '')

		# 编辑 video url 不能为空
		assert !news1.update_attributes(:video_url => '')

		# user 留言
		assert news1.is_commentable_by? @user
    @comment = news1.comments.create :poster_id => @user.id, :content => 'a'
    assert !@comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@admin)
	
		# user 顶
		assert news1.is_diggable_by? @user
  end

  test "发布图片新闻" do
		# 图片发表
		news1 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "picture", :title => "haha", :data => "blabla"
		photo = PhotoFactory.create :type => 'NewsPicture', :news_id => news1.id, :notation => "funny"

    # abstract
    assert_nil news1.data_abstract

		# 编辑 标题不能为空
		assert !news1.update_attributes(:title => '')

		# 编辑 data不能为空
		assert !news1.update_attributes(:data => '')

		# user 留言
		assert news1.is_commentable_by? @user
    @comment = news1.comments.create :poster_id => @user.id, :content => 'a'
    assert !@comment.is_deleteable_by?(@user)
    assert @comment.is_deleteable_by?(@admin)

		# user 顶
		assert news1.is_diggable_by? @user
  end

end
