class User::Events::RequestsController < UserBaseController

  layout 'app'

  def new
    if @event.is_requestable_by? current_user
      @characters = @event.requestable_characters_for current_user
      render :action => 'new', :layout => false
    else
      render :template => 'errors/404'
    end
  end

  def create
    @request = @event.requests.build((params[:request] || {}).merge({:participant_id => current_user.id}))
    
    unless @request.save
      render_js_error '发生错误，可能活动已经过期了'
    end
  end

  def accept
    unless @request.accept_request
      render_js_error
    end
  end

  def decline
    unless @request.decline_request
      render_js_error
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

