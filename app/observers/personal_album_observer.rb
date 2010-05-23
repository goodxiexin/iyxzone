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
    if album.recently_recovered
      album.poster.raw_increment "albums_count#{album.privilege}"
      Photo.verify_all(:album_id => album.id)
      Album.update_all("photos_count = #{album.photos.count}", {:id => album.id})
      # 没法恢复新鲜事，因为根部没记录照片是分几次，怎么上传的
    elsif album.recently_rejected
      album.poster.raw_decrement "albums_count#{album.privilege}"
      Photo.unverify_all(:album_id => album.id)
      Album.update_all("photos_count = 0", {:id => album.id})
      album.destroy_feeds 
    end

    if album.privilege_changed?
      album.poster.raw_increment "albums_count#{album.privilege}"
      album.poster.raw_decrement "albums_count#{album.privilege_was}"
      # 这样的好处不仅在于一条sql，还让所有的该相册中的被屏蔽的照片也更新了，这样下次这些被屏蔽的照片恢复的时候，privilege还是和album保持一致
      PersonalPhoto.update_all("privilege = #{album.privilege}", {:album_id => album.id})
    end
  end

  def before_destroy album
    if !album.rejected?
      album.poster.raw_decrement "albums_count#{album.privilege}"
    end
  end

end
