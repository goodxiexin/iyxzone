class User::ProfilesController < UserBaseController

  layout 'app2'

  increment_viewing 'profile', 'id', :only => [:show]

	FirstFetchSize = 10

	FetchSize = 10

  def show
    @common_friends = @user.common_friends_with(current_user).sort_by{rand}[0..2] if @relationship != 'owner'
    @friends = @user.friends.sort_by{rand}[0..2]
		@blogs = @user.blogs.for(@relationship).limit(3)
		@albums = @user.active_albums.for(@relationship).limit(3)
    @feed_deliveries = @profile.feed_deliveries.limit(FirstFetchSize).order('created_at DESC').prefetch([{:feed_item => :originator}])
		@first_fetch_size = FirstFetchSize
    @skin = @profile.skin
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @viewings = @profile.viewings.limit(6).prefetch([{:viewer => :profile}])
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
    if @profile.update_attributes(params[:profile])
			respond_to do |format|
				format.html {
					case params[:type].to_i
					when 1
					  render :partial => 'basic_info', :locals => {:profile => @profile, :setting => @setting, :relationship => @relationship}
					when 2
					  render :partial => 'contact_info', :locals => {:profile => @profile, :setting => @setting, :relationship => @relationship}
          when 3
            render :partial => 'characters', :locals => {:profile => @profile, :setting => @setting, :relationship => @relationship}
					end
				}
				format.json { render :json => @profile.to_json }
			end
    end
  end

	def more_feeds
		@feed_deliveries = @profile.feed_deliveries.offset(FirstFetchSize + FetchSize * params[:idx].to_i).limit(FetchSize).order('created_at DESC')
		@fetch_size = FetchSize
	end

protected

  def setup
		if ["more_feeds", "show", "edit"].include? params[:action]
			@profile = Profile.find(params[:id])
			@user = @profile.user
      @relationship = @user.relationship_with current_user
      require_adequate_privilege @profile, @relationship
    elsif ["update"].include? params[:action]
      @profile = Profile.find(params[:id])
      require_owner @profile.user
      @user = @profile.user
      @setting = @user.privacy_setting
      @relationship = @user.relationship_with current_user
    end
  end

  def require_adequate_privilege profile, relationship
    profile.available_for?(relationship) || render_add_friend(profile.user)
  end
  
end
