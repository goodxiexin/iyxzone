class User::Profiles::SkinsController < UserBaseController

  layout 'app2'

  FirstFetchSize = 5

  FetchSize = 5

	FetchGame = 10

  def show
    @user = current_user
    @profile = @user.profile
    @setting = @user.privacy_setting
    @skins = @profile.accessible_skins
    @idx = @skins.index(@skin)
    @prev = @skins[(@idx - 1 + @skins.count) % @skins.count]
    @next = @skins[(@idx + 1) % @skins.count] 

    @friends = @user.friends.sort_by{rand}[0..2]
		@guilds = @user.all_guilds.limit(3)
    @mini_blogs = @user.mini_blogs.limit(3).all
		@games = @user.games[0..(FetchGame - 1)]
    @blogs = @user.blogs.find(:all, :conditions => @cond, :offset => 0, :limit => 3)
    @albums = @user.active_albums.find(:all, :conditions => @cond, :offset => 0, :limit => 3)
    @feed_deliveries = @profile.feed_deliveries.all(:limit => FirstFetchSize, :order => 'created_at DESC', :include => [{:feed_item => :originator}])
    @first_fetch_size = FirstFetchSize
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @viewings = @profile.viewings.all(:include => [{:viewer => :profile}], :limit => 6)
    @characters = @user.characters.all(:include => [:game])
    # wall messages
    @messages = @profile.comments.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => @profile.id, :wall_type => 'profile'}}

    render :action => 'show', :layout =>'skins'
  end

  def index
    @skins = current_user.profile.accessible_skins.paginate :page => params[:page], :per_page => 9
    render :layout => 'app'
  end

protected

  def setup
    if ['show'].include? params[:action]
      @skin = Skin.find(params[:id])
      require_skin_accessible @skin
    end
  end

  def require_skin_accessible skin
    skin.accessible_for?(current_user.profile) || render_not_found
  end

end
