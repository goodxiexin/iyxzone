require 'test_helper'

class IdolFlowTest < ActionController::IntegrationTest

  def setup
    @user1 = UserFactory.create
    @user2 = UserFactory.create
    @idol1 = UserFactory.create :is_idol => true
    @idol2 = UserFactory.create :is_idol => true
    @user1_sess = login @user1
    @user2_sess = login @user2
    @idol1_sess = login @idol1
    @idol2_sess = login @idol2
  end

  test "GET /idols" do
    @user1_sess.get "/idols"
    @user1_sess.assert_template 'user/idols/index'
    assert_equal @user1_sess.assigns(:idols), [@idol1, @idol2]
  end

  test "POST /idols/:id/follow & DELETE /idols/:id/unfollow" do 
    assert_no_difference "Fanship.count" do
      @user1_sess.post "/idols/invalid/follow", {:at => 'idol_list'}
    end

    # 不是名人
    assert_no_difference "Fanship.count" do
      @user1_sess.post "/idols/#{@user2.id}/follow", {:at => 'idol_list'}
    end

    # 自己
    assert_no_difference "Fanship.count" do
      @idol1_sess.post "/idols/#{@idol1.id}/follow", {:at => 'idol_list'}
    end
 
    # 合法
    assert_difference "@idol1.reload.fans_count" do
      @user1_sess.post "/idols/#{@idol1.id}/follow", {:at => 'idol_list'}
    end

    # 重复加
    assert_no_difference "@idol1.reload.fans_count" do
      @user1_sess.post "/idols/#{@idol1.id}/follow", {:at => 'idol_list'}
    end

    # 合法
    assert_difference "@idol2.reload.fans_count" do
      @user1_sess.post "/idols/#{@idol2.id}/follow", {:at => 'idol_list'}
    end

    # 不存在
    assert_no_difference "Fanship.count", -1 do
      @user1_sess.delete "/idols/invalid/unfollow", {:at => 'idol_list'}
    end

    # 合法
    assert_difference "@idol1.reload.fans_count", -1 do
      @user1_sess.delete "/idols/#{@idol1.id}/unfollow", {:at => 'idol_list'}
    end

    assert_difference "@idol2.reload.fans_count", -1 do
      @user1_sess.delete "/idols/#{@idol2.id}/unfollow", {:at => 'idol_list'}
    end
  
    # 不停的反复
    assert_difference "@idol2.reload.fans_count" do
      @user1_sess.post "/idols/#{@idol2.id}/follow", {:at => 'idol_list'}
    end

    assert_difference "@idol2.reload.fans_count", -1 do
      @user1_sess.delete "/idols/#{@idol2.id}/unfollow", {:at => 'idol_list'}
    end
  
  end

  test "GET /fans" do
    @user1_sess.post "/idols/#{@idol1.id}/follow", {:at => 'idol_list'}
    @user2_sess.post "/idols/#{@idol1.id}/follow", {:at => 'idol_list'}

    @idol1_sess.get '/fans', {:uid => 'invalid'}
    @idol1_sess.assert_not_found

    @idol1_sess.get '/fans', {:uid => @user1.id}
    @idol1_sess.assert_not_found

    @idol1_sess.get '/fans', {:uid => @idol1.id}
    @idol1_sess.assert_template 'user/fans/index'
    assert_equal @idol1_sess.assigns(:fans), [@user1, @user2]

    assert_no_difference "Fanship.count" do
      @idol1_sess.delete "/fans/invalid"
    end
    @idol1_sess.assert_not_found

    assert_no_difference "Fanship.count" do
      @idol1_sess.delete "/fans/#{@idol2.id}"
    end
    @idol1_sess.assert_not_found

    assert_no_difference "Fanship.count" do
      @idol2_sess.delete "/fans/#{@user1.id}"
    end
    @idol2_sess.assert_not_found

    assert_difference "Fanship.count", -1 do
      @idol1_sess.delete "/fans/#{@user1.id}"
    end

    assert_difference "Fanship.count", -1 do
      @idol1_sess.delete "/fans/#{@user2.id}"
    end
  end

end
