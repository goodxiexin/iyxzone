class Dig < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :diggable, :polymorphic => true

  def validate_on_create
    if poster_id.blank?
      errors.add_to_base("没有发布者")
      return
    end

    if diggable_id.blank? or diggable_type.blank?
      errors.add_to_base("没有被挖的资源")
      return
    else
      diggable = diggable_type.constantize.find(:first, :conditions => {:id => diggable_id})
      if diggable.blank?
        errors.add_to_base("被挖的资源不存在")
        return
      elsif diggable.digged_by? poster
        errors.add_to_base('已经挖过了')
        return
      elsif !diggable.is_diggable_by? poster
        errors.add_to_base('没有权限挖')
        return
      end
    end
  end

end
