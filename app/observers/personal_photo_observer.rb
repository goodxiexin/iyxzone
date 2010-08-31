class PersonalPhotoObserver < ActiveRecord::Observer

  def before_create photo
    return unless photo.thumbnail.blank?
 
    # verify?
    photo.needs_verify # 总是需要验证的

    # inherit some attributes from album 
    photo.poster_id = photo.album.poster_id
    photo.privilege = photo.album.privilege
  end

  def after_create photo
    return unless photo.thumbnail.blank?

    album = photo.album

    # check if photo is cover
    if photo.recently_set_cover?
      album.set_cover photo
    end
    
    # increment counter
    album.raw_increment :photos_count
  
    photo.clear_cover_action
  end

  def before_update photo
    return unless photo.thumbnail.blank?

    photo.auto_verify 
  end
 
  def after_update photo
    return unless photo.thumbnail.blank?

    album = photo.album(true) # 

    # verify
    if photo.recently_recovered?
      album.raw_increment :photos_count
    elsif photo.recently_rejected?
      album.raw_decrement :photos_count
    end

    if photo.album_id_changed?
      poster = album.poster
      old_album = poster.albums.find(photo.album_id_was)
     
      # change counter 
      old_album.raw_decrement :photos_count
      album.raw_increment :photos_count
      
      # change cover
      if photo.recently_set_cover?
        album.set_cover photo
      end
      old_album.set_cover nil if old_album.cover_id == photo.id
    else
      if photo.recently_set_cover?
        album.set_cover photo
      elsif photo.recently_unset_cover?
        album.set_cover nil if album.cover_id == photo.id
      end
    end

    photo.clear_cover_action
  end

  def after_destroy photo
    return unless photo.thumbnail.blank? 

    # decrement counter
    if !photo.rejected?
      photo.album.raw_decrement :photos_count
    end

    # check if the deleted photo is cover
    if photo.is_cover?
      photo.album.update_attribute('cover_id', nil)
    end
  end

end
