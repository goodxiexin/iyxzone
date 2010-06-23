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
		# only admin can post a piece of news
		# model不能保证只有admin才能发表新闻
		#news1 = News.create :game_id => @game.id, :poster_id => @user.id, :news_type => "text", :title => "haha", :data => "blabla"
		#assert !news1.save

		news2 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "text", :title => "haha", :data => "blabla"
		assert news2.save

		# need game id
		news3 = News.create :game_id => nil, :poster_id => @admin.id, :news_type => "text", :title => "haha", :data => "blabla"
		assert !news3.save

		# need news_type
		news4 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "", :title => "haha", :data => "blabla"
		assert !news4.save

	end

  test "发布文字新闻" do
		# 发布
		news1 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "text", :title => "haha", :data => "blabla"
		assert news1.save

		# 编辑 标题不能为空
		news1.update_attributes(:title => '')
		assert !news1.save

		# 编辑 data不能为空
		news1.update_attributes(:data => '')
		assert !news1.save

		# user 分享
		assert news1.is_shareable_by? @user

		# user 留言
		assert news1.is_commentable_by? @user
		
		# user 顶
		assert news1.is_diggable_by? @user
		
  end

  test "发布视频新闻" do
		# 发布
		news1 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "video", :title => "haha", :video_url => "http://v.youku.com/v_show/id_XMTgyMTA5NzUy.html", :data => "blabla"
		assert news1.save

		# 编辑 标题不能为空
		news1.update_attributes(:title => '')
		assert !news1.save

		# 编辑 data不能为空
		news1.update_attributes(:data => '')
		assert !news1.save

		# 编辑 video url 不能为空
		news1.update_attributes(:video_url => '')
		assert !news1.save

		# user 分享
		assert news1.is_shareable_by? @user

		# user 留言
		assert news1.is_commentable_by? @user
		
		# user 顶
		assert news1.is_diggable_by? @user
		
  end

  test "发布图片新闻" do
		# 图片发表
		news1 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "picture", :title => "haha", :data => "blabla"

		# don't know how to create news picture correctly
		photo = PhotoFactory.create :type => 'NewsPicture', :news_id => nil, :notation => "funny"
		assert !photo.save

		photo1 = PhotoFactory.create :type => 'NewsPicture', :news_id => news1.id, :notation => "funny"
		# 不知道怎么测试这个
		#assert photo1.save
		assert news1.save

		# 编辑 标题不能为空
		news1.update_attributes(:title => '')
		assert !news1.save

		# 编辑 data不能为空
		news1.update_attributes(:data => '')
		assert !news1.save

		# user 分享
		assert news1.is_shareable_by? @user

		# user 留言
		assert news1.is_commentable_by? @user
		
		# user 顶
		assert news1.is_diggable_by? @user
		
  end

end
