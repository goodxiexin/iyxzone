require 'test_helper'

class MiniBlogTest < ActiveSupport::TestCase

  def setup
    @me = UserFactory.create
    @someone = UserFactory.create
    @another = UserFactory.create
  end

  test "validation" do
    @mb = MiniBlog.new :poster => @me, :content => nil
    assert !@mb.save

    @mb = MiniBlog.new :poster => @me, :content => 'haha'
    assert @mb.save

    @mb = MiniBlog.new :poster => @me, :content => 'a' * 141
    assert !@mb.save
  end

  test "create text mini-blog" do
    # no topic
    @mb = MiniBlog.new :poster => @me, :content => 'content'
    assert @mb.save
  
    # one topic
    assert_difference "MiniTopic.count" do
      @mb = MiniBlog.create :poster => @me, :content => '#topic1#haha'
    end
    @topic1 = MiniTopic.find_by_name 'topic1'
    assert_not_nil @topic1
    assert_equal @mb.mini_topics, [@topic1]

    # two topics
    assert_difference "MiniTopic.count" do
      @mb = MiniBlog.create :poster => @me, :content => '#topic1#next#topic2#'
    end
    @topic2 = MiniTopic.find_by_name 'topic2'
    assert_not_nil @topic2
    assert_equal @mb.mini_topics, [@topic1, @topic2]

    # four topics
    assert_no_difference "MiniTopic.count" do
      @mb = MiniBlog.create :poster => @me, :content => '#topic2#next#topic1#next#topic2#next#topic1#'
    end
    assert_equal @mb.mini_topics, [@topic2, @topic1]
  end

  test "create image mini-blog" do
    @image = PhotoFactory.create :poster_id => @me.id, :type => 'MiniImage'
    @mb = MiniBlog.new :poster => @me, :content => '#good picture# have a look', :mini_image_id => @image.id
    assert @mb.save
    assert @mb.image_type?
    assert_equal @image.reload.mini_blog, @mb
    assert_equal @mb.images_count, 1
  end

  test "create video mini-blog" do
    # normal link
    assert_difference "MiniLink.count" do
      @mb = MiniBlog.create :poster => @me, :content => '#link1#http://www.baidu.com'
    end
    @link1 = MiniLink.find_by_url 'http://www.baidu.com'
    assert_not_nil @link1
    assert !@link1.is_video?
    assert_equal @mb.mini_links, [@link1]

    # multiple normal link
    assert_difference "MiniLink.count", 2 do
      @mb = MiniBlog.create :poster => @me, :content => '#link1#http://www.baidu.com#link2#http://www.google.com#link3#http://www.bin.com'
    end
    @link2 = MiniLink.find_by_url 'http://www.google.com'
    @link3 = MiniLink.find_by_url 'http://www.bin.com'
    assert_not_nil @link2
    assert_not_nil @link3
    assert !@link2.is_video?
    assert !@link3.is_video?
    assert_equal @mb.mini_links, [@link1, @link2, @link3]

    assert_difference "MiniLink.count" do
      @mb= MiniBlog.create :poster => @me, :content => '#link4#http://www.dm5.com#link4#http://www.dm5.com'
    end
    @link4 = MiniLink.find_by_url 'http://www.dm5.com'
    assert_not_nil @link4
    assert !@link4.is_video?
    assert_equal @mb.mini_links, [@link4]

    # some valid proxy url
    assert_no_difference "MiniLink.count" do
      @mb = MiniBlog.create :poster => @me, :content => "#{@link1.proxy_url} next #{@link2.proxy_url} next #{@link1.proxy_url}"
    end
    assert_equal @mb.mini_links, [@link1, @link2]

    # some invalid proxy url
    assert_no_difference "MiniLink.count" do
      @mb = MiniBlog.create :poster => @me, :content => "#{@link1.proxy_url} next #{SITE_URL}/links/FFFFFF"
    end
    assert_equal @mb.mini_links, [@link1]

    # video link
    assert_difference "MiniLink.count" do
      @mb = MiniBlog.create :poster => @me, :content => "#video1#http://v.youku.com/v_show/id_XMTg1MjI5Mzg0.html"
    end
    @video1 = MiniLink.find_by_url 'http://v.youku.com/v_show/id_XMTg1MjI5Mzg0.html'
    assert_not_nil @video1
    assert @video1.is_video?
    assert_equal @mb.mini_videos, [@video1]

    # multiple video link
    assert_difference "MiniLink.count" do
      @mb = MiniBlog.create :poster => @me, :content => "#video1#http://v.youku.com/v_show/id_XMTg1MjI5Mzg0.html#video2#http://v.youku.com/v_show/id_XMTg1MzAwOTI4.html"
    end
    @video2 = MiniLink.find_by_url 'http://v.youku.com/v_show/id_XMTg1MzAwOTI4.html'
    assert_not_nil @video2
    assert @video2.is_video?
    assert_equal @mb.mini_videos, [@video1, @video2]

    # some valid proxy url
    assert_no_difference "MiniLink.count" do
      @mb = MiniBlog.create :poster => @me, :content => "#video1##{@video1.proxy_url}#video2##{@video2.proxy_url}"
    end
    assert_equal @mb.mini_videos, [@video1, @video2]
   
    # some invalid proxy url
    assert_no_difference "MiniLink.count" do
      @mb = MiniBlog.create :poster => @me, :content => "#video1##{@video1.proxy_url}#invalid video##{SITE_URL}/links/FFFFFF"
    end
    assert_equal @mb.mini_videos, [@video1]
   
    # mixed
    # 1 existing links, 1 new link, 1 new video, 1 invalid proxy url
    assert_difference "MiniLink.count", 2 do
      @mb = MiniBlog.create :poster => @me, :content => "#{@video1.proxy_url} http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html http://17gaming.com #{SITE_URL}/links/FFFFF"
    end
    @video3 = MiniLink.find_by_url 'http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html'
    assert_not_nil @video3
    assert @video3.is_video?
    @link5 = MiniLink.find_by_url 'http://17gaming.com'
    assert_not_nil @link5
    assert !@link5.is_video?
    assert_equal @mb.mini_links, [@video1, @video3, @link5]
    assert_equal @mb.mini_videos, [@video1, @video3]
  end

  test "create composite(video + image) mini-blog" do
    @image = PhotoFactory.create :type => 'MiniImage'
    assert_difference "MiniLink.count", 2 do
      @mb = MiniBlog.create :poster => @me, :content => "http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html http://www.baidu.com", :mini_image_id => @image.id
    end
    @video = MiniLink.find_by_url 'http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html'
    @link = MiniLink.find_by_url 'http://www.baidu.com'
    assert_equal @mb.mini_links, [@video, @link]
    assert_equal @mb.mini_videos, [@video]
    assert_equal @image.reload.mini_blog, @mb
    assert @mb.video_type?
    assert @mb.image_type?
    assert !@mb.text_type?
  end

  test "create mini-blog with some relative users" do
    @mb = MiniBlog.new :poster => @me, :content => "@#{@someone.login} @#{@another.login} @not_exist"
    assert @mb.save
    assert @mb.relative_users, [@someone, @another]
  end

  test "forward" do
    @mb1 = MiniBlog.create :poster => @me, :content => 'haha'
    assert_nil @mb1.initiator
    #assert_equal @mb1.poster, @me
    assert_equal @mb1.forwarders, []    

    assert_difference "MiniBlog.count" do
      @mb2 = @mb1.forward @someone, 'haha'
    end
    assert_equal @mb2.initiator, @me
    assert_equal @mb2.poster, @someone
    assert_equal @mb2.forwarders, []

    assert_difference "MiniBlog.count" do
      @mb3 = @mb1.forward @another, 'haha'
    end
    assert_equal @mb3.initiator, @me
    assert_equal @mb3.poster, @another
    assert_equal @mb3.forwarders, []
  
    assert_difference "MiniBlog.count" do
      @mb4 = @mb3.forward @someone, 'haha'
    end
    assert_equal @mb4.initiator, @me
    assert_equal @mb4.poster, @someone
    assert_equal @mb4.forwarders, [@another]

    assert_difference "MiniBlog.count" do
      @mb5 = @mb4.forward @another, 'haha'
    end
    assert_equal @mb5.initiator, @me
    assert_equal @mb5.poster, @another
    assert_equal @mb5.forwarders, [@another, @someone]

    assert_difference "MiniBlog.count" do
      @mb6 = @mb5.forward @someone, 'haha'
    end
    assert_equal @mb6.initiator, @me
    assert_equal @mb6.poster, @someone
    assert_equal @mb6.forwarders, [@another, @someone, @another]

    assert_difference "MiniBlog.count" do
      @mb7 = @mb6.forward @me, 'haha'
    end
    assert_equal @mb7.initiator, @me
    assert_equal @mb7.poster, @me
    assert_equal @mb7.forwarders, [@another, @someone, @another, @someone]

    assert_difference "MiniBlog.count" do
      @mb8 = @mb7.forward @me, 'haha'
    end
    assert_equal @mb8.initiator, @me
    assert_equal @mb8.poster, @me
    assert_equal @mb8.forwarders, [@another, @someone, @another, @someone, @me]

  end

end
