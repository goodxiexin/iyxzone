class User::Guilds::InvitationsController < UserBaseController

  layout 'app'

  def new
    @characters = GameCharacter.by(current_user.friend_ids).match(:game_id => @guild.game_id, :area_id => @guild.game_area_id, :server_id => @guild.game_server_id) - @guild.all_characters
  end

  def create
    @characters = GameCharacter.find params[:values]

    if @guild.invite @characters
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

	def accept
		if @invitation.accept_invitation
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

	def decline
    if @invitation.decline_invitation
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    if ['new', 'create'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_verified @guild
      require_owner @guild.president
    elsif ['edit', 'accept', 'decline'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @invitation = @guild.invitations.find(params[:id])
      require_owner @invitation.user
    end
  end

end
