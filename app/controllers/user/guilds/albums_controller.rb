class User::Guilds::AlbumsController < UserBaseController

  layout 'app'

  def show
    respond_to do |format|
      format.html {
        @membership = @guild.memberships.find_by_user_id(current_user.id)
        @photos = @album.photos.paginate :page => params[:page], :per_page => 12 
        @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
        render :action => 'show'
      }
      format.json {
        @photos = @album.photos
        @json = @photos.map {|p| p.public_filename}
        render :json => @json
      }
    end
  end

  def update
    if @album.update_attributes((params[:album] || {}).merge({:owner_id => @guild.id}))
			respond_to do |format|
				format.json { render :json => @album }
			end
    end
  end

protected

  def setup
    @album = GuildAlbum.find(params[:id])
    @guild = @album.guild
    @user = @guild.president
    require_owner @user if params[:action] == 'update'
  end

end
