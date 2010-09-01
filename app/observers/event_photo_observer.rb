#
# 头像新鲜事和照片新鲜事不同
# 头像一次只能上传一张，所以用after_create这个callback就够了
# 一般的照片一次上传多张，很难用after_create解决
#
class EventPhotoObserver < ActiveRecord::Observer

  def before_create photo
    return unless photo.thumbnail.blank?

    # verify
    photo.needs_verify

    # inherit some attributes from album
    photo.poster_id = photo.album.poster_id
    photo.privilege = photo.album.privilege
  end

	def after_create photo
    return unless photo.thumbnail.blank?

    album = photo.album

    # increment counter
    album.raw_increment :photos_count

    # set cover if necessary
    if photo.recently_set_cover?
      album.set_cover photo
    end

    photo.clear_cover_action
	end

  def before_update photo 
    return unless photo.thumbnail.blank?
    
    photo.auto_verify
  end

  def after_update photo
    return unless photo.thumbnail.blank?
    
    album = photo.album   

    # verify
    if photo.recently_recovered?
      album.raw_increment :photos_count
    elsif photo.recently_rejected?
      album.raw_decrement :photos_count
    end
    
    # change cover if necessary 
    if photo.recently_set_cover?
      album.set_cover photo
    elsif photo.recently_unset_cover?
      album.set_cover nil if album.cover_id == photo.id
    end
  end
  
  def after_destroy photo
    return unless photo.thumbnail.blank?

    # decrement counter
    if !photo.rejected?
      photo.album.raw_decrement :photos_count
    end

    # check if the deleted photo is cover
    album = photo.album
    if album.cover_id == photo.id
      album.update_attribute('cover_id', nil)
    end
  end   

end
