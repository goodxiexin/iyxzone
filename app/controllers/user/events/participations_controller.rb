class User::Events::ParticipationsController < UserBaseController

  layout 'app'

  def index
    case params[:type].to_i
    when 0
      @participations = @event.confirmed_participations
    when 1
      @participations = @event.maybe_participations
		when 2
			@participations = @event.invitations
		when 3
			@participations = @event.requests
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    unless @participation.update_attributes(:status => params[:status])
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def destroy
    if @participation.destroy
      render :update do |page|
        page << "$('participation_#{@participation.id}').remove();"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end 
  end

protected

  def setup
    if ["index"].include? params[:action]
      @event = Event.find(params[:event_id])
    elsif ["edit", "update"].include? params[:action]
      @participation = Participation.find(params[:id])
      @event = @participation.event
      require_owner @participation.participant
    elsif ["destroy"].include? params[:action]
      @participation = Participation.find(params[:id])
      @event = @participation.event
      require_owner @event.poster
      require_not_event_poster @participation
    end
  end

  def require_not_event_poster participation
    if participation.participant == participation.event.poster
      render :update do |page|
        page << "error('不能删除自己');"
      end
    end
  end

end
