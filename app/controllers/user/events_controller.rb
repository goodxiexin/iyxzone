class User::EventsController < UserBaseController

  layout 'app'

  def index
    @events = @user.events.paginate :page => params[:page], :per_page => 10, :include => [:guild, {:poster => :profile}, {:game_server => [:game, :area]}, {:album => :cover}] 
  end

	def hot
    cond = user_game_conds
    @events = Event.hot.find(:all, :conditions => cond, :include => [:guild, {:poster => :profile}, {:game_server => [:game, :area]}, {:album => :cover}]).paginate :page => params[:page], :per_page => 10
  end

  def recent
    cond = user_game_conds
    @events = Event.recent.all(:conditions => cond, :include => [:guild, {:poster => :profile}, {:game_server => [:game, :area]}, {:album => :cover}]).paginate :page => params[:page], :per_page => 10
	end

  def upcoming
    @events = @user.upcoming_events.paginate :page => params[:page], :per_page => 10, :include => [:guild, {:poster => :profile}, {:game_server => [:game, :area]}, {:album => :cover}]
  end

  def participated
    @events = @user.participated_events.paginate :page => params[:page], :per_page => 10, :include => [:guild, {:poster => :profile}, {:game_server => [:game, :area]}, {:album => :cover}] 
  end

  def friends
    @events = current_user.friend_events.paginate :page => params[:page], :per_page => 10
  end

  def show
    @maybe_characters = @event.maybe_characters.find(:all, :limit => 6, :include => [{:user => :profile}])
    @invite_characters = @event.invite_characters.find(:all, :limit => 6, :include => [{:user => :profile}])
    @request_characters = @event.request_characters.find(:all, :limit => 6, :include => [{:user => :profile}])		
    @confirmed_characters = @event.confirmed_characters.find(:all, :limit => 6, :include => [{:user => :profile}])

    @user = @event.poster
    @album = @event.album

		@reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @participations = @event.participations_for current_user

    @messages = @event.comments.paginate :page => params[:page], :per_page => 10, :include => [:commentable, {:poster => :profile}]
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => @event.id, :wall_type => 'event'}}

		render :action => 'show', :layout => 'app2'
  end

  def new
    @event = Event.new
    unless @guild.blank?
			@characters = @guild.characters.find(:all, :conditions => "game_characters.user_id = #{current_user.id} AND (memberships.status = 3 OR memberships.status = 4)")
		end
  end

  def create
    event_opts = (params[:event] || {}).merge({:poster_id => current_user.id})
    @event = Event.new(event_opts)
    if @event.save
      redirect_to new_event_invitation_url(@event)
    else
      if @event.is_guild_event?
        render :action => 'new', :guild_id => @event.guild_id
      else
        render :action => 'new'
      end
    end
  end

  def edit
    render :action => 'edit'
  end

  def update
    event_opts = (params[:event] || {}).merge({:poster_id => current_user.id})
    if @event.update_attributes(event_opts)
      redirect_to event_url(@event)
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @event.destroy
      render :update do |page|
        page.redirect_to events_url(:uid => current_user.id)
      end
    else
      render :update do |page|
        page << "error('发生错误, 可能该活动已经过期了');"
      end
    end
  end  

  #
  # 这个方法在目前的页面用不上
  #
  def search
    case params[:type].to_i
    when 0
      @events = current_user.upcoming_events.search(params[:key]).paginate :page => params[:page], :per_page => 10
    when 1
      @events = Event.hot.search(params[:key]).paginate :page => params[:page], :per_page => 10
    when 2
      @events = Event.recent.search(params[:key]).paginate :page => params[:page], :per_page => 10
    when 3
      @events = current_user.past_events.search(params[:key]).paginate :page => params[:page], :per_page => 10
    end
    @remote = {:update => 'events', :url => {:action => 'search', :controller => 'user/events', :type => params[:type], :key => params[:key]}}
    render :partial => 'user/event/events', :object => @events
  end

protected

  def setup
    if ['new'].include? params[:action]
      @guild = current_user.privileged_guilds.find(params[:guild_id]) if !params[:guild_id].blank?
    elsif ['show'].include? params[:action]
      @event = Event.find(params[:id], :include => [:game, :game_server, :game_area, {:comments => [{:poster => :profile}]}, :guild])
      require_verified @event
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @event = Event.find(params[:id])
      require_verified @event 
      require_owner @event.poster
      require_event_not_expired @event
    elsif ['index', 'upcoming', 'participated'].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    end
  end

  def require_event_not_expired event
    if event.expired?
      render :update do |page|
        page << "tip('该活动已经过期了，无法删除');"
      end 
    end
  end
  
end

