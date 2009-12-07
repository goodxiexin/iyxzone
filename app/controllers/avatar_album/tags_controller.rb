class AvatarAlbum::TagsController < PhotoTagsController

  before_filter :friend_or_owner_required, :only => [:create]

protected

  def catch_photo
    @photo = Avatar.find(params[:avatar_id])
    @album = @photo.album
    @user = @album.poster
	rescue
		not_found
  end

end
