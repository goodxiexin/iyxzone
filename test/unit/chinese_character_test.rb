require 'test_helper'

class ChineseCharacterTest < ActiveSupport::TestCase

  def setup
    Pinyin::init_db
  end

  test "parse pinyin" do
    assert_equal Pinyin::parse('草泥马'), 'caonima'
    assert_equal Pinyin::parse('春哥'), 'chunge' 
    assert_equal Pinyin::parse('adsf'), 'adsf'
    assert_equal Pinyin::parse('春哥是sb'), 'chungeshisb'
  end

end
