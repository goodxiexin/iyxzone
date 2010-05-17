class User::Guilds::InvitationsController < UserBaseController

  layout 'app'

  def new
    @characters = GameCharacter.by(current_user.friend_ids).match(:game_id => @guild.game_id, :area_id => @guild.game_area_id, :server_id => @guild.game_server_id) - @guild.all_characters
  end

  def create
    if @guild.update_attributes(:invitees => params[:values])
      redirect_to guild_url(@guild)
    else
      render :action => 'new'
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

	def accept
		unless @invitation.accept_invitation
      render_js_error
    end
  end

	def decline
    unless @invitation.decline_invitation
      render_js_error
    end
  end

protected

  def setup
    if ['new', 'create'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_verified @guild
      require_owner @guild.president
    elsif ['edit', 'accept', 'decline'].include? params[:action]
      @invitation = Membership.find(params[:id])
      @guild = @invitation.guild
      require_owner @invitation.user
    end
  end

end
