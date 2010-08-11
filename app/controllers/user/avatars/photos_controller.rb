class User::Avatars::PhotosController < UserBaseController

  layout 'app'

  def show
    @random_albums = PersonalAlbum.by(@user.id).for('friend').nonblocked.random :limit => 5
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @tags = @photo.tags.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:tagged_user => {:only => [:login, :id]}, :poster => {:only => [:login, :id]}}
  end

  def new
    render :action => 'new', :layout => false
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def create
    @photo = @album.photos.build(params[:photo])

    if @photo.save && @album.set_cover(@photo)
			responds_to_parent do
        render :update do |page|
          page << "Iyxzone.Facebox.close()"
          if params[:at] == 'album'
            page.redirect_to avatar_album_url(@album)
          elsif params[:at] == 'profile'
						@album.reload
            page.replace_html 'avatar', album_cover(@album, :size => :clarge)
          elsif params[:at] == 'first_time'
						@album.reload
            page.replace_html 'the_avatar_image', album_cover_image(@album, :size => :clarge)
          end
        end
      end
    else
      responds_to_parent do
        render :update do |page|
          page << "$('error').innerHTML = 'There was an error uploading this icon"
        end
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
    elsif ['edit', 'update', 'destroy', 'update_notation'].include? params[:action]
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

