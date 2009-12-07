class EventAlbum::DigsController < DigsController

protected

  def catch_diggable
    @photo = EventPhoto.find(params[:event_photo_id])
    @album = @photo.album
    @event = @album.event
    @user = @event.poster
    @diggable = @photo
  rescue
    not_found
  end


end
