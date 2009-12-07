class PersonalAlbum::DigsController < DigsController

protected

  def catch_diggable
    @photo = PersonalPhoto.find(params[:personal_photo_id])
    @album = @photo.album
    @user = @album.user
    @diggable = @photo
  rescue
    not_found
  end

end
