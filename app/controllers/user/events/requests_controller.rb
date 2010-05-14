class User::Events::RequestsController < UserBaseController

  layout 'app'

  def new
    @request_characters = @event.request_characters.by(current_user.id)
    @invite_characters = @event.invite_characters.by(current_user.id)
    @confirmed_and_maybe_characters = @event.characters.by(current_user)
    @user_characters = current_user.characters.match(:game_id => @event.game_id, :area_id => @event.game_area_id, :server_id => @event.game_server_id)
    @characters = @user_characters - @request_characters - @invite_characters - @confirmed_and_maybe_characters
    render :action => 'new', :layout => false
  end

  def create
    @request = @event.requests.build (params[:request] || {}).merge({:participant_id => current_user.id})
    
    unless @request.save
      render :update do |page|
        page << "error('发生错误，可能活动已经过期了');"
      end
    end
  end

  def accept
    unless @request.accept_request
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def decline
    unless @request.decline_request
      render :update do |page|
        page << "error('发生错误');"
      end
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
      require_owner @event.poster
      @request = @event.requests.find(params[:id])
    end
  end

end

