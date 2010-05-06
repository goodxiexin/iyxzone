#
# 个人的相册是有权限设置的，如果相册的权限改变，所有相片的权限也改变
#
class PersonalAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify?
    album.verified = album.sensitive? ? 0 : 1

    # inherit some attributes from owner
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
    if album.recently_verified_from_unverified
      album.poster.raw_increment "albums_count#{album.privilege}"
      Photo.update_all("verified = 1", {:album_id => album.id})
      # 没法恢复新鲜事，因为根部没记录照片是分几次，怎么上传的
    elsif album.recently_unverified
      album.poster.raw_decrement "albums_count#{album.privilege}"
      Photo.update_all("verified = 2", {:album_id => album.id})
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
    if album.verified != 2
      album.poster.raw_decrement "albums_count#{album.privilege}"
    end
  end

end
