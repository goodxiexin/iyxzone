class User::Events::InvitationsController < UserBaseController

  layout 'app'

  def new
    if @guild
      @characters = @guild.characters - @event.all_characters
    else
      @characters = current_user.friend_characters(:game_id => @event.game_id, :area_id => @event.game_area_id, :server_id => @event.game_server_id) - @event.all_characters
    end
  end

  def create
    if @event.update_attributes(:invitees => params[:values])
      redirect_to event_url(@event)
    else
      render :action => 'new'
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def accept
    unless @invitation.update_attributes(:status => params[:status])
      render :update do |page|
        page << "error('发生错误')"
      end
    end
  end

  def decline
    unless @invitation.destroy
      render :update do |page|
        page << "error('发生错误');"
      end
    end  
  end

protected

  def setup
    if ['new', 'create'].include? params[:action]
      @event = Event.find(params[:event_id])
      @guild = @event.guild
      require_owner @event.poster
    elsif ['edit', 'accept', 'decline'].include? params[:action]
      @invitation = Participation.find(params[:id])
      @event = @invitation.event
      require_owner @invitation.participant
    end
  end

end
