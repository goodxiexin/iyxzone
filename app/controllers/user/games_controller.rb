class User::GamesController < UserBaseController

  layout 'app2'

  FirstFetchSize = 5
  
  FetchSize = 5

  PER_PAGE = PER_PAGE

  def index
    @games = @user.games.paginate :page => params[:page], :per_page => PER_PAGE
    render :action => "index", :layout => "app"      
  end

  def friends
    @game_ids = GameCharacter.by(current_user.friend_ids).map(&:game_id).uniq
    @games = Game.find(@game_ids).paginate :page => params[:page], :per_page => PER_PAGE
    render :action => "friends", :layout => "app"
  end

  #
  # sexy 和 hot 的区别是
  # sexy是按照过去一周这个游戏有多少游戏角色而定的
  # hot是按照这一周里有多少人关注这个游戏而定的
  # 
  def sexy
    @games = Game.sexy.paginate :page => params[:page], :per_page => PER_PAGE
    render :action => "sexy", :layout => "app"
  end

  def interested
    @games = current_user.interested_games.paginate :page => params[:page], :per_page => PER_PAGE
    render :action => 'interested', :layout => 'app'
  end

  def show
logger.error 'show'
    @game = Game.find(params[:id], :include => [{:comments => [:commentable, {:poster => :profile}]}, :tags])
    @events = @game.events.nonblocked.prefetch([{:album => :cover}]).people_order.limit(4)
    @guilds = @game.guilds.nonblocked.prefetch([{:album => :cover}, {:president => :profile}]).people_order.limit(4)
    @albums = @game.albums.nonblocked.for('friend').prefetch([:cover]).limit(3)
    @blogs = @game.blogs.nonblocked.for('friend').prefetch([{:poster => :profile}]).limit(3)
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
		@has_game = current_user.has_game? @game
    if @has_game
      servers = current_user.servers.match(:game_id => @game.id)
      @comrades = GameCharacter.random(:limit => 6, :except => current_user.characters, :conditions => {:server_id => servers.map(&:id)}, :include => [{:user => :profile}])
		end
		@players = GameCharacter.random(:limit => 6, :except => current_user.characters, :conditions => {:game_id => @game.id}, :include => [{:user => :profile}])
    @attention = @game.attentions.find_by_user_id(current_user.id)
    @messages = @game.comments.nonblocked.prefetch([{:poster => :profile}, :commentable]).paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => @game.id, :wall_type => 'game'}}
    @feed_deliveries = @game.feed_deliveries.limit(FirstFetchSize).order('created_at DESC')
		@first_fetch_size = FirstFetchSize
  end

  def hot
    @games = Game.hot.paginate :page => params[:page], :per_page => PER_PAGE
    render :action => 'hot', :layout => 'app'
  end

  def beta
    @games = Game.beta.paginate :page => params[:page], :per_page => 5
    render :action => 'beta', :layout => 'app'
  end

  def more_feeds
    @game = Game.find(params[:id])
    @feed_deliveries = @game.feed_deliveries.offset(FirstFetchSize + FetchSize * params[:idx].to_i).limit(FetchSize).order("created_at DESC")
		@fetch_size = FetchSize
  end

protected

  def setup
    if ["index", "interested"].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    end
  end

end
