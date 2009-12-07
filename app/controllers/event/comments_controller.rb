class Event::CommentsController < CommentsController

  layout 'app'

  before_filter :catch_participation, :only => [:index, :create]

  before_filter :owner_required, :only => [:destroy]

  before_filter :participant_required, :only => [:create]

protected

  def catch_commentable
    @event = Event.find(params[:event_id])
    @user = @event.poster
    @commentable = @event
  rescue
    not_found
  end

  def catch_participation
    @participation = @event.participations.find_by_participant_id(current_user.id)
  end

  def participant_required
    @participation || participant_denied
  end

  def participant_denied
    flash[:notice] = "你必须加入到此活动才能进行那些操作"
    redirect_to event_url(@event)
  end

end
