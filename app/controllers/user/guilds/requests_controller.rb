class User::Guilds::RequestsController < UserBaseController

  layout 'app'

  def new
    @request_characters = @guild.request_characters.by(current_user.id)
    @invite_characters = @guild.invite_characters.by(current_user.id)
    @guild_characters = @guild.characters.by(current_user.id)
    @user_characters = current_user.characters.match(:game_id => @guild.game_id, :area_id => @guild.game_area_id, :server_id => @guild.game_server_id)
    @characters = @user_characters - @request_characters - @invite_characters - @guild_characters
    render :action => 'new', :layout => false
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

