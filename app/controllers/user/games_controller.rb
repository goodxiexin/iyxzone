class User::GamesController < UserBaseController

  layout 'app'

  PER_PAGE = 10 

  def index
		@games = @user.games.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def friends
    @games = GameCharacter.by(current_user.friend_ids).group_by(&:game).sort{|a, b| b.second.length <=> a.second.length}.map{|game, characters| game}.paginate :page => params[:page], :per_page => PER_PAGE
  end

  #
  # sexy 和 hot 的区别是
  # sexy是按照过去一周这个游戏有多少游戏角色而定的
  # hot是按照这一周里有多少人关注这个游戏而定的
  # 
  def sexy
    @games = Game.sexy.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def interested
    @games = @user.interested_games.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def show
    @game = Game.find(params[:id], :include => [{:comments => [:commentable, {:poster => :profile}]}, :tags])
    @mini_blogs = MiniBlog.search("content: '#{@game.name}'", :sort => "created_at DESC", :page => 1, :per_page => 3)
    #@mini_blogs = MiniBlog.by(@game.users.limit(3).map(&:id)).limit(3).all if @mini_blogs.blank?
    @hot_words = HotWord.recent.limit(3)
    @events = @game.events.nonblocked.limit(3).people_order.prefetch([{:album => :cover}])
    @guilds = @game.guilds.nonblocked.limit(3).people_order.prefetch([{:album => :cover}, {:president => :profile}])
    @has_game = current_user.has_game? @game
		if @has_game
      servers = current_user.servers.match(:game_id => @game.id)
      @comrades = GameCharacter.random(:limit => 8, :except => current_user.characters, :conditions => {:server_id => servers.map(&:id)}, :include => [{:user => :profile}])
		end
		@players = GameCharacter.random(:limit => 8, :except => current_user.characters, :conditions => {:game_id => @game.id}, :include => [{:user => :profile}])
    @fetch_size = 10
    @feed_deliveries = @game.feed_deliveries.limit(@fetch_size).all
    render :action => 'show', :layout => 'app3'
  end

  def hot
    @games = Game.hot.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def beta
    @games = Game.beta.paginate :page => params[:page], :per_page => PER_PAGE
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
