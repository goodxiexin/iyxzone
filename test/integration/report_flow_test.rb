require 'test_helper'

class ReportFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @blog = BlogFactory.create
    @user_sess = login @user
  end

  #
  # TODO: 举报资源的时候，不需要有查看该资源的权限，这个是否恰当？？？
  #
  test "report blog" do
    @user_sess.get "/reports/new", {:reportable_id => 'invalid', :reportable_type => 'Blog'}
    @user_sess.assert_template 'errors/404'

    assert_difference "Report.count" do
      @user_sess.post "/reports", {:reportable_id => @blog.id, :reportable_type => 'Blog', :report => {:category => Report::CATEGORY[0]}}
    end

    @blog.reload
    assert @blog.unverified?
  end

protected

  def login user
    open_session do |session|
      session.post "/sessions/create", :email => user.email, :password => user.password
      session.assert_redirected_to home_url
    end  
  end 

end
