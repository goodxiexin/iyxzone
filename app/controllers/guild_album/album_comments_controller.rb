class GuildAlbum::AlbumCommentsController < CommentsController

protected

  def catch_commentable
    @album = GuildAlbum.find(params[:guild_album_id])
    @guild = @album.guild
    @user = @guild.president
    @commentable = @album
  rescue
    not_found
  end


end
