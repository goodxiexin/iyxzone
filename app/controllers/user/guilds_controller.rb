class User::GuildsController < UserBaseController

  layout 'app'

	FirstFetchSize = 5
	
	FetchSize = 5

  PER_PAGE = 10

  PREFETCH = [:forum, {:president => :profile}, {:game_server => [:area, :game]}, {:album => :cover}]

  def index
    @guilds = @user.guilds.nonblocked.prefetch(PREFETCH).paginate :page => params[:page], :per_page => PER_PAGE
  end

	def participated
    @guilds = @user.participated_guilds.nonblocked.prefetch(PREFETCH).paginate :page => params[:page], :per_page => PER_PAGE
	end

	def hot
    @guilds = Guild.hot.nonblocked.prefetch(PREFETCH).match(user_game_conds).paginate :page => params[:page], :per_page => PER_PAGE
  end

  def recent
    @guilds = Guild.recent.nonblocked.prefetch(PREFETCH).match(user_game_conds).paginate :page => params[:page], :per_page => PER_PAGE
	end

  def friends
    @guilds = Guild.nonblocked.prefetch(PREFETCH).match(:id => Membership.by(current_user.friend_ids).map(&:guild_id).uniq).paginate :page => params[:page], :per_page => PER_PAGE
  end

  def show
    @guild_characters = @guild.characters.all(:include => [{:user => :profile}], :limit => 6) 

    @hot_topics = @guild.forum.hot_topics.all(:include => [:forum], :limit => 6)

    @events = @guild.events.all(:include => [{:album => :cover}], :order => "confirmed_count DESC", :limit => 4)

    @memberships = @guild.all_memberships_for current_user
    @role = @guild.role_for current_user

    @album = @guild.album
    @photos = @album.latest_photos
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?

		@feed_deliveries = @guild.feed_deliveries.find(:all, :limit => FetchSize, :order => "created_at DESC")
		@first_fetch_size = FirstFetchSize

		@messages = @guild.comments.paginate :page => params[:page], :per_page => 10, :include => [{:poster => :profile}, :commentable]
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => @guild.id, :wall_type => 'guild'}}

    render :action => 'show', :layout => 'app2'
	end

  def new
    @guild = Guild.new
  end

  def create
    @guild = current_user.guilds.build(params[:guild] || {})
    if @guild.save
      redirect_to new_guild_invitation_url(@guild)
    else
      render :action => 'new'
    end
  end

  def edit_rules
    render :action => 'edit_rules'
  end

  def update
    if @guild.update_attributes(params[:guild])
      render :json => @guild
    end
  end

  def destroy
    if @guild.destroy
      render :update do |page|
        page.redirect_to guilds_url(:uid => current_user.id)
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end 
  end

	def more_feeds
		@feed_deliveries = @guild.feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize * params[:idx].to_i, :limit => FetchSize)
		@fetch_size = FetchSize
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
      require_owner @guild.president unless params[:action] == 'edit_rules'
    end
  end

end
