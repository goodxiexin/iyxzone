class PersonalPhotoObserver < ActiveRecord::Observer

  def before_create photo
    return unless photo.thumbnail.blank?
 
    # verify?
    photo.needs_verify # 总是需要验证的

    # inherit some attributes from album 
    album = photo.album
    photo.privilege = album.privilege
    photo.poster_id = album.poster_id
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
      photo.needs_verify
    end
  end
 
  def after_update photo
    return unless photo.thumbnail.blank?
   
    # verify
    if photo.recently_recovered
      photo.album.raw_decrement :photos_count
    elsif photo.recently_unverified
      photo.album.raw_increment :photos_count
    end

    # change cover 
    if photo.album_id_changed?
      # if photo is moved to another album, change counter and change cover if necessary
      from = PersonalAlbum.find(photo.album_id_was)
      to = PersonalAlbum.find(photo.album_id)
      from.raw_decrement :photos_count
      to.raw_increment :photos_count
      if photo.cover
        to.update_attribute(:cover_id, photo.id)
        if from.cover_id == photo.id
          from.update_attribute(:cover_id, nil)
        end
      end
    else
      # if photo is not moved anywhere
      if photo.cover
        photo.album.update_attribute(:cover_id, photo.id) if photo.album.cover_id != photo.id
      else
        photo.album.update_attribute(:cover_id, nil) if photo.album.cover_id == photo.id
      end
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
