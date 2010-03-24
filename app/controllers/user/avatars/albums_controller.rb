class User::Avatars::AlbumsController < UserBaseController

  layout 'app'

  def show
    @photos = @album.photos.paginate :page => params[:page], :per_page => 16
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

  def update
    if @album.update_attributes(params[:album])
      respond_to do |format|
        format.json { render :json => @album }
      end  
    end
  end

protected

  def setup
    if ["show"].include? params[:action]
      @album = AvatarAlbum.find(params[:id])
      @user = @album.poster
      require_friend_or_owner @user
    elsif ["update"].include? params[:action]
      @album = AvatarAlbum.find(params[:id])
      @user = @album.poster
      require_owner @user
    end
  end

end
