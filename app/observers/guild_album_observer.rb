class GuildAlbumObserver < ActiveRecord::Observer

  def before_create album
    # verify
    album.verified = album.sensitive? ? 0 : 1

    # inherit some attributes from guild
    guild = album.guild
    album.poster_id = guild.president_id
    album.privilege = 1
    album.game_id = guild.game_id
    album.title = "工会'#{guild.name}'的相册" 
  end

  def before_update album
    if album.sensitive_columns_changed? and album.sensitive?
      album.verified = 0
    end 
  end

  def after_update album
    if album.recently_verified_from_unverified
      Photo.update_all("verified = 1", {:album_id => album.id})
    elsif album.recently_unverified
      Photo.update_all("verified = 2", {:album_id => album.id})
      album.destroy_feeds
    end
  end

end
