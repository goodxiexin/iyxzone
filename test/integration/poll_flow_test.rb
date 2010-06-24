require 'test_helper'

class PollFlowTest < ActionController::IntegrationTest

  def setup
    @user = UserFactory.create
    @friend = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
    FriendFactory.create @user, @friend
    @stranger = UserFactory.create

    # create some polls for @user
    @poll1 = Poll.create :poster_id => @user.id, :game_id => @game.id, :privilege => 1, :no_deadline => 1, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}]
    sleep 1
    @poll2 = Poll.create :poster_id => @user.id, :game_id => @game.id, :privilege => 1, :no_deadline => 0, :deadline => 1.day.from_now, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}]
    sleep 1
    @poll3 = Poll.create :poster_id => @user.id, :game_id => @game.id, :privilege => 2, :no_deadline => 0, :deadline => 1.day.from_now, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}]
    sleep 1
    @poll4 = Poll.create :poster_id => @user.id, :game_id => @game.id, :privilege => 1, :no_deadline => 1, :name => 'name', :answers => [{:description => "answer1"}, {:description => "answer2"}, {:description => "answer3"}], :max_multiple => 2
  
    @user_sess = login @user
    @friend_sess = login @friend
    @stranger_sess = login @stranger
  end

  # Replace this with your real tests.
  test "GET /polls" do
    @user_sess.get '/polls', {:uid => 'invalid'}
    @user_sess.assert_not_found

    @user_sess.get '/polls', {:uid => @user.id}
    @user_sess.assert_template 'user/polls/index'
    assert_equal @user_sess.assigns(:polls), [@poll4, @poll3, @poll2, @poll1]

    @friend_sess.get '/polls', {:uid => @user.id}
    @friend_sess.assert_template 'user/polls/index'
    assert_equal @friend_sess.assigns(:polls), [@poll4, @poll3, @poll2, @poll1]    

    @poll3.unverify
    @friend_sess.get '/polls', {:uid => @user.id}
    @friend_sess.assert_template 'user/polls/index'
    assert_equal @friend_sess.assigns(:polls), [@poll4, @poll2, @poll1]    

    @user_sess.get '/polls', {:uid => @stranger.id}
    @user_sess.assert_redirected_to new_friend_url(:uid => @stranger.id)
  end

  test "GET /polls/participated" do
    @user_sess.get '/polls/participated', {:uid => 'invalid'}
    @user_sess.assert_not_found

    @user_sess.get '/polls/participated', {:uid => @user.id}
    @user_sess.assert_template 'user/polls/participated'
    assert_equal @user_sess.assigns(:polls), []

    @friend_sess.get '/polls/participated', {:uid => @user.id}
    @friend_sess.assert_template 'user/polls/participated'
    assert_equal @friend_sess.assigns(:polls), []

    @user_sess.post "/polls/#{@poll3.id}/votes", {:votes => [@poll3.answers.first.id]}  
    @user_sess.post "/polls/#{@poll4.id}/votes", {:votes => [@poll4.answers.first.id]}  
    @friend_sess.post "/polls/#{@poll3.id}/votes", {:votes => [@poll3.answers.first.id]}  
    @friend_sess.post "/polls/#{@poll4.id}/votes", {:votes => [@poll4.answers.first.id]}  

    @user_sess.get '/polls/participated', {:uid => @user.id}
    @user_sess.assert_template 'user/polls/participated'
    assert_equal @user_sess.assigns(:polls), []
    
    @user_sess.get '/polls/participated', {:uid => @friend.id}
    @user_sess.assert_template 'user/polls/participated'
    assert_equal @user_sess.assigns(:polls), [@poll4, @poll3]

    @poll3.unverify
    @user_sess.get '/polls/participated', {:uid => @friend.id}
    @user_sess.assert_template 'user/polls/participated'
    assert_equal @user_sess.assigns(:polls), [@poll4]

    @user_sess.get '/polls/participated', {:uid => @stranger.id}
    @user_sess.assert_redirected_to new_friend_url(:uid => @stranger.id)
  end
  
  test "GET /polls/recent" do
    @user_sess.get '/polls/recent'
    @user_sess.assert_template 'user/polls/recent'
    assert_equal @user_sess.assigns(:polls), [@poll4, @poll3, @poll2, @poll1]

    @poll3.unverify

    @user_sess.get '/polls/recent'
    @user_sess.assert_template 'user/polls/recent'
    assert_equal @user_sess.assigns(:polls), [@poll4, @poll2, @poll1]
  end

  test "GET /polls/hot" do
    @user_sess.get '/polls/hot'
    @user_sess.assert_template 'user/polls/hot'
    assert_equal @user_sess.assigns(:polls), [@poll4, @poll3, @poll2, @poll1]

    assert_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll3.id}/votes", {:votes => [@poll3.answers.first.id]}  
    end

    assert_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll2.id}/votes", {:votes => [@poll2.answers.first.id]}  
    end

    @user_sess.get '/polls/hot'
    @user_sess.assert_template 'user/polls/hot'
    assert_equal @user_sess.assigns(:polls), [@poll3, @poll2, @poll4, @poll1]

    @poll4.unverify

    @user_sess.get '/polls/hot'
    @user_sess.assert_template 'user/polls/hot'
    assert_equal @user_sess.assigns(:polls), [@poll3, @poll2, @poll1]
  end

  test "GET /polls/friends" do
    assert_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll2.id}/votes", {:votes => [@poll2.answers.first.id]}
    end

    @friend_sess.get "/polls/friends"
    @friend_sess.assert_template 'user/polls/friends'
    assert_equal @friend_sess.assigns(:polls), [@poll4, @poll3, @poll2, @poll1]
    
    @poll3.unverify
    @friend_sess.get "/polls/friends"
    @friend_sess.assert_template 'user/polls/friends'
    assert_equal @friend_sess.assigns(:polls), [@poll4, @poll2, @poll1]
  end

  test "GET /polls/:id" do
    [@poll1, @poll2, @poll3, @poll4].each do |poll|    
      @user_sess.get "/polls/#{poll.id}"
      @user_sess.assert_template 'user/polls/show'
      assert_nil @user_sess.assigns(:vote)
    end

    [@poll1, @poll2, @poll3, @poll4].each do |poll|    
      @friend_sess.get "/polls/#{poll.id}"
      @friend_sess.assert_template 'user/polls/show'
      assert_nil @friend_sess.assigns(:vote)
    end

    [@poll1, @poll2, @poll3, @poll4].each do |poll|    
      @stranger_sess.get "/polls/#{poll.id}"
      @stranger_sess.assert_template 'user/polls/show'
      assert_nil @stranger_sess.assigns(:vote)
    end

    @user_sess.post "/polls/#{@poll2.id}/votes", {:votes => [@poll2.answers.first.id]}
    @user_vote = @user_sess.assigns(:vote)
    @friend_sess.post "/polls/#{@poll2.id}/votes", {:votes => [@poll2.answers.first.id]}
    @friend_vote = @friend_sess.assigns(:vote)

    @user_sess.get "/polls/#{@poll2.id}"
    assert_equal @user_sess.assigns(:vote), @user_vote
    assert_equal @user_sess.assigns(:vote_feeds), [@friend_vote]

    @poll2.unverify

    @user_sess.get "/polls/#{@poll2.id}"
    @user_sess.assert_not_found
  end

  test "POST /polls" do
    @user_sess.get "/polls/new"
    @user_sess.assert_template 'user/polls/new'

    # create a poll with deadline
    assert_difference "Poll.count" do
      @user_sess.post "/polls", {:poll => {:name => "poll", :no_deadline => 1, :max_multiple => 1, :explanation => "", :privilege => 1, :game_id => @game.id, :description => "", :answers => [{"description"=>"adsf"}, {"description"=>"asdf"}, {"description"=>"asdf"}, {"description"=>""}, {"description"=>""}, {"description"=>""}, {"description"=>"adsf"}, {"description"=>"adsf"}, {"description"=>""}, {"description"=>""}]}}
    end
    @user_sess.assert_redirected_to poll_url(@user_sess.assigns(:poll))

    assert_difference "Poll.count" do
      @user_sess.post "/polls", {:poll => {:name => "poll", :no_deadline => 1, :max_multiple => 2, :explanation => "", :privilege => 2, :game_id => @game.id, :description => "", :answers => [{"description"=>"adsf"}, {"description"=>"asdf"}, {"description"=>"asdf"}, {"description"=>""}, {"description"=>""}, {"description"=>""}, {"description"=>"adsf"}, {"description"=>"adsf"}, {"description"=>""}, {"description"=>""}]}}
    end
    @user_sess.assert_redirected_to poll_url(@user_sess.assigns(:poll))

    assert_difference "Poll.count" do
      @user_sess.post "/polls", {:poll => {:name => "poll", :no_deadline => 0, :max_multiple => 1, :explanation => "", :deadline => "2100-06-24", :privilege => 1, :game_id => @game.id, :description => "", :answers => [{"description"=>"adsf"}, {"description"=>"asdf"}, {"description"=>"asdf"}, {"description"=>""}, {"description"=>""}, {"description"=>""}, {"description"=>"adsf"}, {"description"=>"adsf"}, {"description"=>""}, {"description"=>""}]}}
    end
    @user_sess.assert_redirected_to poll_url(@user_sess.assigns(:poll))

  end

  test "PUT /polls/:id" do
    @friend_sess.get "/polls/#{@poll2.id}/edit"
    @friend_sess.assert_not_found
    
    @friend_sess.put "/polls/#{@poll2.id}", {:poll => {:explanation => nil}}
    @friend_sess.assert_not_found

    @user_sess.get "/polls/invalid"
    @user_sess.assert_not_found

    @user_sess.get "/polls/#{@poll2.id}/edit", {:type => 0}
    @user_sess.assert_template 'user/polls/edit_deadline'
    
    @user_sess.put "/polls/#{@poll2.id}", {:poll => {:deadline => '2012-01-01'}}
    @poll2.reload
    assert_equal @poll2.deadline.to_s, "2012-01-01"
 
    @user_sess.get "/polls/#{@poll2.id}/edit", {:type => 1}
    @user_sess.assert_template 'user/polls/edit_explanation'
  
    @user_sess.put "/polls/#{@poll2.id}", {:poll => {:explanation => 'new'}}
    @poll2.reload
    assert_equal @poll2.explanation, 'new' 
  end

  test "POST /polls/:id/answers" do
    assert_no_difference "PollAnswer.count" do
      @friend_sess.post "/polls/#{@poll1.id}/answers", {:poll => {:answers => [{:description => 'new answer'}]}}
    end
    @friend_sess.assert_not_found

    @friend_sess.post "/polls/invalid/answers", {:poll => {:answers => [{:description => 'new answer'}]}}
    @friend_sess.assert_not_found

    assert_difference "@poll1.reload.answers_count" do
      @user_sess.post "/polls/#{@poll1.id}/answers", {:poll => {:answers => [{:description => 'new answer'}]}}
    end

    assert_no_difference "@poll1.reload.answers_count" do
      @user_sess.post "/polls/#{@poll1.id}/answers", {:poll => {:answers => []}}
    end
  end

  test "DELETE /polls/:id" do
    @friend_sess.delete "/polls/#{@poll1.id}"
    @friend_sess.assert_not_found

    @friend_sess.delete "/polls/invalid"
    @friend_sess.assert_not_found

    assert_difference "Poll.count", -1 do
      @user_sess.delete "/polls/#{@poll1.id}"
    end

    @poll2.unverify
    
    @user_sess.delete "/polls/#{@poll2.id}"
    @user_sess.assert_not_found
  end

  test "POST /polls/:id/votes" do
    # 投的投票不存在
    assert_no_difference "Vote.count" do
      @user_sess.post "/polls/invalid/votes", {:votes => []}
    end
    @user_sess.assert_not_found

    # 更本眉头
    assert_no_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll1.id}/votes", {:votes => []}
    end

    # 投的选项不存在
    assert_no_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll1.id}/votes", {:votes => ['invalid']}
    end

    # 正确的投票
    assert_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll1.id}/votes", {:votes => [@poll1.answers.first.id]}
    end
  
    # 投过了还投
    assert_no_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll1.id}/votes", {:votes => [@poll1.answers.first.id]}
    end

    # 过期了还投
    @poll2.update_attributes(:deadline => 1.day.ago)
    assert_no_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll2.id}/votes", {:votes => [@poll2.answers.first.id]}
    end

    # 不是好友还头
    assert_no_difference "Vote.count" do
      @stranger_sess.post "/polls/#{@poll3.id}/votes", {:votes => [@poll3.answers.first.id]}
    end

    # 投的超过了限制
    assert_no_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll4.id}/votes", {:votes => @poll4.answers.map(&:id)}
    end

    # 被屏蔽了还头
    @poll4.unverify
    assert_no_difference "Vote.count" do
      @user_sess.post "/polls/#{@poll4.id}/votes", {:votes => [@poll4.answers.first.id]}
    end
    @user_sess.assert_not_found
  end

  test "POST /polls/:id/invitations" do
    @friend_sess.get "/polls/#{@poll1.id}/invitations/new"
    @friend_sess.assert_not_found

    @friend_sess.get "/polls/invalid/invitations/new"
    @friend_sess.assert_not_found

    @user_sess.get "/polls/#{@poll1.id}/invitations/new"
    @user_sess.assert_template 'user/polls/invitations/new'
    assert_equal @user_sess.assigns(:friends), [@friend]

    @poll1.unverify

    @user_sess.get "/polls/#{@poll1.id}/invitations/new"
    @user_sess.assert_not_found

    assert_no_difference "PollInvitation.count" do
      @user_sess.post "/polls/#{@poll1.id}/invitations", {:values => [@friend.id]}
    end

    @poll1.verify

    assert_difference "PollInvitation.count" do
      @user_sess.post "/polls/#{@poll1.id}/invitations", {:values => [@friend.id]}
    end
    @friend.reload
    assert_equal @friend.poll_invitations_count, 1

    assert_no_difference "PollInvitation.count" do
      @user_sess.post "/polls/#{@poll1.id}/invitations", {:values => [@friend.id]}
    end

    assert_no_difference "PollInvitation.count" do
      @user_sess.post "/polls/#{@poll1.id}/invitations", {:values => ['invalid', @stranger.id]}
    end

    assert_no_difference "PollInvitation.count" do
      @user_sess.post "/polls/#{@poll1.id}/invitations", {:values => []}
    end
  end

end
