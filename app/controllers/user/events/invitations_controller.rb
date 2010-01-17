class User::Events::InvitationsController < UserBaseController

  layout 'app'

  def new
    @friends = current_user.friends
  end

  def create_multiple
    params[:users].each {|user_id| @event.invitations.create(:participant_id => user_id)}
    redirect_to event_url(@event)
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    unless @invitation.update_attributes(:status => params[:status])
      render :update do |page|
        page << "error('发生错误')"
      end
    end
  end

  def search
    @friends = current_user.friends.find_all {|f| f.login.include?(params[:key])}
    render :partial => 'friends'
  end

protected

  def setup
    if ['new', 'create_multiple'].include? params[:action]
      @event = current_user.events.find(params[:event_id])
    elsif ['edit', 'update'].include? params[:action]
      @invitation = current_user.event_invitations.find(params[:id])
      @event = @invitation.event
    end
  rescue
    not_found
  end

end
