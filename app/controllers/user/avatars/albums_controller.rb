class User::Avatars::AlbumsController < UserBaseController

  layout 'app'

  def show
    respond_to do |format|
      format.html {
        @random_albums = PersonalAlbum.by(@user.id).for('friend').nonblocked.random :limit => 5
        @photos = @album.photos.nonblocked.paginate :page => params[:page], :per_page => 12 
        @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
        render :action => 'show'
      }
      format.json {
        render :json => @album.photos.nonblocked.map{|p| p.public_filename}
      }
    end
  end

  def update
    if @album.update_attributes(params[:album])
      respond_to do |format|
        format.json { render :json => @album }
      end  
    else
      render_js_error
    end
  end

protected

  def setup
    if ["show"].include? params[:action]
      @album = AvatarAlbum.find(params[:id])
      require_verified @album
      @user = @album.poster
      @relationship = @user.relationship_with current_user
      require_adequate_privilege @album, @relationship
    elsif ["update"].include? params[:action]
      @album = AvatarAlbum.find(params[:id])
      require_verified @album
      @user = @album.poster
      require_owner @user
    end
  end

end
