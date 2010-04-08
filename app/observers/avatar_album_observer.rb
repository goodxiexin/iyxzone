class AvatarAlbumObserver < ActiveRecord::Observer

  # works for both save and update
  def before_create album
		album.title = "头像相册"
    album.poster_id = album.owner_id
    album.game_id = nil
    album.privilege = 3
    album.title = "#{album.poster.login}的头像相册"
  end

  def after_create album
    # nothing to do right now
  end

  def after_destroy album
    # nothing to do right now
  end

end
