class EventAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify
    album.auto_verify

    # inherit some attributes from album
    event = album.event
    album.poster_id = event.poster_id
    album.privilege = 1
    album.game_id = event.game_id
    album.title = "活动'#{event.title}'的相册" 
  end

  def before_update album
    album.auto_verify
  end

  def after_update album
    if album.recently_recovered?
      Photo.verify_all(:album_id => album.id)
      Album.update_all("photos_count = #{album.photos.count}", {:id => album.id})
      # feed 就不恢复了
    elsif album.recently_rejected?
      Photo.unverify_all(:album_id => album.id)
      Album.update_all("photos_count = 0", {:id => album.id})
      album.destroy_feeds
    end
  end

end
