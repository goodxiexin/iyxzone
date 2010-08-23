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

