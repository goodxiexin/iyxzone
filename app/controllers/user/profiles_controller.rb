class User::ProfilesController < UserBaseController

  layout 'app4'

  increment_viewing 'profile', :only => [:show]

	FirstFetchSize = 10

	FetchSize = 10

	FetchGame = 10

  def show
    # mini blogs
    @mini_blogs = @user.mini_blogs.limit(3).all
    @common_friends = @user.common_friends_with(current_user).sort_by{rand}[0..7] if @relationship != 'owner'
    @friends = @user.friends.limit(8)
    @fans = @user.fans.limit(8).all if @user.is_idol
		@blogs = @user.blogs.for(@relationship).limit(3)
		@albums = @user.active_albums.for(@relationship).limit(3)
    @feed_deliveries = @profile.feed_deliveries.limit(FirstFetchSize).order('created_at DESC').prefetch([{:feed_item => :originator}]).all
		@first_fetch_size = FirstFetchSize
    @skin = @profile.skin
		@guilds = @user.all_guilds.limit(3)
		limit = (@user.games_count > FetchGame) ? FetchGame : @user.games_count
		@more_game = (@user.games_count > FetchGame)
		@games = @user.games[0..(limit -1)]
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

    if @profile.update_attributes(params[:profile])
			respond_to do |format|
				format.html {
					case params[:type].to_i
					when 1
					  render :partial => 'basic_info', :locals => {:profile => @profile, :setting => @setting, :relationship => 'owner'}
					when 2
					  render :partial => 'contact_info', :locals => {:profile => @profile, :setting => @setting, :relationship => 'owner'}
          when 3
            render :partial => 'characters', :locals => {:profile => @profile, :setting => @setting, :relationship => 'owner'}
					end
				}
				format.json { render :json => @profile.to_json }
			end
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
			@feed_deliveries = @profile.feed_deliveries.limit(FirstFetchSize).order('created_at DESC').prefetch([{:feed_item => :originator}]).all
			render :partial => "feed_list", :locals => {:feed_deliveries => @feed_deliveries, :first_fetch_size => @first_fetch_size, :profile => @profile}
		elsif @category == 'poll'
			@polls = @user.polls.limit(3)
			render :partial => "recent_polls", :locals => {:user => @user, :profile => @profile, :polls => @polls}
		elsif @category == 'album'
			@feed_deliveries = @profile.feed_deliveries.category(@category).limit(3).order('created_at DESC').prefetch([{:feed_item => :originator}]).all
			render :partial => "recent_photos", :locals => {:feed_deliveries => @feed_deliveries}
		elsif @category == 'blog'
			@blogs = @user.blogs.for(@relationship).limit(5)
			render :partial => "recent_blogs", :locals => {:user => @user, :profile => @profile, :blogs => @blogs}
		elsif @category == 'video'
			@videos = @user.videos.for(@relationship).limit(3)
			render :partial => "recent_videos", :locals => {:user => @user, :profile => @profile, :videos => @videos}
		end
	end

	def more_games
		idx = params[:idx].to_i
		top_limit = (idx+1) * FetchGame
		bot_limit = idx * FetchGame
		limit = (@user.games_count > top_limit) ? top_limit : @user.games_count
		@games = @user.games[bot_limit..(limit -1)]
		render :partial => "games_display", :locals => {:user => @user, :profile => @profile, :games => @games}
	end

	def game_display
		@game = Game.find(params[:game])
		@characters = @user.characters.within(params[:game])
		@friends = @game.characters.by(@user.friend_ids).map(&:user)
		render :partial => "game_display", :locals => {:user => @user, :profile => @profile, :characters => @characters, :game => @game, :friends => @friends}
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
