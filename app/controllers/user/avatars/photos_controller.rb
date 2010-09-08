class User::Avatars::PhotosController < UserBaseController

  layout 'app'

  def show
    @random_albums = PersonalAlbum.by(@user.id).for('friend').nonblocked.random :limit => 5
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @tags = @photo.tags.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:tagged_user => {:only => [:login, :id]}, :poster => {:only => [:login, :id]}}
  end

  def new
    @photo = @album.photos.find(params[:photo_id]) if params[:photo_id]
    render :action => 'new'
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def create
    @photo = @album.photos.build(params[:photo])

    if @photo.save
			responds_to_parent do
        render_js_code "Iyxzone.Avatar.Builder.imageUploaded(#{@photo.id}, '#{@photo.public_filename}', '#{@photo.filename}', #{@photo.width}, #{@photo.height})"
      end
    else
      responds_to_parent do
        render_js_error
      end
    end
  end

  def update
    if @photo.update_attributes(params[:photo])
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def crop
    if @photo.crop(params[:large], params[:small])
      @album.set_cover(@photo)
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end
  
  def destroy
    if @photo.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    if ['show'].include? params[:action]
      @photo = Avatar.find(params[:id])
      require_verified @photo
      @album = @photo.album
      @user = @album.poster
      @relationship = @user.relationship_with current_user
      require_adequate_privilege @album, @relationship
    elsif ['crop', 'edit', 'update', 'destroy', 'update_notation'].include? params[:action]
      @album = current_user.avatar_album
      @photo = @album.photos.find(params[:id])
      require_verified @photo
      require_owner @photo.poster
    elsif ['new', 'create'].include? params[:action]
      @album = current_user.avatar_album
      require_verified @album
    end
  end
	
end

