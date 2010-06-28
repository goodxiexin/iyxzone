class PhotoTag < ActiveRecord::Base

	belongs_to :tagged_user, :class_name => 'User'

  belongs_to :poster, :class_name => 'User'

  belongs_to :photo

  produce_notices :relative => lambda {|tag| tag.photo_id}

  attr_readonly :poster_id, :tagged_user_id, :photo_id

  validates_presence_of :poster_id

  validate_on_create :photo_is_valid

  validate_on_create :tagged_user_is_valid 

  def is_deleteable_by? user
    photo.is_tag_deleteable_by? user, self
  end

protected

  def tagged_user_is_valid
    if tagged_user.blank?
      errors.add(:tagged_user_id, "不存在")
    elsif poster and photo and !photo.tag_candidates_for(poster).include?(tagged_user)
      errors.add(:tagged_user_id, '你没有权限标记这个人')
    end
  end

  def photo_is_valid 
    if photo.blank?
      errors.add(:photo_id, "照片不存在")
    elsif !photo.is_taggable_by? poster
      errors.add(:photo_id, '没有权限标记')
    end
  end

end
