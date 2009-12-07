class PersonalAlbum::AlbumCommentsController < CommentsController

	before_filter :privilege_required, :only => [:create]

protected

  def catch_commentable
    @album = PersonalAlbum.find(params[:personal_album_id])
    @user = @album.user
    @commentable = @album
		@privilege = @album.privilege
  rescue
    not_found
  end

end
