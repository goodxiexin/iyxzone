class User::VideosController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  PREFETCH = [{:poster => :profile}, :share]

  def index
    @relationship = @user.relationship_with current_user
    @count = @user.videos_count @relationship
    @videos = @user.videos.nonblocked.for(@relationship).paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

	def hot
    @videos = Video.hot.nonblocked.for('friend').paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def recent
    @videos = Video.recent.nonblocked.for('friend').paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def relative
    @videos = @user.relative_videos.nonblocked.for('friend').paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def friends
    @videos = Video.by(current_user.friend_ids).nonblocked.for('friend').paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def new
    @video = Video.new
  end

  def create
		@video = current_user.videos.build(params[:video] || {})
    
    if @video.save
      redirect_to video_url(@video)
    else
      render :action => 'new'
    end
  end

  def show
    @privilege = get_privilege_cond @relationship
    #@next = @video.next @privilege
    #@prev = @video.prev @privilege
    @count = @user.videos_count @relationship
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

  def edit
    @tag_infos = @video.tags.map {|t| {:tag_id => t.id, :friend_id => t.tagged_user_id, :friend_name => t.tagged_user.login}}.to_json
  end

  def update
    if @video.update_attributes(params[:video] || {})
		  redirect_to video_url(@video)
    else
      render :action => 'edit'
    end
  end

  def destroy
		if @video.destroy
			render :update do |page|
				page.redirect_to videos_url(:uid => current_user.id)
			end
		else
			render_js_error '删除的时候发生错误'
		end
  end

protected

  def setup
    if ['index', 'relative'].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ['show'].include? params[:action]
      @video = Video.find(params[:id], :include => [{:comments => [:commentable, {:poster => :profile}]}, {:tags => :tagged_user}, {:poster => :profile}])
      require_verified @video
      @user = @video.poster
      @relationship = @user.relationship_with current_user
      require_adequate_privilege @video, @relationship
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @video = Video.find(params[:id])
      require_verified @video
      require_owner @video.poster
    end  
  end

end
