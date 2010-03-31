class User::Guilds::RequestsController < UserBaseController

  layout 'app'

  def new
    @request_characters = @guild.request_characters_for current_user
    @invite_characters = @guild.invite_characters_for current_user
    @guild_characters = @guild.characters_for current_user
    @user_characters = current_user.characters.find(:all, :conditions => {:game_id => @guild.game_id, :area_id => @guild.game_area_id, :server_id => @guild.game_server_id})
    @characters = @user_characters - @request_characters - @invite_characters - @guild_characters
    render :action => 'new', :layout => false
  end

  def create
    request_params = (params[:request] || {}).merge({:user_id => current_user.id})
    @request = @guild.requests.build request_params
    unless @request.save
      render :update do |page|
        page << "error('发生错误');"
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
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
    elsif ['accept', 'decline'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_owner @guild.president
      @request = @guild.requests.find(params[:id])
    end
  end

end

