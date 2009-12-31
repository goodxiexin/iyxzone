#
# 个人的相册是有权限设置的，如果相册的权限改变，所有相片的权限也改变
#
class PersonalAlbumObserver < ActiveRecord::Observer

  def after_update album
    album.destroy_feeds if album.privilege == 4 and album.privilege_was != 4
    if album.privilege_changed?
      PersonalPhoto.update_all("privilege = #{album.privilege}", {:album_id => album.id})
    end
  end

end
