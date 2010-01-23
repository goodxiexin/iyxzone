class TaggingObserver < ActiveRecord::Observer

  # 当执行这里的时候，所有的validation都已经过关了
  # 也就是说用户肯定是有权限tag的
  def before_create tagging
    # 删除已经有的tagging
    t = tagging.taggable.taggings.find_by_poster_id tagging.poster_id
    t.destroy unless t.blank?

    # 创建新tag, 如果不存在的话
    tag = Tag.find_or_create(:name => tagging.tag_name, :taggable_type => tagging.taggable_type)
    tagging.tag_id = tag.id
  end

  def after_create tagging
    tagging.tag.raw_increment :taggings_count
  end

  def after_destroy tagging
    tagging.tag.raw_decrement :taggings_count
  end

end
