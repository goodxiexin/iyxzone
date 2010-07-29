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
    @tags = @photo.tags.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:tagged_user => {:only => [:login, :id]}, :poster => {:only => [:login, :id]}}
  end

	def create
    @photo = @album.photos.build(:swf_uploaded_data => params[:Filedata])
    
    if @photo.save
			render :text => @photo.id	
		else
    end
	end

  def record_upload
    @photos = @album.photos.nonblocked.find(params[:ids] || [])

		if @album.record_upload current_user, @photos
      redirect_js edit_multiple_personal_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id})
    else
      render_js_error
    end
  end 

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    if @photo.update_attributes(params[:photo])
			respond_to do |format|
				format.html { 
          render :update do |page|
  					if @album.id != @photo.album_id
              if params[:at] == 'album'
		  				  page.redirect_to personal_album_url(@album)
              elsif params[:at] == 'photo'
                page.redirect_to personal_photo_url(@photo)
              end
  					else
              if params[:at] == 'album'
		  				  page << "Iyxzone.Facebox.close();"
              elsif params[:at] == 'photo'
                page.redirect_to personal_photo_url(@photo)
					    end
            end
				  end 
        }
				format.json { 
          render :json => @photo 
        }
			end 
    else
      respond_to do |format|
        format.html { 
          render :update do |page|
            page << "Iyxzone.enableButton($('edit_photo_submit'), '完成');"
            page.replace_html 'errors', :inline => "<%= error_messages_for :photo, :header_message => '遇到以下问题无法保存', :message => nil %>"
          end 
        }
      end
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
    redirect_to personal_album_url(@album) 
  end

  def destroy
    if @photo.destroy
      redirect_js personal_album_url(@album)
    else
      render_js_error
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
