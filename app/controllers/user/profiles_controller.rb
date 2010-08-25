class User::ProfilesController < UserBaseController

  layout 'app2'

  increment_viewing 'profile', :only => [:show]

	FirstFetchSize = 10

	FetchSize = 10

  def show
    # mini blogs
    @mini_blogs = @user.mini_blogs.limit(3).all
    @common_friends = @user.common_friends_with(current_user).sort_by{rand}[0..2] if @relationship != 'owner'
    @friends = @user.friends.limit(3)
    @fans = @user.fans.limit(9).all if @user.is_idol
		@blogs = @user.blogs.for(@relationship).limit(3)
		@albums = @user.active_albums.for(@relationship).limit(3)
    @feed_deliveries = @profile.feed_deliveries.limit(FirstFetchSize).order('created_at DESC').prefetch([{:feed_item => :originator}]).all
		@first_fetch_size = FirstFetchSize
    @skin = @profile.skin
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @viewings = @profile.viewings.limit(3)
    @characters = @user.characters.prefetch([:game])
    @messages = @profile.comments.nonblocked.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => @profile.id, :wall_type => 'Profile'}}
	end

  def edit
    @setting = @user.privacy_setting
    case params[:type].to_i
    when 0
			render :action => 'edit', :layout => 'app'
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
      render :json => {:code => 1, :html => partial_html(@type, :locals => {:profile => @profile, :setting => @setting, :relationship => 'owner'})}
    else
      render :json => {:code => 0}
    end
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
		elsif ["more_feeds", "edit"].include? params[:action]
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
