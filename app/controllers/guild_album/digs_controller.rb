class GuildAlbum::DigsController < DigsController

protected

  def catch_diggable
    @photo = GuildPhoto.find(params[:guild_photo_id])
    @album = @photo.album
    @guild = @album.guild
    @user = @guild.president
    @diggable = @photo
  rescue
    not_found
  end


end
