require 'test_helper'

class MiniBlogTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
  end
  
  test "create invalid mini blog" do
    @mini_blog = MiniBlog.new :poster => nil, :content => 'c', :category => MiniBlog::Category[0]
    assert !@mini_blog.save

    @mini_blog = MiniBlog.new :poster => @user, :content => nil, :category => MiniBlog::Category[0]
    assert !@mini_blog.save

    @mini_blog = MiniBlog.new :poster => @user, :content => 'c' * 141, :category => MiniBlog::Category[0]
    assert !@mini_blog.save

    @mini_blog = MiniBlog.new :poster => @user, :content => 'c', :category => nil
    assert !@mini_blog.save    
  end

  test "create simple mini blog" do
    @mini_blog = MiniBlog.new :poster => @user, :content => 'content', :category => MiniBlog::Category[0]
    assert @mini_blog.save
    assert_equal @mini_blog.poster, @user
  end

  test "create mini blog with topics" do
    @mini_blog = MiniBlog.new :poster => @user, :content => '#topic1#', :category => MiniBlog::Category[0]
    assert @mini_blog.save
    assert_equal @mini_blog.poster, @user
    @topic = MiniTopic.find_by_name('topic1')
    assert_not_nil @topic
    assert_equal @mini_blog.mini_topics, [@topic] 
  end

  test "create mini blog with multiple topics" do
    @mini_blog = MiniBlog.new :poster => @user, :content => '##topic1#####topic2###topic3##topic4', :category => MiniBlog::Category[0]
    assert @mini_blog.save
    assert_equal @mini_blog.poster, @user
    @topic1 = MiniTopic.find_by_name('topic1')
    @topic2 = MiniTopic.find_by_name('topic2')
    @topic3 = MiniTopic.find_by_name('topic3')
    @topic4 = MiniTopic.find_by_name('topic4')
    assert_not_nil @topic1
    assert_not_nil @topic2
    assert_not_nil @topic3
    assert_nil @topic4    
    puts @mini_blog.reload.mini_blog_topics.count
    assert_equal @mini_blog.mini_topics, [@topic1, @topic2, @topic3]
  end

  test "create picture mini blog" do
    @mini_image = PhotoFactory.create :type => 'MiniImage'
    @mini_blog = MiniBlog.new :poster => @user, :content => '#好图#', :category => MiniBlog::Category[1], :mini_image_id => @mini_image.id
    assert @mini_blog.save
    assert_equal @mini_blog.mini_image, @mini_image
    assert_equal @mini_image.reload.mini_blog, @mini_blog
  end

  test "create video mini blog" do
    @mini_video = MiniVideo.new :video_url => 'http://v.youku.com/v_show/id_XMTg1MzY0Njcy.html'
    assert @mini_video.save
    @mini_blog = MiniBlog.new :poster => @user, :content => '#好片#', :category => MiniBlog::Category[2], :mini_video_id => @mini_video.id
    assert @mini_blog.save
    assert_equal @mini_blog.mini_video, @mini_video
    assert_equal @mini_video.reload.mini_blog, @mini_blog
  end

  test "create mini blog containing one simple link" do
    assert_difference "MiniLink.count" do
      @mini_blog = MiniBlog.create :poster => @user, :content => 'http://www.baidu.com', :category => MiniBlog::Category[0]
    end
    @mini_link = MiniLink.find_by_url('http://www.baidu.com')
    assert_equal @mini_blog.content, "http://17gaming.com/links/#{@mini_link.compressed_id}"

    assert_difference "MiniLink.count" do
      @mini_blog = MiniBlog.create :poster => @user, :content => 'http://www.baidu.comsometext', :category => MiniBlog::Category[0]
    end
    @mini_link = MiniLink.find_by_url('http://www.baidu.comsometext')
    assert_equal @mini_blog.content, "http://17gaming.com/links/#{@mini_link.compressed_id}"
 
    assert_no_difference "MiniLink.count" do 
      @mini_blog = MiniBlog.create :poster => @user, :content => 'http://www.baidu.com空开', :category => MiniBlog::Category[0]
    end
    @mini_link = MiniLink.find_by_url('http://www.baidu.com')
    assert_equal @mini_blog.content, "http://17gaming.com/links/#{@mini_link.compressed_id}空开"
  end

  test "comment mini blog containing links" do
    assert_difference "MiniLink.count", 3 do
      @mini_blog = MiniBlog.create :poster => @user, :content => 'http://www.baidu.com空开http://www.google.com空开http://www.dm_5.com', :category => MiniBlog::Category[0]
    end
    @link1 = MiniLink.find_by_url 'http://www.baidu.com'
    @link2 = MiniLink.find_by_url 'http://www.google.com'
    @link3 = MiniLink.find_by_url 'http://www.dm_5.com'
    assert_not_nil @link1
    assert_not_nil @link2
    assert_not_nil @link3
    assert_equal @mini_blog.content, "http://17gaming.com/links/#{@link1.compressed_id}空开http://17gaming.com/links/#{@link2.compressed_id}空开http://17gaming.com/links/#{@link3.compressed_id}"
  end

  test "forward mini blog" do
    @user1 = UserFactory.create
    @user2 = UserFactory.create
    @user3 = UserFactory.create
    @user4 = UserFactory.create

    @mini_blog = MiniBlog.create :poster => @user, :content => '#好图#', :category => MiniBlog::Category[0]
    @mini_blog1 = @mini_blog.forward @user1, "forward user's mini blog"
    assert_equal @mini_blog1.forwarders, []
    assert_equal @mini_blog1.initiator, @user
    assert_equal @mini_blog1.poster, @user1
    assert_equal @mini_blog.reload.forwards_count, 1
    assert_equal @mini_blog1.reload.forwards_count, 0
    
    @mini_blog2 = @mini_blog1.forward @user2, "forward user1's mini blog"
    assert_equal @mini_blog2.forwarders, [@user1]
    assert_equal @mini_blog2.initiator, @user
    assert_equal @mini_blog2.poster, @user2
    assert_equal @mini_blog.reload.forwards_count, 1
    assert_equal @mini_blog1.reload.forwards_count, 1
    assert_equal @mini_blog2.reload.forwards_count, 0
    
    @mini_blog3 = @mini_blog2.forward @user3, "forward user2's mini blog"
    assert_equal @mini_blog3.forwarders, [@user1, @user2]
    assert_equal @mini_blog3.initiator, @user
    assert_equal @mini_blog3.poster, @user3
    assert_equal @mini_blog.reload.forwards_count, 1
    assert_equal @mini_blog1.reload.forwards_count, 1
    assert_equal @mini_blog2.reload.forwards_count, 1
    assert_equal @mini_blog3.reload.forwards_count, 0
    
    @mini_blog4 = @mini_blog3.forward @user4, "forward user3's mini blog"
    assert_equal @mini_blog4.forwarders, [@user1, @user2, @user3]
    assert_equal @mini_blog4.initiator, @user
    assert_equal @mini_blog4.poster, @user4
    assert_equal @mini_blog.reload.forwards_count, 1
    assert_equal @mini_blog1.reload.forwards_count, 1
    assert_equal @mini_blog2.reload.forwards_count, 1
    assert_equal @mini_blog3.reload.forwards_count, 1
    assert_equal @mini_blog4.reload.forwards_count, 0
  end

  test "user's mini blog list" do
    @text1 = MiniBlogFactory.create_text :poster => @user
    sleep 1
    @text2 = MiniBlogFactory.create_text :poster => @user    
    sleep 1
    @image1 = MiniBlogFactory.create_image :poster => @user
    sleep 1
    @image2 = MiniBlogFactory.create_image :poster => @user
    sleep 1
    @video1 = MiniBlogFactory.create_video :poster => @user
    sleep 1
    @video2 = MiniBlogFactory.create_video :poster => @user
  
    @user.reload
    assert_equal @user.mini_blogs, [@video2, @video1, @image2, @image1, @text2, @text1]
    assert_equal @user.mini_blogs.category('text'), [@text2, @text1]
    assert_equal @user.mini_blogs.category('image'), [@image2, @image1]
    assert_equal @user.mini_blogs.category('video'), [@video2, @video1]
  end
  
  test "users's follows" do
    @one_user = UserFactory.create
    @one_user.followed_by @user
    @another_user = UserFactory.create
    @another_user.followed_by @user
    
    @text1 = MiniBlogFactory.create_text :poster => @one_user
    sleep 1
    @text2 = MiniBlogFactory.create_text :poster => @another_user    
    sleep 1
    @image1 = MiniBlogFactory.create_image :poster => @one_user
    sleep 1
    @image2 = MiniBlogFactory.create_image :poster => @another_user
    sleep 1
    @video1 = MiniBlogFactory.create_video :poster => @one_user
    sleep 1
    @video2 = MiniBlogFactory.create_video :poster => @another_user    
  
    assert_equal @user.follows, [@video2, @video1, @image2, @image1, @text2, @text1]
    assert_equal @user.follows('text'), [@text2, @text1]
    assert_equal @user.follows('image'), [@image2, @image1]
    assert_equal @user.follows('video'), [@video2, @video1]
  end

end
