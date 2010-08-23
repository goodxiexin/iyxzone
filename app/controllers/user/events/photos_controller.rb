class User::Events::PhotosController < UserBaseController

  layout 'app'

  def index
    @photos = @album.photos.nonblocked.limit(5).all
    render :action => 'index', :layout => false
  end

  def new
  end

  def show
    @participation = @event.participations.authorized.by(current_user.id).first
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @tags = @photo.tags.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:tagged_user => {:only => [:login, :id]}, :poster => {:only => [:login, :id]}}
  end

	def create
		@photo = @album.photos.build(:swf_uploaded_data => params[:Filedata])
    if @photo.save
			render :json => {:code => 1, :id => @photo.id}
		else
      render :json => {:code => 0}
    end
	end

	def record_upload
    @photos = @album.photos.nonblocked.find(params[:ids])

    if @album.record_upload current_user, @photos
			render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
	end

  def edit
    render :action => 'edit', :layout => false 
  end

  def update
    if @photo.update_attributes(params[:photo])
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def edit_multiple
    @photos = @album.photos.nonblocked.find(params[:ids] || [])
  end

  def update_multiple
    @photos = @album.photos.nonblocked.find(params[:photos].keys)
    @photos.each do |photo|
      photo.update_attributes(params[:photos]["#{photo.id}"])
    end
    @album.update_attribute('cover_id', params[:cover_id]) if params[:cover_id]
    render :json => {:code => 1}
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
    if ['index'].include? params[:action]
      @album = EventAlbum.find(params[:album_id])
      require_verified @album
    elsif ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @photo = EventPhoto.find(params[:id], :include => [{:comments => [{:poster => :profile}, :commentable]}, {:tags => [:poster, :tagged_user]}])
      require_verified @photo
      @album = @photo.album
      @event = @album.event
      @user = @event.poster
      require_owner @user if params[:action] != 'show'
    elsif ['new', 'create', 'record_upload', 'edit_multiple', 'update_multiple'].include? params[:action]
      @album = EventAlbum.find(params[:album_id])
      require_verified @album
      @event = @album.event
      @user = @event.poster
      require_owner @user
    end
  end

end
