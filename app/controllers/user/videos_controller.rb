class User::VideosController < UserBaseController

  layout 'app'

  require_verified 'video'

  def index
    @relationship = @user.relationship_with current_user
    @videos = @user.videos.viewable(@relationship).paginate :page => params[:page], :per_page => 10
  end

	def hot
    @videos = Video.hot.paginate :page => params[:page], :per_page => 5
  end

  def recent
    @videos = Video.recent.paginate :page => params[:page], :per_page => 10
  end

  def relative
    @videos = @user.relative_videos.paginate :page => params[:page], :per_page => 10
  end

  def friends
    @videos = current_user.video_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10 
  end

  def new
    @video = Video.new
  end

  def create
		@video = Video.new((params[:video] || {}).merge({:poster_id => current_user.id}))
    
    if @video.save
      redirect_to video_url(@video)
    else
      render :action => 'new'
    end
  end

  def show
    @user = @video.poster
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

  def edit
  end

  def update
    if @video.update_attributes((params[:video] || {}).merge({:poster_id => current_user.id}))
		  redirect_to video_url(@video)
    else
      render :action => 'edit'
    end
  end

  def destroy
		if @video.destroy
			render :update do |page|
				page.redirect_to videos_url(:id => current_user.id)
			end
		else
			render :update do |page|
				page << "error('删除的时候发生错误');"
			end
		end
  end

protected

  def setup
    if ['index', 'relative'].include? params[:action]
      @user = User.find(params[:id])
      require_friend_or_owner @user
    elsif ['hot', 'recent'].include? params[:action]
      @user = User.find(params[:id])
    elsif ['show'].include? params[:action]
      @video = Video.find(params[:id])
      require_adequate_privilege @video
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @video = Video.find(params[:id])
      require_owner @video.poster
    end  
  end

end
