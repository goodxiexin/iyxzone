require 'test_helper'

class ForumFlowTest < ActionController::IntegrationTest

  def setup
    @president = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @president.id
    @guild = GuildFactory.create :character_id => @character.id
    @forum = @guild.forum
    @user = UserFactory.create
    
    @president.activate
    @user.activate
    @president_sess = login @president
    @user_sess = login @user

    # create some topics and posts for this forum
    @topic1 = TopicFactory.create :poster_id => @president.id, :forum_id => @forum.id
    sleep 1
    @topic2 = TopicFactory.create :poster_id => @president.id, :forum_id => @forum.id
    sleep 1
    @topic3 = TopicFactory.create :poster_id => @president.id, :forum_id => @forum.id
    sleep 1
    @topic4 = TopicFactory.create :poster_id => @user.id, :forum_id => @forum.id
    sleep 1
    @topic5 = TopicFactory.create :poster_id => @president.id, :forum_id => @forum.id, :top => true
    sleep 1
    @topic6 = TopicFactory.create :poster_id => @president.id, :forum_id => @forum.id, :top => true
    sleep 1
    @topic7 = TopicFactory.create :poster_id => @user.id, :forum_id => @forum.id, :top => true    
  end
  
  test "GET /forums/:id" do
    @user_sess.get "/forums/#{@forum.id}"
    @user_sess.assert_template 'user/forums/show'
    assert_equal @user_sess.assigns(:topics), [@topic4, @topic3, @topic2, @topic1]
    assert_equal @user_sess.assigns(:top_topics), [@topic7, @topic6, @topic5]

    @topic4.unverify
    @topic6.unverify

    @user_sess.get "/forums/#{@forum.id}"
    @user_sess.assert_template 'user/forums/show'
    assert_equal @user_sess.assigns(:topics), [@topic3, @topic2, @topic1]
    assert_equal @user_sess.assigns(:top_topics), [@topic7, @topic5]

    @user_sess.get "/forums/invalid"
    @user_sess.assert_template "errors/404"
  end

  test "GET /topics/:id" do
    @user_sess.get "/topics/#{@topic1.id}"
    @user_sess.assert_template "user/topics/show"
    assert_equal @user_sess.assigns(:topic), @topic1 

    @topic1.unverify
    @user_sess.get "/topics/#{@topic1.id}"
    @user_sess.assert_template "errors/404"

    @topic1.verify
    @user_sess.get "/topics/#{@topic1.id}"
    @user_sess.assert_template "user/topics/show"
    assert_equal @user_sess.assigns(:topic), @topic1 
  end

  test "POST /topics" do
    @user_sess.get "/topics/new?forum_id=#{@forum.id}"
    @user_sess.assert_template 'user/topics/new'

    assert_difference "Topic.count" do
      @user_sess.post "/topics", {:topic => {:subject => '2b', :content => '2b'}, :forum_id => @forum.id}
    end

    @topic = @user_sess.assigns(:topic)
    @user_sess.assert_redirected_to topic_url(@topic)
    assert_equal @topic.poster_id, @user.id
  end

  test "DELETE /topics/:id" do
    @user_sess.delete "/topics/#{@topic1.id}", {:at => 'forum_show'}
    @user_sess.assert_not_found

    assert_difference "Topic.count", -1 do
      @president_sess.delete "/topics/#{@topic1.id}", {:at => 'forum_show'}
    end

    @topic2.unverify
    assert_no_difference "Topic.count" do
      @president_sess.delete "/topics/#{@topic2.id}", {:at => 'forum_show'}
    end
    @president_sess.assert_not_found
  end

  test "POST /posts" do
    assert_difference "Post.count" do
      @president_sess.post "/posts", {:topic_id => @topic1.id, :post => {:recipient_id => @user.id, :content => 'reply to user'}}
    end

    @post1 = @president_sess.assigns(:post)
    @president_sess.assert_redirected_to topic_url(@topic1, :page => 1)

    sleep 1

    assert_difference "Post.count" do
      @user_sess.post "/posts", {:topic_id => @topic1.id, :post => {:recipient_id => @president.id, :content => 'reply to president'}}
    end

    @post2 = @user_sess.assigns(:post)
    @user_sess.assert_redirected_to topic_url(@topic1, :page => 1)

    @topic1.reload and @forum.reload
    assert_equal @forum.posts_count, 2
    assert_equal @topic1.posts_count, 2

    @user_sess.get "/topics/#{@topic1.id}"
    @user_sess.assert_template "user/topics/show"
    assert_equal @user_sess.assigns(:topic), @topic1
    assert_equal @user_sess.assigns(:posts), [@post1, @post2]
    
    @post2.unverify
    @user_sess.get "/topics/#{@topic1.id}"
    @user_sess.assert_template "user/topics/show"
    assert_equal @user_sess.assigns(:topic), @topic1
    assert_equal @user_sess.assigns(:posts), [@post1]

    @post2.verify
    @user_sess.get "/topics/#{@topic1.id}"
    @user_sess.assert_template "user/topics/show"
    assert_equal @user_sess.assigns(:topic), @topic1
    assert_equal @user_sess.assigns(:posts), [@post1, @post2]
  end
  
  test "DELETE /posts/:id" do
    assert_difference "Post.count" do
      @user_sess.post "/posts", {:topic_id => @topic1.id, :post => {:recipient_id => @president.id, :content => 'reply to president'}}
    end
    @post1 = @user_sess.assigns(:post)

    assert_difference "Post.count" do
      @user_sess.post "/posts", {:topic_id => @topic1.id, :post => {:recipient_id => @president.id, :content => 'reply to president'}}
    end
    @post2 = @user_sess.assigns(:post)
    
    assert_no_difference "Post.count" do
      @user_sess.delete "/posts/#{@post2.id}"
    end
    @user_sess.assert_not_found

    assert_difference "Post.count", -1 do
      @president_sess.delete "/posts/#{@post2.id}"
    end

    @post1.unverify
    assert_no_difference "Post.count" do
      @president_sess.delete "/posts/#{@post1.id}"
    end
  end

end
