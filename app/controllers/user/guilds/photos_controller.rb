class User::Guilds::PhotosController < UserBaseController

  layout 'app'

  # 用在了guild show页面上
  def index
    @photos = @album.photos.nonblocked.limit(5).all
    render :action => 'index', :layout => false
  end

  def new
  end

  def show
    @role = @guild.role_for current_user
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
			redirect_js edit_multiple_guild_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id})
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
					    page << "Iyxzone.Facebox.close()();"
            elsif params[:at] == 'photo'
              page << "Iyxzone.Facebox.close()();"
		  			  page << "$('guild_photo_notation_#{@photo.id}').update( '#{@photo.notation.gsub(/\n/, '<br/>')}');"
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
            page.replace_html 'errors', :inline => "<%= error_messages_for :photo, :header_message => '遇到以下问题无法保存', :message => nil %>"
          end 
        }
      end 
    end
  end

  def edit_multiple
    @photos = @album.photos.nonblocked.find(params[:ids])
  end

  def update_multiple
    @photos = @album.photos.nonblocked.find(params[:photos].keys)
    @photos.each do |photo|
      photo.update_attributes(params[:photos]["#{photo.id}"])
    end
    @album.update_attribute('cover_id', params[:cover_id]) if params[:cover_id]
    redirect_to guild_album_url(@album)
  end

  def destroy
    if @photo.destroy
      redirect_js guild_album_url(@album)
    else
      render_js_error
    end
  end

protected

  def setup
    if ['index'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      require_verified @album
    elsif ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @photo = GuildPhoto.find(params[:id], :include => [{:comments => [{:poster => :profile}, :commentable]}, {:tags => [:poster, :tagged_user]}])
      require_verified @photo
      @album = @photo.album
      @guild = @album.guild
      @user = @guild.president
      require_owner @user unless params[:action] == 'show'
    elsif ['new', 'create', 'record_upload', 'edit_multiple', 'update_multiple'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      require_verified @album
      @guild = @album.guild
      @user = @guild.president
      require_owner @user
    end
  end

end
