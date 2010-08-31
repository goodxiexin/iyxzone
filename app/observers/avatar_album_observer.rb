class AvatarAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify
    album.needs_no_verify

    # inherit some attributes from album
    album.poster_id = album.owner_id
    album.privilege = PrivilegedResource::FRIEND
    album.title = "#{album.poster.login}的头像相册"
  end

  def before_update album
    album.auto_verify
  end

  def after_update album
    if album.recently_recovered?
      Photo.verify_all(:album_id => album.id)
      Album.update_all("photos_count = #{album.photos.count}", {:id => album.id})
      # 相册里的照片的feed和share就没法恢复了
    elsif album.recently_rejected?
      Photo.unverify_all(:album_id => album.id)
      Album.update_all("photos_count = 0", {:id => album.id})
      album.photos.each { |photo| photo.destroy_feeds }
    end
  end

end
