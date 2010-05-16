class User::SkinsController < UserBaseController
  
  layout 'app2'

	FirstFetchSize = 5

	FetchSize = 5

  def show
		@user = current_user
		@profile = @user.profile
    @setting = @user.privacy_setting
    @skin = Skin.find(params[:id])

    @friends = @user.friends.sort_by{rand}[0..2]

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

		render :template => 'user/profiles/show', :layout =>'skins'
	end

	def index
		@skins = Skin.paginate :page => params[:page], :per_page => 8
		render :layout => 'app'
	end

	def update
		@skin = Skin.find(params[:id])
		@profile = current_user.profile
		
    if @profile.update_attributes(:skin_id => @skin.id)
			flash[:notice] = "皮肤更新完成！"
			redirect_to profile_url(@profile)
		else
			flash[:notice] = "该皮肤不能使用"
			redirect_to profile_url(@profile)
		end
	end

end
