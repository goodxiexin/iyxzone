#
# 个人的相册是有权限设置的，如果相册的权限改变，所有相片的权限也改变
#
class PersonalAlbumObserver < ActiveRecord::Observer

  def before_create album
    album.poster_id = album.owner_id
  end

  def after_update album
    if album.privilege_changed?
      album.poster.raw_increment "albums_count#{album.privilege}"
      album.poster.raw_decrement "albums_count#{album.privilege_was}"
      PersonalPhoto.update_all("privilege = #{album.privilege}", {:album_id => album.id})
    end
  end

  def after_create album
    album.poster.raw_increment "albums_count#{album.privilege}"
  end

  def after_destroy album
    album.poster.raw_decrement "albums_count#{album.privilege}"
  end

end
