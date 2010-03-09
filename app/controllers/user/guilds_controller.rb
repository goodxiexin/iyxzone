class User::GuildsController < UserBaseController

  layout 'app'

	FirstFetchSize = 5
	
	FetchSize = 5

  def index
    @guilds = @user.guilds.paginate :page => params[:page], :per_page => 10
  end

	def participated
    @guilds = @user.participated_guilds.paginate :page => params[:page], :per_page => 10
	end

	def hot
    cond = user_game_conds
    @guilds = Guild.hot.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10	
  end

  def recent
    cond = user_game_conds
    @guilds = Guild.recent.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
	end

  def friends
    @guilds = current_user.guild_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10
  end

  def show
    @memberships = @guild.memberships_for current_user
    @role = @guild.role_for current_user
    @album = @guild.album
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
		@feed_deliveries = @guild.feed_deliveries.find(:all, :limit => FetchSize, :order => "created_at DESC")
		@first_fetch_size = FirstFetchSize
		render :action => 'show', :layout => 'app2'
	end

  def new
  end

  def create
    guild_params = (params[:guild] || {}).merge({:president_id => current_user.id})
    @guild = Guild.new(guild_params)
    if @guild.save
      redirect_to guild_url(@guild)
    else
      render :action => 'new'
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def edit_rules
    render :action => 'edit_rules'
  end

  def update
    if @guild.update_attributes(params[:guild])
      render :text => @guild.description
    end
  end

	def more_feeds
		@feed_deliveries = @guild.feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize * params[:idx].to_i, :limit => FetchSize)
		@fetch_size = FetchSize
  end

  def search
    case params[:type].to_i
    when 1
      @guilds = Guild.hot.search(params[:key]).paginate :page => params[:page], :per_page => 5
    when 2
      @guilds = Guild.recent.search(params[:key]).paginate :page => params[:page], :per_page => 5
    end
    @remote = {:update => 'guilds', :url => {:action => 'search', :controller => 'user/guilds', :type => params[:type], :key => params[:key]}}
    render :partial => 'user/guilds/guilds', :object => @guilds
  end

protected

  def setup
    if ['index', 'participated'].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ['show', 'more_feeds'].include? params[:action]
      @guild = Guild.find(params[:id])
    elsif ['edit', 'edit_rules', 'update'].include? params[:action]
      @guild = Guild.find(params[:id])
      require_owner @guild.president
    end
  end

end
