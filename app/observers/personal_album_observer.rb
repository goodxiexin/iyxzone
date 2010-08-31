class PersonalAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify?
    album.auto_verify

    # inherit some attributes from owner
    album.poster_id = album.owner_id
  end

  def after_create album
    album.poster.raw_increment "albums_count#{album.privilege}"
  end

  def before_update album
    album.auto_verify
  end
  
  def after_update album
    poster = album.poster

    if album.recently_recovered?
      poster.raw_increment "albums_count#{album.privilege}"
      Photo.verify_all(:album_id => album.id)
      Album.update_all("photos_count = #{album.photos.count}", {:id => album.id})
    elsif album.recently_rejected?
      poster.raw_decrement "albums_count#{album.privilege}"
      Photo.unverify_all(:album_id => album.id)
      Album.update_all("photos_count = 0", {:id => album.id})
      album.destroy_feeds 
    end

    if album.privilege_changed?
      poster.raw_increment "albums_count#{album.privilege}"
      poster.raw_decrement "albums_count#{album.privilege_was}"
      PersonalPhoto.update_all("privilege = #{album.privilege}", {:album_id => album.id})
    end
  end

  def before_destroy album
    if !album.rejected?
      album.poster.raw_decrement "albums_count#{album.privilege}"
    end
  end

end
