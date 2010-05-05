class User::Guilds::PhotosController < UserBaseController

  layout 'app'

  # TODO: veteran能够编辑吗?

  def new
  end

  def show
    @membership = @guild.memberships.find_by_user_id(current_user.id)
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @tags = @photo.tags.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:tagged_user => {:only => [:login, :id]}, :poster => {:only => [:login, :id]}}
  end

	def create
		if @photo = @album.photos.create(:poster_id => current_user.id, :game_id => @album.game_id, :privilege => @album.privilege, :swf_uploaded_data => params[:Filedata])
			render :text => @photo.id
		else
			# TODO
		end
	end

  def record_upload
    @photos = @album.photos.find(params[:ids])
		@album.record_upload current_user, @photos
		render :update do |page|
			page.redirect_to edit_multiple_guild_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id})
		end
  end 

  def edit
    render :action => 'edit', :layout => false 
  end

  def update
    if @photo.update_attributes(params[:photo])
			respond_to do |format|
				format.html { render :update do |page|
          if params[:at] == 'album'
					  page << "facebox.close();"
          elsif params[:at] == 'photo'
            page << "facebox.close();"
#					  page << "$('guild_photo_notation_#{@photo.id}').innerHTML = '#{@photo.notation.gsub(/\n/, '<br/>')}';"
					  page << "$('guild_photo_notation_#{@photo.id}').update( '#{@photo.notation.gsub(/\n/, '<br/>')}');"

          end
				end }
				format.json { render :json => @photo }
			end
    else
      respond_to do |format|
        format.html { render :update do |page|
          page << "Iyxzone.enableButton($('edit_photo_submit'), '完成');"
          page.replace_html 'errors', :inline => "<%= error_messages_for :photo, :header_message => '遇到以下问题无法保存', :message => nil %>"
        end }
      end 
    end
  end

  def edit_multiple
    @photos = @album.photos.find(params[:ids])
  end

  def update_multiple
    params[:photos].each do |id, attributes|
      photo = @album.photos.find(id)
      photo.update_attributes(attributes)
    end
    @album.update_attribute('cover_id', params[:cover_id]) if params[:cover_id]
    redirect_to guild_album_url(@album)
  end

  def destroy
    if @photo.destroy
      render :update do |page|
        page.redirect_to guild_album_url(@album)
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @photo = GuildPhoto.find(params[:id], :include => [{:comments => [{:poster => :profile}, :commentable]}, {:tags => [:poster, :tagged_user]}])
      require_verified @photo
      @album = @photo.album
      @guild = @album.guild
      require_verified @guild
      @user = @guild.president
      require_owner @user unless params[:action] == 'show'
    elsif ['new', 'create', 'record_upload', 'edit_multiple', 'update_multiple'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      @guild = @album.guild
      require_verified @guild
      @user = @guild.president
      require_owner @user
    end
  end

end
