class User::Events::InvitationsController < UserBaseController

  layout 'app'

  def new
    @characters = @event.inviteable_characters
  end

  def create
    @characters = GameCharacter.find(params[:values])

    if @event.invite @characters
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def accept
    if @invitation.accept_invitation params[:status]
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
