class User::Guilds::PhotosController < UserBaseController

  layout 'app'

  require_verified 'photo'

  # TODO: veteran能够编辑吗?

  def new
  end

  def show
    @photo = GuildPhoto.find(params[:id])
    @album = @photo.album
    @guild = @album.guild
    @user = @guild.president
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
 
		if @album.record_upload current_user, @photos
			render :update do |page|
        if current_user == @guild.president 
				  page.redirect_to edit_multiple_guild_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id})
        else
          page.redirect_to guild_album_url(@album)
        end
			end
	  else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end 

  def edit
    render :action => 'edit', :layout => false 
  end

  def update
    @album.update_attribute('cover_id', @photo.id) if params[:cover]
    if @photo.update_attributes(params[:photo])
			respond_to do |format|
				format.json { render :text => @photo.notation }
				format.html {
					render :update do |page|
						page << "facebox.close();"
						page << "$('guild_photo_notation_#{@photo.id}').innerHTML = '#{@photo.notation}';"
					end
				}
			end
    else
      # TODO
    end
  end

  def edit_multiple
    @photos = @album.photos.find(params[:ids])
  end

  def update_multiple
    @album.update_attribute('cover_id', params[:cover_id]) if params[:cover_id]
    params[:photos].each do |id, attributes|
      photo = @album.photos.find(id)
      photo.update_attributes(attributes)
    end
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

  def update_notation
    if @photo.update_attributes(params[:photo])
      render :text => @photo.notation
    end 
  end

protected

  def setup
    if ['edit', 'update', 'update_notation', 'destroy'].include? params[:action]
      @photo = GuildPhoto.find(params[:id])
      @album = @photo.album
      @guild = @album.guild
      @user = @guild.president
      require_owner @user
    elsif ['new', 'create', 'record_upload', 'edit_multiple', 'update_multiple'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      @guild = @album.guild
      @user = @guild.president
      require_president_or_veteran
    end
  end

  def require_president_or_veteran
    @membership = @guild.memberships.find_by_user_id(current_user.id)
    (@membership and (@membership.is_president? or @membership.is_veteran?)) || render_not_found
  end 

end
