require 'test_helper'

class BlogImageTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
    @character = GameCharacterFactory.create :user_id => @user.id
    @game = @character.game
  end

  test "create blog images" do
    @image1 = PhotoFactory.create :type => 'BlogImage'
    @image2 = PhotoFactory.create :type => 'BlogImage'
    @image3 = PhotoFactory.create :type => 'BlogImage'
    @image4 = PhotoFactory.create :type => 'BlogImage'

    # 使用其中的2张图片，其中1张删除掉
    @blog = BlogFactory.create :poster_id => @user.id, :game_id => @game.id, :content => "<img src='#{@image1.public_filename}'/><img src='#{@image2.public_filename}' />"
    
    assert_equal @image1.reload.blog, @blog
    assert_equal @image2.reload.blog, @blog
    assert_nil @image3.reload.blog
    assert_equal @blog.reload.images, [@image1, @image2]

    @blog.update_attributes :content => "<img src='#{@image1.public_filename}' />"
    
    assert_equal @image1.reload.blog, @blog
    assert_nil @image2.reload.blog
    assert_nil @image3.reload.blog
    assert_equal @blog.reload.images, [@image1]
 
    @blog.update_attributes :content => "<img src='#{@image4.public_filename}' />"
    
    assert_equal @image4.reload.blog, @blog
    assert_nil @image1.reload.blog
    assert_nil @image2.reload.blog
    assert_nil @image3.reload.blog
    assert_equal @blog.reload.images, [@image4] 

    assert_difference "BlogImage.count", -3 do
      BlogImage.delete_all :blog_id => nil
    end
  end

end
