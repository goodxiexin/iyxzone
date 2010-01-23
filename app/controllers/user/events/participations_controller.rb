class User::Events::ParticipationsController < UserBaseController

  layout 'app'

  def index
    case params[:type].to_i
    when 0
      @participants = @event.confirmed_participants.paginate :page => params[:page], :per_page => 20
    when 1
      @participants = @event.maybe_participants.paginate :page => params[:page], :per_page => 20
    when 2
      @participants = @event.declined_participants.paginate :page => params[:page], :per_page => 20
		when 3
			@participants = @event.invitees.paginate :page => params[:page], :per_page => 20
		when 4
			@participants = @event.requestors.paginate :page => params[:page], :per_page => 20
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

protected

  def setup
    if ["index"].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
    elsif ["edit", "update"].include? params[:action]
      @participation = current_user.participations.find(params[:id])
      @event = @participation.event
      #@event = Event.find(params[:event_id])
      #@user = @event.poster
      #@participation = @event.participations.find(params[:id], :conditions => {:status => [3,4,5]})
    end
  rescue
    not_found
  end

end
