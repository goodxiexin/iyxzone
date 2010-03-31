class User::FriendsController < UserBaseController

  layout 'app'
  
  def index
		@user = current_user
    @game = Game.find(params[:game_id]) unless params[:game_id].nil?
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
    case params[:term].to_i
    when 0
      @friends = current_user.friends.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    when 1
      @friends = current_user.friends.find_all {|f| f.games.include?(@game) }.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    when 2
      @friends = current_user.friends.find_all {|f| f.all_guilds.include?(@guild) }.paginate :page => params[:page], :per_page => 12, :order => 'created_at DESC'
    end
  end

  def new
		@common_friends = @user.common_friends_with(current_user).sort_by{rand}[0..7]
    render :action => 'new', :layout => 'app2'
  end

  # other people's friends list
  def other
    @friends = @user.friends.paginate :page => params[:page], :per_page => 18
  end

  # common friends with ...
  def common
    @friends = @user.common_friends_with(current_user).paginate :page => params[:page], :per_page => 18
  end

  def destroy
    if @friendship.destroy && @friendship.reverse.destroy
      render :update do |page|
        page << "tip('删除成功');$('friend_#{params[:id]}').remove();"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def search
    @friends = current_user.friends.search(params[:key])
    @friends = @friends.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    @remote = {:update => 'friends', :url => {:action => 'search', :key => params[:key]}}
    render :partial => 'friends', :object => @friends
  end

protected

  def setup
    if ["destroy"].include? params[:action]
      @friendship = current_user.friendships.find_by_friend_id(params[:id])#Friendship.find_by_friend_id(params[:friend_id])
      #require_owner @friendship.user
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
