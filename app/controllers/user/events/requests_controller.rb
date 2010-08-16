class User::Events::RequestsController < UserBaseController

  layout 'app'

  def new
    if @event.is_requestable_by? current_user
      @characters = @event.requestable_characters_for current_user
      render :action => 'new', :layout => false
    else
      render_not_found
    end
  end

  def create
    @request = @event.requests.build((params[:request] || {}).merge({:participant_id => current_user.id}))

    if @request.save
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def accept
    if @request.accept_request
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def decline
    if @request.decline_request
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    if ['new', 'create'].include? params[:action]
      @event = Event.find(params[:event_id])
      require_verified @event
      @user = @event.poster
    elsif ['accept', 'decline'].include? params[:action]
      @event = Event.find(params[:event_id])
      require_verified @event
      require_owner @event.poster
      @request = @event.requests.find(params[:id])
    end
  end

end

