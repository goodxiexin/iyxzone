class AvatarAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify
    album.needs_verify

    # inherit some attributes from album
		album.title = "头像相册"
    album.poster_id = album.owner_id
    album.game_id = nil
    album.privilege = 3
    album.title = "#{album.poster.login}的头像相册"
  end

  def before_update album
    if album.sensitive_columns_changed? and album.sensitive?
      album.needs_verify
    end
  end

  def after_update album
    if album.recently_recovered
      Photo.verify_all(:album_id => album.id)#update_all("verified = 1", {:album_id => album.id})
      avatar = album.poster.avatar
      avatar.deliver_feeds if !avatar.blank?
    elsif album.recently_unverified
      album.photos.each do |photo|
        photo.destroy_feeds
      end
      Photo.unverify_all(:album_id => album.id)#update_all("verified = 2", {:album_id => album.id})
    end
  end

end
