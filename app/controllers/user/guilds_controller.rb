class User::GuildsController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  PREFETCH = [:forum, {:president => :profile}, {:game_server => [:area, :game]}, {:album => :cover}]

  def index
    @guilds = @user.guilds.nonblocked.paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

	def participated
    @guilds = @user.participated_guilds.nonblocked.paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
	end

	def hot
    @guilds = Guild.hot.nonblocked.match(user_game_conds).paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def recent
    @guilds = Guild.recent.nonblocked.match(user_game_conds).paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
	end

  def friends
    @guild_ids = Membership.authorized.by(current_user.friend_ids).map(&:guild_id).uniq
    @guilds = Guild.nonblocked.order('created_at DESC').match(:id => @guild_ids).paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def show
    @mini_blogs = MiniBlog.category(:all).by(@guild.people_ids).recent.limit(3).all
    @hot_words = HotWord.recent.limit(3)
    @members = @guild.people.limit(12).prefetch(:profile)
    @events = @guild.events.people_order.limit(3).prefetch([{:album => :cover}])
    @memberships = @guild.memberships.prefetch([:character]).by(current_user.id)
    @role = @guild.role_for current_user
    @fetch_size = 10
    @feed_deliveries = @guild.feed_deliveries.limit(@fetch_size).all
    render :action => 'show', :layout => 'app3'
	end

  def new
    @guild = Guild.new
  end

  def create
    @guild = current_user.guilds.build(params[:guild] || {})
    
    if @guild.save
      render :json => {:code => 1, :id => @guild.id}
    else
      render :json => {:code => 0}
    end
  end

  def update
    if @guild.update_attributes(params[:guild])
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
    if @guild.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end 
  end

  def search
    case params[:type].to_i
    when 1
      @guilds = Guild.hot.nonblocked.search(params[:key]).paginate :page => params[:page], :per_page => PER_PAGE
    when 2
      @guilds = Guild.recent.nonblocked.search(params[:key]).paginate :page => params[:page], :per_page => PER_PAGE
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
      @guild = Guild.find(params[:id], :include => [:forum, :game, {:president => :profile}])
      require_verified @guild
    elsif ['edit_rules', 'update', 'destroy'].include? params[:action]
      @guild = Guild.find(params[:id])
      require_verified @guild
      require_owner @guild.president unless params[:action] == 'edit_rules'
    end
  end

end
