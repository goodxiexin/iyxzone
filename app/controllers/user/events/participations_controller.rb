class User::Events::ParticipationsController < UserBaseController

  layout 'app'

  PREFETCH = [:character, {:participant => :profile}]

  Category = [:confirmed_participations, :maybe_participations, :invitations, :requests]

  def index
    @participations = eval("@event.#{Category[params[:type].to_i]}").prefetch(PREFETCH)
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    if @participation.change_status params[:status]
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
    if @participation.evict
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end 
  end

protected

  def setup
    if ["index"].include? params[:action]
      @event = Event.find(params[:event_id])
      require_verified @event
    elsif ["edit", "update"].include? params[:action]
      @event = Event.find(params[:event_id])
      require_verified @event
      @participation = @event.participations.find(params[:id])
      require_owner @participation.participant
    elsif ["destroy"].include? params[:action]
      @participation = Participation.find(params[:id])
      @event = @participation.event
      require_verified @event
      require_owner @event.poster
      require_not_event_poster @participation
    end
  end

  def require_not_event_poster participation
    if participation.participant == participation.event.poster
      render :json => {:code => 3}
    end
  end

end
