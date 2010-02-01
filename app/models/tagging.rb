class Tagging < ActiveRecord::Base

	belongs_to :taggable, :polymorphic => true

	belongs_to :tag#, :counter_cache => true

	belongs_to :poster, :class_name => 'User'

  attr_accessor :tag_name

  def validate
    if poster_id.blank?
      errors.add_to_base("没有发布者")
      return
    end
    
		if tag_id.blank?
      errors.add_to_base("没有标签")
      return
    elsif Tag.find(:first, :conditions => {:id => tag_id}).blank?
      errors.add_to_base("标签不存在")
      return
    end

    if taggable_id.blank? or taggable_type.blank?
      errors.add_to_base("没有被标记的资源")
      return
    else
      taggable = taggable_type.constantize.find(:first, :conditions => {:id => taggable_id})
      if taggable.blank?
        errors.add_to_base("被标记的资源不存在")
      elsif !taggable.is_taggable_by? poster
        errors.add_to_base("没有权限标记")
      end
    end
  end

end
