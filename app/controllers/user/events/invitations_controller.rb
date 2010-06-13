class User::Events::InvitationsController < UserBaseController

  layout 'app'

  def new
    @characters = @event.inviteable_characters
  end

  def create
    @characters = GameCharacter.find(params[:values])

    if @event.invite @characters
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
      require_verified @event
      require_owner @invitation.participant
    end
  end

end
