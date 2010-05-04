#
# 头像新鲜事和照片新鲜事不同
# 头像一次只能上传一张，所以用after_create这个callback就够了
# 一般的照片一次上传多张，很难用after_create解决
#
class EventPhotoObserver < ActiveRecord::Observer

  def before_save photo
    return unless photo.thumbnail.blank?

    # verify
    photo.verified = 1 

    # inherit some attributes from album
    album = photo.album
    photo.poster_id = album.poster_id
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
    if photo.verified_changed?
      if photo.verified_was == 2 and photo.verified == 1
        photo.album.raw_increment :photos_count
      end
      if (photo.verified_was == 0 or photo.verified_was == 1) and photo.verified == 2
        photo.album.raw_decrement :photos_count
      end
      return
    end

    # change cover if necessary 
    if photo.cover
      photo.album.update_attribute(:cover_id, photo.id) if photo.album.cover_id != photo.id
    else
      photo.album.update_attribute(:cover_id, nil) if photo.album.cover_id == photo.id
    end
  end
  
  def after_destroy photo
    return unless photo.thumbnail.blank?

    # decrement counter
    if photo.verified != 2
      photo.album.raw_decrement :photos_count
    end

    # check if the deleted photo is cover
    album = photo.album
    if album.cover_id == photo.id
      album.update_attribute('cover_id', nil)
    end
  end   

end
