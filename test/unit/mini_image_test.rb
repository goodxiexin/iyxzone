require 'test_helper'

class MiniImageTest < ActiveSupport::TestCase

  def setup
    @me = UserFactory.create
    @mini_blog1 = MiniBlog.create :poster => @me, :content => 'text'  
    @mini_blog2 = MiniBlog.create :poster => @me, :content => 'text'
  end

  test "counter" do
    @image = PhotoFactory.create :type => 'MiniImage', :mini_blog_id => @mini_blog2.id
    assert_equal @mini_blog1.reload.images_count, 0
    assert_equal @mini_blog2.reload.images_count, 1

    @image.update_attributes :mini_blog_id => @mini_blog1.id
    assert_equal @mini_blog1.reload.images_count, 1
    assert_equal @mini_blog2.reload.images_count, 0
   
    # update的observer，已经把image.mini_blog cache起来了
    # 因此delete的observer里，还会取到老的image.mini_blog，因此需要reload
    @image.reload 
    @image.destroy
    assert_equal @mini_blog1.reload.images_count, 0
    assert_equal @mini_blog2.reload.images_count, 0
  end

end
