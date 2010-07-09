require 'test_helper'

class MiniBlogTest < ActiveSupport::TestCase

  def setup
    @me = UserFactory.create
    @someone = UserFactory.create
    @another = UserFactory.create
    Role.create :name => 'game_admin'
  end

  test "validation" do
    @mb = MiniBlog.new :poster => @me, :content => nil
    assert !@mb.save

    @mb = MiniBlog.new :poster => @me, :content => 'haha'
    assert @mb.save

    @mb = MiniBlog.new :poster => @me, :content => 'a' * 141
    assert !@mb.save

    # 空格,tab会被转成一个空格
    @mb = MiniBlog.new :poster => @me, :content => 'a   ' * 70
    assert @mb.save
  end

  test "creat text mini blog" do
    @mb = MiniBlog.create :poster => @me, :content => '简单的文本微波'
    assert @mb.text_type?

    assert_difference "MiniTopic.count" do
      @mb = MiniBlog.create :poster => @me, :content => '#简单的文本微波#'
    end
    assert @mb.text_type?

    assert_difference "MiniTopic.count", 3 do
      @mb = MiniBlog.create :poster => @me, :content => '#t1# #t2# #t3# #t1#'
    end
    @t1 = MiniTopic.find_by_name 't1'
    @t2 = MiniTopic.find_by_name 't2'
    @t3 = MiniTopic.find_by_name 't3'
    assert @mb.text_type?
    assert_equal @mb.mini_topics, [@t1, @t2, @t3, @t1]

    @mb = MiniBlog.create :poster => @me, :content => "@#{@someone.login} @#{@another.login} @#{@someone.login}"
    assert @mb.text_type?
    assert_equal @mb.relative_users, [@someone, @another, @someone]
  end

  test "create video mini blog" do
    assert_difference "MiniLink.count" do
      @mb = MiniBlog.create :poster => @me, :content => 'http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html'
    end
    @link = MiniLink.last
    assert_equal @mb.videos_count, 1
    assert @mb.video_type?
    
    assert_no_difference "MiniLink.count" do
      @mb = MiniBlog.create :poster => @me, :content => "#{@link.proxy_url} http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html"
    end
    assert_equal @mb.videos_count, 2
    assert @mb.video_type?
    assert_equal @mb.mini_videos, [@link, @link]
  end

  test "create image mini blog" do
    @image = PhotoFactory.create :type => 'MiniImage'
    @mb = MiniBlog.create :poster => @me, :content => 'a', :mini_image => @image
    assert_equal @image.reload.mini_blog_id, @mb.id
    assert_equal @mb.mini_image, @image
    assert_equal @mb.reload.images_count, 1
    assert @mb.image_type?
  end

  test "complicate mini blog" do
    @image = PhotoFactory.create :type => 'MiniImage'
    assert_difference "MiniTopic.count" do
      assert_difference "MiniLink.count" do
        @mb = MiniBlog.create :poster => @me, :content => 'http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html #好片#', :mini_image => @image
      end
    end
    assert_equal @image.reload.mini_blog_id, @mb.id
    assert_equal @mb.reload.images_count, 1
    assert_equal @mb.videos_count, 1
    assert !@mb.text_type? 
    assert @mb.video_type?
    assert @mb.image_type?
  end

  #
  # 建立这样的forward
  # 1 => {2,3}表示2,3转发自1
  # 1 => { 2 => {4 => {6, 7}, 5}, 3}
  #
  test "forward" do
    @b1 = MiniBlog.create :poster => @me, :content => '1'
    
    assert_difference "MiniBlog.count" do
      @b2 = @b1.forward @someone, '2'
    end
    assert_equal @b1.reload.forwards_count, 1

    assert_difference "MiniBlog.count" do
      @b3 = @b1.forward @another, '3'
    end
    assert_equal @b1.reload.forwards_count, 2

    assert_difference "MiniBlog.count" do
      @b4 = @b2.forward @someone, '4'
    end
    assert_equal @b1.reload.forwards_count, 3
    assert_equal @b2.reload.forwards_count, 1

    assert_difference "MiniBlog.count" do
      @b5 = @b2.forward @someone, '5'
    end
    assert_equal @b1.reload.forwards_count, 4
    assert_equal @b2.reload.forwards_count, 2

    assert_difference "MiniBlog.count" do
      @b6 = @b4.forward @someone, '6'
    end
    assert_equal @b1.reload.forwards_count, 5
    assert_equal @b2.reload.forwards_count, 2
    assert_equal @b4.reload.forwards_count, 1

    assert_difference "MiniBlog.count" do
      @b7 = @b4.forward @someone, '7'
    end
    assert_equal @b1.reload.forwards_count, 6
    assert_equal @b2.reload.forwards_count, 2
    assert_equal @b4.reload.forwards_count, 2

    assert @b1.original?
    [@b2, @b3, @b4, @b5, @b6, @b7].each do |b|
      assert !b.original?
    end

    # 删除一个叶子节点
    @b7.destroy
    assert_equal @b1.reload.forwards_count, 5
    assert_equal @b2.reload.forwards_count, 2
    assert_equal @b4.reload.forwards_count, 1

    # 删除一个中间节点
    @b4.destroy
    assert_equal @b6.reload.parent, @b1
    assert_equal @b1.reload.forwards_count, 4
    assert_equal @b2.reload.forwards_count, 1

    # 删除跟节点的一个孩子
    @b3.destroy
    assert_equal @b1.reload.forwards_count, 3

    # 删除根节点, 由于forwards_count不为0，要假删除
    @b1.destroy
    assert_not_nil @b1
    assert @b1.deleted
    assert_equal @b2.reload.parent, @b1
    assert_equal @b5.reload.parent, @b2
    assert_equal @b6.reload.parent, @b1
    assert_equal @b1.reload.forwards_count, 3
    assert_equal @b2.reload.forwards_count, 1

    # 再删除b2
    @b2.destroy
    assert_equal @b1.reload.forwards_count, 2
    assert_equal @b5.reload.parent, @b1
  end

  test "category" do
    @image1 = PhotoFactory.create :type => 'MiniImage'
    @image2 = PhotoFactory.create :type => 'MiniImage'
    @b1 = MiniBlog.create :poster => @me, :content => 'text'
    sleep 1
    @b2 = MiniBlog.create :poster => @me, :content => '#topic#', :mini_image => @image1
    sleep 1
    @b3 = @b1.forward @me, "@#{@me.login}"
    sleep 1
    @b4 = MiniBlog.create :poster => @me, :content => "http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html"
    sleep 1
    @b5 = MiniBlog.create :poster => @me, :content => "http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html", :mini_image => @image2
    
    assert_equal MiniBlog.category('all'), [@b5, @b4, @b3, @b2, @b1]
    assert_equal MiniBlog.category('original'), [@b5, @b4, @b2, @b1]
    assert_equal MiniBlog.category('text'), [@b3, @b1]
    assert_equal MiniBlog.category('image'), [@b5, @b2]
    assert_equal MiniBlog.category('video'), [@b5, @b4]
  end

  test "comment" do
    @mb = MiniBlog.create :poster => @me, :content => 'text'
    [@me, @someone, @another].each do |u|
      assert @mb.is_commentable_by?(u)
    end
  end

  test "interested mini blogs" do
    @someone.followed_by @me
    @another.followed_by @me

    @image1 = PhotoFactory.create :type => 'MiniImage'
    @image2 = PhotoFactory.create :type => 'MiniImage'
    @b1 = MiniBlog.create :poster => @someone, :content => 'text'
    sleep 1
    @b2 = MiniBlog.create :poster => @someone, :content => '#topic#', :mini_image => @image1
    sleep 1
    @b3 = @b1.forward @another, "@#{@me.login}"
    sleep 1
    @b4 = MiniBlog.create :poster => @another, :content => "http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html"
    sleep 1
    @b5 = MiniBlog.create :poster => @another, :content => "http://v.youku.com/v_show/id_XMTg1NjgwMTg0.html", :mini_image => @image2
    
    assert_equal @me.interested_mini_blogs, [@b5, @b4, @b3, @b2, @b1]
    assert_equal @me.interested_mini_blogs('original'), [@b5, @b4, @b2, @b1]
    assert_equal @me.interested_mini_blogs('text'), [@b3, @b1]
    assert_equal @me.interested_mini_blogs('image'), [@b5, @b2]
    assert_equal @me.interested_mini_blogs('video'), [@b5, @b4]    
  end

end
