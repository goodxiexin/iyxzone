class MiniBlogObserver < ActiveRecord::Observer

  def after_create mini_blog
    root = mini_blog.root
    parent = mini_blog.parent

    mini_blog.poster.raw_increment :mini_blogs_count
    root.raw_increment :forwards_count if root
    parent.raw_increment :forwards_count if parent and root != parent
  end

  def before_destroy mini_blog
    root = mini_blog.root
    parent = mini_blog.parent

    # change counter
    mini_blog.poster.raw_decrement :mini_blogs_count
    root.raw_decrement :forwards_count if root
    parent.raw_decrement :forwards_count if parent and root != parent

    if !mini_blog.children.blank?
      MiniBlog.update_all("parent_id = #{mini_blog.root_id}", {:parent_id => mini_blog.id})
    end
  end

end
