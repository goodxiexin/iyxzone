class User::Guilds::AlbumsController < UserBaseController

  layout 'app'

  def show
    @membership = @guild.memberships.find_by_user_id(current_user.id)
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @photos = @album.photos.paginate :page => params[:page], :per_page => 12
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
