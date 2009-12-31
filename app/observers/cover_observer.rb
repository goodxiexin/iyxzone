# 如果删除的照片是封面的话
# 就修改相册的封面到nil
# 这种情况对于avatar album不存在
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
