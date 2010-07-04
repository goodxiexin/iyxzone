require 'test_helper'

class ApplicationSettingFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id

    # login
    @user_sess = login @user
	end

	test "GET show" do 
		@user_sess.get "/application_setting"
		@user_sess.assert_template "user/application_setting/show"
	end

	test "GET edit & PUT update" do
    @types = ['blog', 'video', 'photo', 'poll','event', 'guild', 'sharing']
    @names = ['日志', '视频', '照片', '投票', '活动', '公会', '分享']
    
    @types.each_with_index do |type, i|
      @user_sess.get "/application_setting/edit", {:type => i}
		  @user_sess.assert_template "user/application_setting/edit"
      assert_equal @user_sess.assigns(:type), type
      assert_equal @user_sess.assigns(:name), @names[i]
    end
	end

	test "PUT update" do
		@user_sess.get "/application_setting/edit", {:type => 'blog'}
		@user_sess.put "/application_setting", {:setting => {:emit_blog_feed => 0}}
		assert_equal @user.reload.application_setting.emit_blog_feed, 0
	end

end
