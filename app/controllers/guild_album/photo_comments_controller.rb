class GuildAlbum::PhotoCommentsController < CommentsController

protected

  def catch_commentable
    @photo = GuildPhoto.find(params[:guild_photo_id])
    @album = @photo.album
    @guild = @album.guild
    @user = @guild.president
    @commentable = @photo
  rescue
    not_found
  end

end
