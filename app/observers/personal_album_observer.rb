class PersonalAlbumObserver < ActiveRecord::Observer

  def after_update album
    album.destroy_feeds if album.privilege == 4 and album.privilege_was != 4
    if album.privilege_changed?
      PersonalPhoto.update_all("privilege = #{album.privilege}", {:album_id => album.id})
    end
  end

end
