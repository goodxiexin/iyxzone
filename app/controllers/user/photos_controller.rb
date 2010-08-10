class User::PhotosController < UserBaseController

  layout 'app'

	def hot
    @photos = Photo.hot.nonblocked.for('friend').paginate :page => params[:page], :per_page => 10
  end

  def relative
    @infos = current_user.relative_photo_infos.paginate :page => params[:page], :per_page => 12
  end

  def new
  end

  def show
    @random_albums = PersonalAlbum.by(@user.id).for(@relationship).nonblocked.random :limit => 5, :except => [@album]
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

	def create
    @photo = @album.photos.build(:swf_uploaded_data => params[:Filedata])
    
    if @photo.save
      render :json => {:code => 1, :id => @photo.id}
		else
      # TODO
    end
	end

  def record_upload
    @photos = @album.photos.nonblocked.find(params[:ids] || [])

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
    @photos = @album.photos.nonblocked.match(:id => params[:photos].keys)
    @photos.each do |photo|
      photo.update_attributes(params[:photos]["#{photo.id}"])
    end
    @album.update_attribute('cover_id', params[:cover_id]) if params[:cover_id]
    render :json => {:code => 1}
    # TODO else?? 
    #redirect_to personal_album_url(@album) 
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
      @photo = PersonalPhoto.find(params[:id], :include => [{:comments => [{:poster => :profile}, :commentable]}, {:tags => [:poster, :tagged_user]}])
      require_verified @photo
      @album = @photo.album
      @user = @album.poster
      @relationship = @user.relationship_with current_user
      require_adequate_privilege @album, @relationship
    elsif ['new', 'create', 'record_upload', 'edit_multiple', 'update_multiple'].include? params[:action]
      @album = PersonalAlbum.find(params[:album_id])
      require_verified @album
      require_owner @album.poster
    elsif ['relative'].include? params[:action]
			@user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @photo = PersonalPhoto.find(params[:id])
      require_verified @photo
      @album = @photo.album
      require_owner @album.poster
    end
  end

end
