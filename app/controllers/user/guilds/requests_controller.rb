class User::Guilds::RequestsController < UserBaseController

  layout 'app'

  def new
    if @guild.is_requestable_by? current_user
      @characters = @guild.requestable_characters_for current_user
      render :action => 'new', :layout => false
    else
      render_not_found
    end
  end

  def create
    @request = @guild.requests.build((params[:request] || {}).merge({:user_id => current_user.id}))
    
    unless @request.save
      render_js_error
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
      @guild = Guild.find(params[:guild_id])
      require_verified @guild
      @user = @guild.president
    elsif ['accept', 'decline'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_owner @guild.president
      @request = @guild.requests.find(params[:id])
    end
  end

end

