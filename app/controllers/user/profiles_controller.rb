class User::ProfilesController < UserBaseController

  layout 'app2'

  increment_viewing 'profile', 'id', :only => [:show]

	FirstFetchSize = 5

	FetchSize = 5

  def show
    @relationship = @user.relationship_with current_user
    @cond = get_privilege_cond @relationship
    @setting = @user.privacy_setting

    if @user != current_user
      @common_friends = @user.common_friends_with(current_user).sort_by{rand}[0..2]
    end

		@blogs = @user.blogs.find(:all, :conditions => @cond, :offset => 0, :limit => 3)
		@albums = @user.active_albums.find(:all, :conditions => @cond, :offset => 0, :limit => 3)
		
    @feed_deliveries = @profile.feed_deliveries.all(:limit => FirstFetchSize, :order => 'created_at DESC', :include => [{:feed_item => :originator}])
		@first_fetch_size = FirstFetchSize
		
    @skin = @profile.skin
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?

    # wall messages
    @wall_viewable = @profile.is_comment_viewable_by? current_user
    @messages = @profile.comments.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => @profile.id, :wall_type => 'profile'}}
	end

  def edit
    @relationship = @user.relationship_with current_user
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
					  render :partial => 'basic_info', :locals => {:profile => @profile}
					when 2
					  render :partial => 'contact_info', :locals => {:profile => @profile, :setting => @profile.user.privacy_setting}
          when 3
            render :partial => 'characters', :locals => {:profile => @profile}
					end
				}
				format.json { render :json => @profile.to_json }
			end
    end
  end

	def more_feeds
		@feed_deliveries = @profile.feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize * params[:idx].to_i, :limit => FetchSize, :order => 'created_at DESC')
		@fetch_size = FetchSize
	end

protected

  def setup
		if ["more_feeds", "show", "edit"].include? params[:action]
			@profile = Profile.find(params[:id])
			@user = @profile.user
      require_adequate_privilege @profile
    elsif ["update"].include? params[:action]
      @profile = Profile.find(params[:id])
      require_owner @profile.user
    end
  end

  def require_adequate_privilege profile
    profile.available_for?(current_user) || render_add_friend(profile.user)
  end
  
end
