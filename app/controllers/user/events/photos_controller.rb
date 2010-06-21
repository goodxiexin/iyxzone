class User::Events::PhotosController < UserBaseController

  layout 'app'

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
			render :text => @photo.id
		else
      # TODO
    end
	end

	def record_upload
    @photos = @album.photos.nonblocked.find(params[:ids])

    if @album.record_upload current_user, @photos
			redirect_js edit_multiple_event_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id})
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
            if params[:at] == 'album'
	  				  page << "facebox.close();"
            elsif params[:at] == 'photo'
              page<< "facebox.close();"
              page << "$('event_photo_notation_#{@photo.id}').update( '#{@photo.notation.gsub(/\n/, '<br/>')}');"
            end
				  end 
        }
				format.json { render :json => @photo }
			end
    else
      respond_to do |format|
        format.html { 
          render :update do |page|
            page << "Iyxzone.enableButton($('edit_photo_submit'), '完成');"
            page.replace_html 'errors', :inline => "<%= error_messages_for :album, :header_message => '遇到以下问题无法保存', :message => nil %>"
          end 
        }
      end
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
    redirect_to event_album_url(@album)
  end

  def destroy
    if @photo.destroy
      redirect_js event_album(@album)
    else
      render_js_error
    end
  end

protected

  def setup
    if ['show', 'edit', 'update', 'destroy'].include? params[:action]
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
