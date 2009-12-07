class AvatarAlbum::PhotoCommentsController < CommentsController

protected

  def catch_commentable
    @photo = Avatar.find(params[:avatar_id])
    @album = @photo.album
    @user = @album.poster
    @commentable = @photo
	rescue
		not_found
  end

end
