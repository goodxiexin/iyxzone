class PhotoTag < ActiveRecord::Base

	belongs_to :tagged_user, :class_name => 'User'

  belongs_to :poster, :class_name => 'User'

  belongs_to :photo

	has_many :notices, :as => 'producer', :dependent => :destroy

  def is_deleteable_by? user
    photo.is_tag_deleteable_by? user, self
  end

  def validate
    if poster_id.blank?
      errors.add_to_base("没有发布者")
      return
    end
    
    if tagged_user_id.blank?
      errors.add_to_base("没有被标记的人")
      return
    elsif !poster.has_friend?(tagged_user_id) and tagged_user_id != poster_id
      errors.add_to_base("被标记的不是好友或本人")
      return
    end
    
    if photo_id.blank? or photo_type.blank?
      errors.add_to_base("没有照片")
      return
    else
      photo = Photo.find(:first, :conditions => {:id => photo_id})
      if photo.blank?
        errors.add_to_base("照片不存在")
        return
      elsif !photo.is_taggable_by? poster
        errors.add_to_base('没有权限标记')
        return
      end
    end
  end

end
