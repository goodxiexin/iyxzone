class AvatarAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify
    album.verified = 1

    # inherit some attributes from album
		album.title = "头像相册"
    album.poster_id = album.owner_id
    album.game_id = nil
    album.privilege = 3
    album.title = "#{album.poster.login}的头像相册"
  end

end
