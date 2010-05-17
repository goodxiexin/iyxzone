class User::Events::InvitationsController < UserBaseController

  layout 'app'

  def new
    if @guild
      @characters = @guild.characters - @event.all_characters
    else
      @characters = GameCharacter.by(current_user.friend_ids).match(:game_id => @event.game_id, :area_id => @event.game_area_id, :server_id => @event.game_server_id) - @event.all_characters
    end
  end

  def create
    if @event.update_attributes(:invitees => params[:values])
      redirect_to event_url(@event)
    else
			flash[:error] = '邀请出错'
      redirect_to event_url(@event)
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def accept
    unless @invitation.accept_invitation params[:status]
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
      @event = Event.find(params[:event_id])
      @guild = @event.guild
      require_verified @event
      require_owner @event.poster
    elsif ['edit', 'accept', 'decline'].include? params[:action]
      @invitation = Participation.find(params[:id])
      @event = @invitation.event
      require_owner @invitation.participant
    end
  end

end
