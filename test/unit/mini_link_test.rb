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
  end

  test "compressed id and proxy url" do
    @link = MiniLink.create :url => 'http://www.baidu.com'
    assert_equal @link.proxy_url, "#{SITE_URL}/links/#{@link.compressed_id}"
    assert_equal MiniLink.find_by_proxy_url(@link.proxy_url), @link
  end

  test "video link" do
    @link = MiniLink.new :url => 'http://v.youku.com/v_show/id_XMTY3NDE5Nzg4.html'
    assert @link.save
    assert_not_nil @link.embed_html
    assert_not_nil @link.thumbnail_url
    assert @link.is_video? 
  end

end
