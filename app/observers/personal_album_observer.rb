#
# 个人的相册是有权限设置的，如果相册的权限改变，所有相片的权限也改变
#
class PersonalAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify?
    if album.sensitive?
      album.verified = 0
    else
      album.verified = 1
    end

    album.poster_id = album.owner_id
  end

  def after_create album
    album.poster.raw_increment "albums_count#{album.privilege}"
  end

  def before_update album
    if album.sensitive_columns_changed? and album.sensitive?
      album.verified = 0
    end
  end
  
  def after_update album
    if album.verified_changed?
      if album.verified_was == 2 and album.verified == 1
        album.poster.raw_increment "albums_count#{album.privilege}"
      elsif (album.verified_was == 0 or album.verified_was == 1) and album.verified == 2
        album.poster.raw_decrement "albums_count#{album.privilege}"
      end
      return
    end

    if album.privilege_changed?
      album.poster.raw_increment "albums_count#{album.privilege}"
      album.poster.raw_decrement "albums_count#{album.privilege_was}"
      # 这样的好处不仅在于一条sql，还让所有的该相册中的被屏蔽的照片也更新了，这样下次这些被屏蔽的照片恢复的时候，privilege还是和album保持一致
      PersonalPhoto.update_all("privilege = #{album.privilege}", {:album_id => album.id})
    end
  end

  def before_destroy album
    return if album.verified == 2
    album.poster.raw_decrement "albums_count#{album.privilege}"
  end

end
