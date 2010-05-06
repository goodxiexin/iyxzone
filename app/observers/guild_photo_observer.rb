#
# 头像新鲜事和照片新鲜事不同
# 头像一次只能上传一张，所以用after_create这个callback就够了
# 一般的照片一次上传多张，很难用after_create解决
#
class GuildPhotoObserver < ActiveRecord::Observer

  def before_create photo
    return unless photo.thumbnail.blank?

    # verify
    photo.verified = 0

    # inherit some attributes from album
    album = photo.album
    photo.privilege = album.privilege
    photo.game_id = album.game_id
  end

	def after_create photo
    return unless photo.thumbnail.blank?

    # increment counter
    photo.album.raw_increment :photos_count
	end

  def before_update photo 
    return unless photo.thumbnail.blank?
    
    if photo.sensitive_columns_changed? and photo.sensitive?
      photo.verified = 0
    end
  end

  def after_update photo
    return unless photo.thumbnail.blank?

    # verify
    if photo.recently_verified_from_unverified
      photo.album.raw_increment :photos_count
    elsif photo.recently_unverified
      photo.album.raw_decrement :photos_count
    end

    # change cover
    if photo.cover
      photo.album.update_attribute(:cover_id, photo.id) if photo.album.cover_id != photo.id
    else
      photo.album.update_attribute(:cover_id, nil) if photo.album.cover_id == photo.id
    end
  end
  
  def after_destroy photo
    return unless photo.thumbnail.blank?
    
    # decrement counter
    photo.album.raw_decrement :photos_count
  
    # check if the deleted photo is cover
    album = photo.album
    if album.cover_id == photo.id
      album.update_attribute('cover_id', nil)
    end
  end   

end
