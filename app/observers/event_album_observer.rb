class EventAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify
    album.needs_verify if album.sensitive?

    # inherit some attributes from album
    event = album.event
    album.poster_id = event.poster_id
    album.privilege = 1
    album.game_id = event.game_id
    album.title = "活动'#{event.title}'的相册" 
  end

  def before_update album
    if album.sensitive_columns_changed? and album.sensitive?
      album.needs_verify
    end
  end

  def after_update album
    if album.recently_verified_from_unverified
      Photo.verify_all(:album_id => album.id)
    elsif album.recently_unverified
      Photo.unverify_all(:album_id => album.id)
      album.destroy_feeds
    end
  end

end
