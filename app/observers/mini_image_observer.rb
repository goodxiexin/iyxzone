class MiniImageObserver < ActiveRecord::Observer

  def after_create mini_image
    return unless mini_image.thumbnail.blank?
    
    if mini_image.mini_blog
      mini_image.mini_blog.raw_increment :images_count
    end
  end

  def after_update mini_image
    return unless mini_image.thumbnail.blank?

    if mini_image.mini_blog_id_changed?
      MiniBlog.update_all("images_count = images_count + 1", {:id => mini_image.mini_blog_id})
      MiniBlog.update_all("images_count = images_count - 1", {:id => mini_image.mini_blog_id_was})
    end
  end

  def after_destroy mini_image
    return unless mini_image.thumbnail.blank?
    
    if mini_image.mini_blog
      mini_image.mini_blog.raw_decrement :images_count
    end
  end
  
end
