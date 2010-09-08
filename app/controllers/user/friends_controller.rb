class User::FriendsController < UserBaseController

  layout 'app'
  
  def index
    @game = Game.find(params[:game_id]) unless params[:game_id].nil?
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?

    case params[:term].to_i
    when 0
      @friends = current_user.friends.paginate :page => params[:page], :per_page => 12, :order => 'login ASC', :include => :profile
    when 1
      @friends = current_user.friends.find_all {|f| f.has_game?(@game) }.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    when 2
      @friends = current_user.friends.find_all {|f| f.all_guilds.include?(@guild) }.paginate :page => params[:page], :per_page => 12, :order => 'created_at DESC'
    end
  end

  def new
		@common_friends = @user.common_friends_with(current_user).sort_by{rand}[0..7]
    @friends = @user.friends.limit(8)
		@guilds = @user.all_guilds.limit(3)
    @skin = @profile.skin
    @viewings = @profile.viewings.limit(8)
    @messages = @profile.comments.nonblocked.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => @profile.id, :wall_type => 'Profile'}}
    render :action => 'new', :layout => 'app4'
  end

  def other
    @friends = @user.friends.paginate :page => params[:page], :per_page => 18, :include => [:profile]
  end

  def common
    @friends = @user.common_friends_with(current_user).paginate :page => params[:page], :per_page => 18, :include => [:profile]
  end

  def destroy
    if @friendship.cancel
      render_js_code "tip('删除成功');$('friend_#{params[:id]}').remove();"
    else
      render_js_error
    end
  end

  def search
    @friends = current_user.friends.search(params[:key])
    @friends = @friends.paginate :page => params[:page], :per_page => 12, :order => 'pinyin ASC'
    @remote = {:update => 'friends', :url => {:action => 'search', :key => params[:key]}}
    render :partial => 'friends', :locals => {:friends => @friends, :remote => @remote}
  end

protected

  def setup
    if ["destroy"].include? params[:action]
      @friendship = current_user.friendships.find_by_friend_id(params[:id])
      !@friendship.blank? || render_not_found
    elsif ["new"].include? params[:action]
      @user = User.find(params[:uid])
      @profile = @user.profile
      require_none_friend @user
    elsif ["other", "common"].include? params[:action]
      @user = User.find(params[:uid])
      require_none_owner @user
    end
  end
  
end
