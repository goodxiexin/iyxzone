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
    unless @participation.change_status params[:status]
      render_js_error
    end
  end

  def destroy
    if @participation.evict
      render_js_code "$('participation_#{@participation.id}').remove();"
    else
      render_js_error
    end 
  end

protected

  def setup
    if ["index"].include? params[:action]
      @event = Event.find(params[:event_id])
      require_verified @event
    elsif ["edit", "update"].include? params[:action]
      @participation = Participation.find(params[:id])
      @event = @participation.event
      require_verified @event
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
      render_js_error "error('不能删除自己');"
    end
  end

end
