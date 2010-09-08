class User::ProfilesController < UserBaseController

  layout 'app4'

  increment_viewing 'profile', :only => [:show]

	FirstFetchSize = 10

	FetchSize = 10

	FetchGame = 5

  def show
    # mini blogs
    @mini_blogs = @user.mini_blogs.limit(3).all
    @common_friends = @user.common_friends_with(current_user).sort_by{rand}[0..7] if @relationship != 'owner'
    @friends = @user.friends.limit(8)
    @fans = @user.fans.limit(8).all if @user.is_idol
		@blogs = @user.blogs.for(@relationship).limit(3)
		@albums = @user.active_albums.for(@relationship).limit(3)
    @feed_deliveries = @profile.feed_deliveries.limit(FirstFetchSize).all
		@first_fetch_size = FirstFetchSize
    @skin = @profile.skin
		@guilds = @user.all_guilds.limit(3)
		@games = @user.games.limit(FetchGame).all
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @viewings = @profile.viewings.limit(8)
    @characters = @user.characters.prefetch([:game])
    @messages = @profile.comments.nonblocked.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => @profile.id, :wall_type => 'Profile'}}
	end

  def edit
    @setting = @user.privacy_setting
    case params[:type].to_i
		when 1
      render :partial => 'edit_basic_info'
    when 2
      render :partial => 'edit_contact_info'
    when 3
      render :partial => 'edit_characters'
    end
  end

  def update
    params[:profile].delete(:login) if params[:profile]
    @type = case params[:type].to_i
      when 1 then 'basic_info'
      when 2 then 'contact_info'
      when 3 then 'characters'
    end

    if @profile.update_attributes(params[:profile])
      if @type
        render :json => {:code => 1, :html => partial_html(@type, :locals => {:profile => @profile, :setting => @setting, :relationship => 'owner'})}
      else
        render :json => {:code => 1}
      end
    else
      render :json => {:code => 0}
    end
  end

	def change_tab
		@category = params[:category].blank? ? 'home' : params[:category]
		if @category == 'home'
			@mini_blogs = @user.mini_blogs.limit(3).all
			@games = @user.games
			render :partial => "home_tab_info", :locals => {:user => @user, :profile => @profile, :mini_blogs => @mini_blogs, :games => @games}
		elsif @category == 'info'
			@setting = @user.privacy_setting
			render :partial => "edit_info", :locals => {:user => @user, :profile => @profile, :setting => @setting, :relationship => @relationship}
		elsif @category == 'feed'
			@first_fetch_size = FirstFetchSize
			@feed_deliveries = @profile.feed_deliveries.limit(FirstFetchSize).all
			render :partial => "feed_list", :locals => {:feed_deliveries => @feed_deliveries, :first_fetch_size => @first_fetch_size, :profile => @profile}
		elsif @category == 'poll'
			@polls = @user.polls.limit(3)
			render :partial => "recent_polls", :locals => {:user => @user, :profile => @profile, :polls => @polls}
		elsif @category == 'photo'
			@feed_deliveries = @profile.feed_deliveries.match(:item_type => ["PersonalAlbum", "EventAlbum", "GuildAlbum"]).limit(3).all
			render :partial => "recent_photos", :locals => {:user => @user, :profile => @profile, :feed_deliveries => @feed_deliveries}
		elsif @category == 'blog'
			@blogs = @user.blogs.for(@relationship).limit(5)
			render :partial => "recent_blogs", :locals => {:user => @user, :profile => @profile, :blogs => @blogs}
		elsif @category == 'video'
			@videos = @user.videos.for(@relationship).limit(3)
			render :partial => "recent_videos", :locals => {:user => @user, :profile => @profile, :videos => @videos}
		end
	end

	def more_games
    @games = @user.games.offset(params[:idx].to_i * FetchGame).limit(FetchGame)
		render :partial => "games_display", :locals => {:user => @user, :profile => @profile, :games => @games}
	end

	def game_display
		@game = Game.find(params[:game_id])
		@characters = @user.characters.within(@game.id)
		@friends_count = @game.characters.by(@user.friend_ids).map(&:user_id).uniq.count
		render :partial => "game_display", :locals => {:user => @user, :profile => @profile, :characters => @characters, :game => @game, :friends_count => @friends_count}
	end

	def more_feeds
		@feed_deliveries = @profile.feed_deliveries.offset(FirstFetchSize + FetchSize * params[:idx].to_i).limit(FetchSize).order('created_at DESC').all
		@fetch_size = FetchSize
	end

protected

  def setup
    if ["show"].include? params[:action]
      if params[:subdomain]
        @subdomain = Subdomain.find_by_name(params[:subdomain])
        if @subdomain.blank?
          render_not_found
          return
        else
          @user = @subdomain.user
          @profile = @user.profile
        end
      else
        @profile = Profile.find(params[:id])
        @user = @profile.user
      end
      @relationship = current_user.relationship_with @user
      require_adequate_privilege @profile, @relationship
		elsif ["more_feeds", "edit", "change_tab", "game_display", "more_games"].include? params[:action]
			@profile = Profile.find(params[:id])
			@user = @profile.user
      @relationship = @user.relationship_with current_user
      require_adequate_privilege @profile, @relationship
    elsif ["update"].include? params[:action]
      @profile = Profile.find(params[:id])
      require_owner @profile.user
      @user = @profile.user
      @setting = @user.privacy_setting
    end
  end

  def require_adequate_privilege profile, relationship
    profile.available_for?(relationship) || is_admin || render_add_friend(profile.user)
  end
  
end
