class User::Avatars::AlbumsController < UserBaseController

  layout 'app'

  def show
    @photos = @album.photos.paginate :page => params[:page], :per_page => 16
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

protected

  def setup
    @album = AvatarAlbum.find(params[:id])
    @user = @album.poster
    require_friend_or_owner @user
  end

end
