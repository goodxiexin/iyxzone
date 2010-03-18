require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  test "保存日志，日志计数器加1" do
    b = BlogFactory.build
    
    assert_difference "b.poster(true).blogs_count" do
      b.save
    end
  end
  
  test "保存草稿，草稿计数器加1" do
    d = DraftFactory.build

    assert_difference "d.poster(true).drafts_count" do
      d.save
    end
  end

  test "把草稿变成日志, 草稿计数器减一，日志计数器加一" do
    d = DraftFactory.create

    assert_difference "d.poster(true).drafts_count", -1 do
      d.update_attributes(:draft => false)
    end

    d = DraftFactory.create

    assert_difference "d.poster(true).blogs_count" do
      d.update_attributes(:draft => false)
    end
  end
  
  test "删除日志，日志计数器减一" do
    b = BlogFactory.create

    assert_difference "b.poster(true).blogs_count", -1 do
      b.destroy
    end
  end
  
  test "删除草稿，草稿计数器减一" do
    d = DraftFactory.create

    assert_difference "d.poster(true).drafts_count", -1 do
      d.destroy
    end
  end
  
  test "没有作者" do
    b = BlogFactory.build(:poster_id => nil)
    b.save

    assert_not_nil b.errors.on(:poster_id)
  end

  test "没有标题" do
    b = BlogFactory.build(:title => nil)
    b.save

    assert_not_nil b.errors.on(:title)
  end

  test "没有内容" do
    b = BlogFactory.build(:content => nil)
    b.save

    assert_not_nil b.errors.on(:content)
  end
  
  test "没有游戏类别" do
    b = BlogFactory.build(:game_id => nil)
    b.save

    assert_not_nil b.errors.on(:game_id) 
  end

  test "游戏不存在" do
    b = BlogFactory.build(:game_id => 9999)
    b.save

    assert_not_nil b.errors.on(:game_id)
  end

  test "该用户没有这个游戏" do
    g = GameFactory.create
    b = BlogFactory.build(:game_id => g.id)
    b.save

    assert_not_nil b.errors.on(:game_id)
  end

  test "权限不正确" do
    b = BlogFactory.build(:privilege => 100)
    b.save

    assert_not_nil b.errors.on(:privilege)
  end

end
