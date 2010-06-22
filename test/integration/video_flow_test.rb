require 'test_helper'

class VideoFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
    @user_sess = login @user
   
    @friend = UserFactory.create
    @friend_sess = login @friend
    GameCharacterFactory.create @character.game_info.merge({:user_id => @friend.id})
    FriendFactory.create @user, @friend

    @same_game_user = UserFactory.create
    @same_game_user_sess = login @same_game_user
    GameCharacterFactory.create @character.game_info.merge({:user_id => @same_game_user.id})

    @stranger = UserFactory.create
    @stranger_sess = login @stranger

    # create videos for user and friend
    @video1 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@friend.id]
    sleep 1
    @video2 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@friend.id]
    sleep 1
    @video3 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@friend.id]
    sleep 1
    @video4 = VideoFactory.create :poster_id => @user.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@friend.id]
    sleep 1
    @video5 = VideoFactory.create :poster_id => @friend.id, :game_id => @game.id, :privilege => PrivilegedResource::PUBLIC, :new_friend_tags => [@user.id]
    sleep 1
    @video6 = VideoFactory.create :poster_id => @friend.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND_OR_SAME_GAME, :new_friend_tags => [@user.id]
    sleep 1
    @video7 = VideoFactory.create :poster_id => @friend.id, :game_id => @game.id, :privilege => PrivilegedResource::FRIEND, :new_friend_tags => [@user.id]
    sleep 1
    @video8 = VideoFactory.create :poster_id => @friend.id, :game_id => @game.id, :privilege => PrivilegedResource::OWNER, :new_friend_tags => [@user.id]
  
    assert Video.count, 8
  end

=begin
  test "GET /videos/new & POST /create" do
    @user_sess.get '/videos/new'
    @user_sess.assert_template 'user/videos/new'

    assert_difference "Video.count" do
      @user_sess.post '/videos', {:video => {:title => 't', :description => 'd', :game_id => @game.id, :video_url => 'http://v.youku.com/v_show/id_XMTY3NDE5Nzg4.html'}}
    end

    assert_no_difference "Video.count" do
      @user_sess.post '/videos', {:video => {:title => 't', :description => 'd', :game_id => @game.id, :video_url => nil}}
    end
  end

  test "GET /videos/:id/edit & PUT /videos/:id" do
    @user_sess.get "/videos/#{@video1.id}/edit"
    @user_sess.assert_template 'user/videos/edit'
    assert_equal @user_sess.assigns(:video), @video1

    @user_sess.put "/videos/#{@video1.id}", {:video => {:title => 'new title'}}
    @video1.reload
    assert_equal @video1.title, 'new title'

    @user_sess.get "/videos/invalid/edit"
    @user_sess.assert_not_found

    @user_sess.put "/videos/invalid", {:video => {:title => 'new title'}}
    @user_sess.assert_not_found

    @user_sess.get "/videos/#{@video5.id}/edit"
    @user_sess.assert_not_found

    @user_sess.put "/videos/#{@video5.id}", {:video => {:title => 'new title'}}
    @user_sess.assert_not_found
  end
=end

  test "GET /videos" do
    @user_sess.get "/videos", {:uid => 'invalid'}
    @user_sess.assert_not_found

    @user_sess.get "/videos", {:uid => @user.id}
    @user_sess.assert_template 'user/videos/index'
    assert_equal @user_sess.assigns(:videos), [@video4, @video3, @video2, @video1]

    @friend_sess.get "/videos", {:uid => @user.id}
    @friend_sess.assert_template 'user/videos/index'
    assert_equal @friend_sess.assigns(:videos), [@video3, @video2, @video1]

    @same_game_user_sess.get "/videos", {:uid => @user.id}
    @same_game_user_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @stranger_sess.get "/videos", {:uid => @user.id}
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @video2.unverify
    
    @user_sess.get "/videos", {:uid => @user.id}
    @user_sess.assert_template 'user/videos/index'
    assert_equal @user_sess.assigns(:videos), [@video4, @video3, @video1]

    @friend_sess.get "/videos", {:uid => @user.id}
    @friend_sess.assert_template 'user/videos/index'
    assert_equal @friend_sess.assigns(:videos), [@video3, @video1]
  end

  test "GET /videos/relative" do
    @user_sess.get "/videos/relative", {:uid => 'invalid'}
    @user_sess.assert_not_found

    @user_sess.get "/videos/relative", {:uid => @user.id}
    @user_sess.assert_template 'user/videos/relative'
    assert_equal @user_sess.assigns(:videos), [@video7, @video6, @video5]

    @friend_sess.get "/videos/relative", {:uid => @user.id}
    @friend_sess.assert_template 'user/videos/relative'
    assert_equal @friend_sess.assigns(:videos), [@video7, @video6, @video5]

    @same_game_user_sess.get "/videos/relative", {:uid => @user.id}
    @same_game_user_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @stranger_sess.get "/videos/relative", {:uid => @user.id}
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @video6.unverify
    
    @user_sess.get "/videos/relative", {:uid => @user.id}
    @user_sess.assert_template 'user/videos/relative'
    assert_equal @user_sess.assigns(:videos), [@video7, @video5]

    @friend_sess.get "/videos/relative", {:uid => @user.id}
    @friend_sess.assert_template 'user/videos/relative'
    assert_equal @friend_sess.assigns(:videos), [@video7, @video5]
  end

  test "GET /videos/recent" do
    @user_sess.get '/videos/recent'
    @user_sess.assert_template 'user/videos/recent'
    assert_equal @user_sess.assigns(:videos), [@video7, @video6, @video5, @video3, @video2, @video1]

    @video6.unverify
    @video8.unverify
    @video3.unverify

    @user_sess.get '/videos/recent'
    @user_sess.assert_template 'user/videos/recent'
    assert_equal @user_sess.assigns(:videos), [@video7, @video5, @video2, @video1]
  end

  test "GET /videos/hot" do
    assert_difference "@video1.digs.count" do
      @user_sess.post "/digs", {:diggable_type => 'Video', :diggable_id => @video1.id}
    end

    assert_difference "@video5.digs.count" do
      @user_sess.post "/digs", {:diggable_type => 'Video', :diggable_id => @video5.id}
    end

    assert_difference "@video1.digs.count" do
      @friend_sess.post "/digs", {:diggable_type => 'Video', :diggable_id => @video1.id}
    end

    assert_difference "@video3.digs.count" do
      @friend_sess.post "/digs", {:diggable_type => 'Video', :diggable_id => @video3.id}
    end

    @user_sess.get '/videos/hot'
    @user_sess.assert_template 'user/videos/hot'
    assert_equal @user_sess.assigns(:videos), [@video1, @video5, @video3, @video7, @video6, @video2] 

    @video5.unverify
    @video1.unverify

    @user_sess.get '/videos/hot'
    @user_sess.assert_template 'user/videos/hot'
    assert_equal @user_sess.assigns(:videos), [@video3, @video7, @video6, @video2] 
  end

  test "GET /videos/:id/show" do
    @user_sess.get "/videos/invalid"
    @user_sess.assert_not_found

    @user_sess.get "/videos/#{@video1.id}"
    @user_sess.assert_template 'user/videos/show'
    assert_equal @user_sess.assigns(:video), @video1 

    @user_sess.get "/videos/#{@video2.id}"
    @user_sess.assert_template 'user/videos/show'
    assert_equal @user_sess.assigns(:video), @video2

    @user_sess.get "/videos/#{@video3.id}"
    @user_sess.assert_template 'user/videos/show'
    assert_equal @user_sess.assigns(:video), @video3 

    @user_sess.get "/videos/#{@video4.id}"
    @user_sess.assert_template 'user/videos/show'
    assert_equal @user_sess.assigns(:video), @video4 

    @friend_sess.get "/videos/#{@video1.id}"
    @friend_sess.assert_template 'user/videos/show'
    assert_equal @friend_sess.assigns(:video), @video1 

    @friend_sess.get "/videos/#{@video2.id}"
    @friend_sess.assert_template 'user/videos/show'
    assert_equal @friend_sess.assigns(:video), @video2

    @friend_sess.get "/videos/#{@video3.id}"
    @friend_sess.assert_template 'user/videos/show'
    assert_equal @friend_sess.assigns(:video), @video3 

    @friend_sess.get "/videos/#{@video4.id}"
    @friend_sess.assert_not_found
    
    @same_game_user_sess.get "/videos/#{@video1.id}"
    @same_game_user_sess.assert_template 'user/videos/show'
    assert_equal @same_game_user_sess.assigns(:video), @video1

    @same_game_user_sess.get "/videos/#{@video2.id}"
    @same_game_user_sess.assert_template 'user/videos/show'
    assert_equal @same_game_user_sess.assigns(:video), @video2
      
    @same_game_user_sess.get "/videos/#{@video3.id}"
    @same_game_user_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @same_game_user_sess.get "/videos/#{@video4.id}"
    @same_game_user_sess.assert_not_found

    @stranger_sess.get "/videos/#{@video1.id}"
    @stranger_sess.assert_template 'user/videos/show'
    assert_equal @stranger_sess.assigns(:video), @video1

    @stranger_sess.get "/videos/#{@video2.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)
 
    @stranger_sess.get "/videos/#{@video3.id}"
    @stranger_sess.assert_redirected_to new_friend_url(:uid => @user.id)

    @stranger_sess.get "/videos/#{@video4.id}"
    @stranger_sess.assert_not_found
  end

  test "DELETE /videos/:id" do
    assert_difference "Video.count", -1 do
      @user_sess.delete "/videos/#{@video1.id}"
    end

    assert_no_difference "Video.count" do
      @user_sess.delete "/videos/invalid"
    end
    @user_sess.assert_not_found

    assert_no_difference "Video.count" do
      @user_sess.delete "/videos/#{@video5.id}"
    end
    @user_sess.assert_not_found

    @video2.unverify
    assert_no_difference "Video.count" do
      @user_sess.delete "/videos/#{@video2.id}"
    end
    @user_sess.assert_not_found
  end

end
