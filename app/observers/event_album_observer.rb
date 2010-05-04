class EventAlbumObserver < ActiveRecord::Observer

  def before_create album
    # inherit some attributes from album
    event = album.event
    album.poster_id = event.poster_id
    album.privilege = 1
    album.game_id = event.game_id
    album.title = "活动'#{event.title}'的相册" 
  end

end
