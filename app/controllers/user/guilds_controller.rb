class User::GuildsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit, :update]

	FirstFetchSize = 5
	
	FetchSize = 5

  def index
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @guilds = @user.guilds.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
  end

	def participated
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @guilds = @user.participated_guilds.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
	end

	def hot
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @guilds = Guild.hot.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10	
  end

  def recent
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @guilds = Guild.recent.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
	end

  def friends
    @guilds = current_user.guild_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10
  end

  def show
    @comments = @guild.comments.paginate :page => 1, :per_page => 10
    @membership = @guild.memberships.find_by_user_id(current_user.id)
    @album = @guild.album
		@feed_deliveries = @guild.feed_deliveries.find(:all, :limit => FetchSize)
		render :action => 'show', :layout => 'app2'
	end

  def new
  end

  def create
    @guild = Guild.new(params[:guild].merge({:president_id => current_user.id}))# virtual attribute
    if @guild.save
			unless params[:photo].blank?
				@photo = @guild.album.photos.create(params[:photo])
				@guild.album.update_attribute('cover_id', @photo.id) 
			end
      redirect_to guild_url(@guild)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @guild.update_attributes(params[:guild])
      redirect_to guild_url(@guild)
    else
      render :action => 'edit'
    end
  end

	def more_feeds
		@feed_deliveries = @guild.feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize * params[:idx].to_i, :limit => FetchSize)
  end

  def search
    case params[:type].to_i
    when 1
      @guilds = Guild.hot.search(params[:key]).paginate :page => params[:page], :per_page => 5
    when 2
      @guilds = Guild.recent.search(params[:key]).paginate :page => params[:page], :per_page => 5
    end
    @remote = {:update => 'guilds', :url => {:action => 'search', :controller => 'guild/guilds', :type => params[:type], :key => params[:key]}}
    render :partial => 'guild/guilds', :object => @guilds
  end

protected

  def setup
    if ['index', 'participated', 'hot', 'recent'].include? params[:action]
      @user = User.find(params[:id])
    elsif ['show', 'edit', 'update', 'more_feeds'].include? params[:action]
      @guild = Guild.find(params[:id])
      @user = @guild.president
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
		elsif ['new', 'create'].include? params[:action]
			@user = current_user
    end
  rescue
    not_found
  end

end
