class EventAlbum::PhotoCommentsController < CommentsController

protected

  def catch_commentable
    @photo = EventPhoto.find(params[:event_photo_id])
    @album = @photo.album
    @event = @album.event
    @user = @event.poster
    @commentable = @photo
  rescue
    not_found
  end

end
