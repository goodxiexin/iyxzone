class MiniBlogObserver < ActiveRecord::Observer

  def after_create mini_blog
    root = mini_blog.root
    parent = mini_blog.parent

    root.raw_increment :forwards_count if root
    parent.raw_increment :forwards_count if parent and root != parent
  end

  def before_destroy mini_blog
    root = mini_blog.root
    parent = mini_blog.parent

    # change counter
    root.raw_decrement :forwards_count if root
    parent.raw_decrement :forwards_count if parent and root != parent

    if !mini_blog.children.blank?
      MiniBlog.update_all("parent_id = #{mini_blog.root_id}", {:parent_id => mini_blog.id})
    end
  end

end
