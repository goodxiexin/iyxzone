class PhotoTag < ActiveRecord::Base

	belongs_to :tagged_user, :class_name => 'User'

  belongs_to :poster, :class_name => 'User'

  belongs_to :photo

  produce_notices :relative => lambda {|tag| tag.photo_id}

  attr_readonly :poster_id, :tagged_user_id, :photo_id

  #needs_verification

  validates_presence_of :poster_id, :message => "不能为空"

  validates_presence_of :photo_id, :message => "不能为空"

  validate_on_create :photo_is_valid

  validates_presence_of :tagged_user_id, :message => "不能为空"

  validate_on_create :tagged_user_is_valid 

  def is_deleteable_by? user
    photo.is_tag_deleteable_by? user, self
  end

protected

  def tagged_user_is_valid
    return if tagged_user.blank? or poster.blank? or photo.blank?

    errors.add(:tagged_user_id, '你没有权限标记这个人') unless photo.tag_candidates_for(poster).include?(tagged_user)
  end

  def photo_is_valid 
    return if photo_id.blank? or photo_type.blank?
      
    if photo.blank?
      errors.add(:photo_id, "照片不存在")
    elsif photo.rejected? or photo.album.rejected?
      errors.add(:photo_id, "已经被和谐了")
    elsif !photo.is_taggable_by? poster
      errors.add(:photo_id, '没有权限标记')
    end
  end

end
