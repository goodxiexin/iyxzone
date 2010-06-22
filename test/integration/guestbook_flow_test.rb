require 'test_helper'

class GuestbookFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @user_sess = login @user
    
    @admin = AdminFactory.create
    @admin_sess = login @admin
  end

  test "GET /guestbooks/new" do
    # 这个必须要测，因为有写浏览器不支持referer
    @user_sess.get '/guestbooks/new'
    @user_sess.assert_template 'user/guestbooks/new'

    # TODO: 如何设置http_referer
=begin
    @blog = BlogFactory.create
    @user_sess.request.env['HTTP_REFERER'] = "/blogs/#{@blog.id}"
    @user_sess.get '/guestbooks/new'
    @user_sess.assert_template 'user/guestbooks/new'
    assert_equal @user_sess.assigns(:guestbook).catagory, '日志'
=end
  end

  test "POST /guestbooks" do
    @user_sess.get '/guestbooks/new'
    @user_sess.assert_template 'user/guestbooks/new'
 
    assert_difference "Guestbook.count" do
      @user_sess.post '/guestbooks', {:guestbook => {:priority => Guestbook::Justsoso, :catagory => '日志', :description => 'guestbook'}}
    end 
  end

  test "PUT /admin/guestbooks" do
    @user_sess.get '/admin/guestbooks'
    @user_sess.assert_not_found
    
    @admin_sess.get '/admin/guestbooks'
    @admin_sess.assert_template 'admin/guestbooks/index'

    @guestbook = GuestbookFactory.create :user_id => @user.id

    assert_no_difference "Email.count" do
      @user_sess.put "/admin/guestbooks/#{@guestbook.id}", {:guestbook => {:reply => 'soso'}}
    end
    @user_sess.assert_not_found
 
    assert_difference "Email.count" do
      @admin_sess.put "/admin/guestbooks/#{@guestbook.id}", {:guestbook => {:reply => 'soso'}}
    end
  end

end
