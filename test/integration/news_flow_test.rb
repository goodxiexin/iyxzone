require 'test_helper'

class NewsFlowTest < ActionController::IntegrationTest

	def setup
		# create an admin user
		@admin = AdminFactory.create
		
    # create a user with game character
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
		@game = @character.game

		# login
		@admin_sess = login @admin
    @user_sess = login @user

		@news = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "text", :title => "haha", :data => "blabla", :created_at => 1.hour.ago

		@news1 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "text", :title => "news1", :data => "blabla", :created_at => 1.day.ago

		@news2 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "text", :title => "news2", :data => "blabla", :created_at => 2.days.ago

		@news3 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "text", :title => "news3", :data => "blabla", :created_at => 3.days.ago

		@news6 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "text", :title => "news6", :data => "blabla", :created_at => 2.weeks.ago

		@news4 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "video", :title => "video news", :video_url => "http://v.youku.com/v_show/id_XMTgyMTA5NzUy.html", :data => "blabla", :created_at => 2.hours.ago

		@news5 = News.create :game_id => @game.id, :poster_id => @admin.id, :news_type => "picture", :title => "haha", :data => "blabla", :created_at => 3.hours.ago
	end
  
	test "POST create" do
    @user_sess.get "admin/news/new", {:type => 'text'}
    @user_sess.assert_not_found

    @admin_sess.get "admin/news/new", {:type => 'invalid'}
    @admin_sess.assert_not_found

    @admin_sess.get "admin/news/new", {:type => 'text'}
    @admin_sess.assert_template "admin/news/new_text_news"

    # XIEXIN
    # TODO
    # 创建picture news, 包括上传图片，然后编辑图片

    @admin_sess.get "admin/news/new", {:type => 'picture'}
    @admin_sess.assert_template "admin/news/new_picture_news"

    @admin_sess.get "admin/news/new", {:type => 'video'}
    @admin_sess.assert_template "admin/news/new_video_news"

    assert_no_difference "News.count" do
      @admin_sess.post "/admin/news", {:news => {:title => 'hehe', :data => 'hehe', :game_id => @game.id, :news_type => ""}}
    end

    assert_difference "News.count" do
      @admin_sess.post "/admin/news", {:news => {:title => 'hehe', :data => 'hehe', :game_id => @game.id, :news_type => "text"}}
    end
	end

	test "GET edit & PUT update" do
		@user_sess.get "/admin/news/#{@news.id}/edit"
		@user_sess.assert_not_found

		@admin_sess.get "/admin/news/#{@news.id}/edit"
		@admin_sess.assert_template "admin/news/edit"

		@user_sess.put "/admin/news/invalid", {:news => {:title => "new t"}}
		@user_sess.assert_not_found

		@admin_sess.put "/admin/news/#{@news.id}", {:news => {:title => "new t"}}
		@news.reload
		assert_equal @news.title, "new t"

		@admin_sess.put "/admin/news/invalid", {:news => {:title => "new t"}}
		@admin_sess.assert_not_found
	end

	test "admin index GET" do
		@user_sess.get "/admin/news"
		@user_sess.assert_not_found

		@admin_sess.get "/admin/news"
		@admin_sess.assert_template "admin/news/index"
		assert_equal @admin_sess.assigns(:news_list), [@news, @news4, @news5, @news1,@news2,@news3,@news6]
	end

	test "user index GET" do
		@user_sess.get "/news?type=0&time=0"
		@user_sess.assert_template "user/news/index"
		assert_equal @user_sess.assigns(:news_list), [@news, @news4, @news5]

		@user_sess.get "/news?type=1&time=0"
		assert_equal @user_sess.assigns(:news_list), [@news]

		@user_sess.get "/news?type=3&time=0"
		assert_equal @user_sess.assigns(:news_list), [@news5]

		@user_sess.get "/news?type=2&time=0"
		assert_equal @user_sess.assigns(:news_list), [@news4]

		@user_sess.get "/news?time=1&type=0"
		assert_equal @user_sess.assigns(:news_list), [@news1]

		@user_sess.get "/news?time=2&type=0"
		assert_equal @user_sess.assigns(:news_list), [@news2, @news3]

		@user_sess.get "/news?time=3&type=0"
		assert_equal @user_sess.assigns(:news_list), [@news6]
	end

	test "user GET show" do	
		@user_sess.get "/news/invalid"
		@user_sess.assert_not_found

		@user_sess.get "/news/#{@news.id}"
		@user_sess.assert_template "user/news/show"
		assert_equal @user_sess.assigns(:news), @news
	end

	test "DELETE destroy" do
		@user_sess.delete "admin/news/#{@news.id}"
		@user_sess.assert_not_found

    @admin_sess.delete "admin/news/invalid"
    @admin_sess.assert_not_found

    assert_difference "News.count",-1 do
			@admin_sess.delete "admin/news/#{@news2.id}"
		end
		
	end
end
