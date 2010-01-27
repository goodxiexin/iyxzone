class TaggingObserver < ActiveRecord::Observer

  def after_create tagging
    tagging.tag.raw_increment :taggings_count
  end

  def after_destroy tagging
    tagging.tag.raw_decrement :taggings_count
  end

end
