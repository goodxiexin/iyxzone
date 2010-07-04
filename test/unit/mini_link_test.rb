require 'test_helper'

class MiniLinkTest < ActiveSupport::TestCase

  def setup
  end

  test "uniqueness" do
    assert_no_difference "MiniLink.count" do
      MiniLink.create :url => nil
    end

    assert_difference "MiniLink.count" do
      MiniLink.create :url => 'http://www.baidu.com'
    end

    assert_no_difference "MiniLink.count" do
      MiniLink.create :url => 'http://www.baidu.com'
    end

    @topic = MiniLink.find_by_url 'http://www.baidu.com'
    assert_not_nil @topic
    assert_equal @topic.proxy_url, "#{SITE_URL}/links/#{@topic.compressed_id}"
  end

  test "video link" do
    @link = MiniLink.new :url => 'http://v.youku.com/v_show/id_XMTY3NDE5Nzg4.html'
    assert @link.save
    assert_not_nil @link.embed_html
    assert_not_nil @link.thumbnail_url
    assert @link.is_video? 
  end

end
