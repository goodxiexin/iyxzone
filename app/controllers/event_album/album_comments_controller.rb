class EventAlbum::AlbumCommentsController < CommentsController

protected

  def catch_commentable
    @album = EventAlbum.find(params[:event_album_id])
    @event = @album.event
    @user = @event.poster
    @commentable = @album
  rescue
    not_found
  end


end
