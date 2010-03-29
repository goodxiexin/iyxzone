class User::Events::RequestsController < UserBaseController

  layout 'app'

  def new
    @request_characters = @event.request_characters_for current_user
    @invite_characters = @event.invite_characters_for current_user
    @confirmed_and_maybe_characters = @event.confirmed_and_maybe_characters_for current_user
    @user_characters = current_user.characters.find(:all, :conditions => {:game_id => @event.game_id, :area_id => @event.game_area_id, :server_id => @event.game_server_id})
    @characters = @user_characters - @request_characters - @invite_characters - @confirmed_and_maybe_characters
    render :action => 'new', :layout => false
  end

  def create
    request_params = (params[:request] || {}).merge({:participant_id => current_user.id})
    @request = @event.requests.build request_params
    unless @request.save
      render :update do |page|
        page << "error('发生错误，可能活动已经过期了');"
      end
    end
  end

  def accept
    unless @request.accept
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def decline
    unless @request.destroy
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ['new', 'create'].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
    elsif ['accept', 'decline'].include? params[:action]
      @event = Event.find(params[:event_id])
      require_owner @event.poster
      @request = @event.requests.find(params[:id])
    end
  end

end

