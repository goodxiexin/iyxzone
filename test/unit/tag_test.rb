require 'test_helper'

class TagTest < ActiveSupport::TestCase

  test "名字的限定" do
		# 不能为空
    tag1 = Tag.new(:name => nil)
    assert !tag1.save

		# 不能少于1个字节
		tag5 = Tag.new(:name => '', :taggable_type => 'Game')
		assert !tag5.save

		# 不能多于15个字符
		tag6 = Tag.new(:name => '0123456789abcdef', :taggable_type => 'Game')
		assert !tag6.save

		# 测试能有15个字符
		tag7 = Tag.new(:name => '0123456789abcde', :taggable_type => 'Game')
		assert tag7.save

		# 测试能有30个字节
		tag8 = Tag.new(:name => '一而三四物流七八就是', :taggable_type => 'Game')
		assert tag8.save

		# 不能多余30个字节
		tag9 = Tag.new(:name => '一而三四物流七八就是.', :taggable_type => 'Game')
		assert !tag9.save

		# 名字不能重复
    tag3 = Tag.create(:name => '123', :taggable_type => 'Game')
    tag4 = Tag.new(:name => '123', :taggable_type => 'Game')
    assert !tag4.save
  end

  test "类型的限定" do
    tag2 = Tag.new(:name => '123', :taggable_type => nil)
    assert !tag2.save
  end

end
