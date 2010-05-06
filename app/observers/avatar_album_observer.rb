class AvatarAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify
    album.verified = album.sensitive? ? 0 : 1

    # inherit some attributes from album
		album.title = "头像相册"
    album.poster_id = album.owner_id
    album.game_id = nil
    album.privilege = 3
    album.title = "#{album.poster.login}的头像相册"
  end

  def before_update album
    if album.sensitive_columns_changed? and album.sensitive?
      album.verified = 0
    end
  end

  def after_update album
    if album.recently_verified_from_unverified
      Photo.update_all("verified = 1", {:album_id => album.id})
      avatar = album.poster.avatar
      avatar.deliver_feeds if !avatar.blank?
    elsif album.recently_unverified
      album.photos.each do |photo|
        photo.destroy_feeds
      end
      Photo.update_all("verified = 2", {:album_id => album.id})
    end
  end

end
