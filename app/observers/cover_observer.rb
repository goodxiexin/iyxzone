class CoverObserver < ActiveRecord::Observer

  observe :PersonalPhoto, :GuildPhoto, :EventPhoto

  def after_destroy(photo)
		return if photo.album.blank?
    album = photo.album
    if album.cover_id == photo.id
      album.update_attribute('cover_id', nil)
    end
  end

end
