class User::GamesController < UserBaseController

  layout 'app2'

  FirstFetchSize = 5
  
  FetchSize = 5

  def index
    @games = @user.games.paginate :page => params[:page], :per_page => 10
    render :action => "index", :layout => "app"      
  end

  def friends
    @games = current_user.friend_games.paginate :page => params[:page], :per_page => 10
    render :action => "friends", :layout => "app"
  end

  #
  # sexy 和 hot 的区别是
  # sexy是按照过去一周这个游戏有多少游戏角色而定的
  # hot是按照这一周里有多少人关注这个游戏而定的
  # 
  def sexy
    @games = Game.sexy.paginate :page => params[:page], :per_page => 10
    render :action => "sexy", :layout => "app"
  end

  def interested
    @games = current_user.interested_games.paginate :page => params[:page], :per_page => 10
    render :action => 'interested', :layout => 'app'
  end

  def show
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
		
    @comrades = []
		if current_user.games.include?(@game)
			current_user.servers.find(:all, :conditions=> {:game_id => @game.id}).each {|server| 
				@comrades = @comrades | server.characters
			}
		end
		@players = @game.characters.find(:all)	
    @attention = @game.attentions.find_by_user_id(current_user.id)
    @messages = @game.comments.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => @game.id, :wall_type => 'game'}}

    @albums = @game.albums.find(:all, :conditions => "privilege != 4 AND photos_count != 0", :limit => 3)
    @blogs = @game.blogs.find(:all, :conditions => "privilege != 4", :limit => 3)
    @has_game = current_user.has_game? @game
    @feed_deliveries = @game.feed_deliveries.find(:all, :limit => FirstFetchSize, :order => 'created_at DESC')
		@first_fetch_size = FirstFetchSize
  end

  def hot
    @games = Game.hot.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'hot_games_list', :url => {:action => 'hot'}} 
    render :action => 'hot', :layout => 'app'
  end

  def beta
    @games = Game.beta.paginate :page => params[:page], :per_page => 1
    @remote = {:update => 'beta_games_list', :url => {:action => 'beta'}}
    render :action => 'beta', :layout => 'app'
  end

  def more_feeds
    @feed_deliveries = @game.feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize * params[:idx].to_i, :limit => FetchSize, :order => "created_at DESC")
		@fetch_size = FetchSize
  end

protected

  def setup
    if ["index", "interested"].include? params[:action]
      @user = User.find(params[:uid]) 
    elsif ["more_feeds", "show"].include? params[:action]
      @game = Game.find(params[:id])
    end
  end

end
