class User::VideosController < UserBaseController

  layout 'app'

  before_filter :setup_video_privilege_cond, :only => [:index, :show]

  def index
    @count = @user.videos_count @relationship
    @videos = @user.videos.paginate :page => params[:page], :per_page => 10, :conditions => @privilege
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
    @videos = current_user.friend_videos.paginate :page => params[:page], :per_page => 10
    #video_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10 
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
    @next = @video.next @privilege
    @prev = @video.prev @privilege
    @count = @user.videos_count @relationship
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
				page.redirect_to videos_url(:uid => current_user.id)
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
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ['hot', 'recent'].include? params[:action]
      @user = User.find(params[:uid])
    elsif ['show'].include? params[:action]
      @video = Video.find(params[:id])
      @user = @video.poster
      require_adequate_privilege @video
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @video = Video.find(params[:id])
      require_owner @video.poster
    end  
  end

  def setup_video_privilege_cond
    @relationship = @user.relationship_with current_user
    if @relationship == 'owner'
      @privilege = {:privilege => [1,2,3,4]}
    elsif @relationship == 'friend'
      @privilege = {:privilege => [1,2,3]}
    elsif @relationship == 'same_game'
      @privilege = {:privilege => [1,2]}
    else
      @privilege = {:privilege => 1}
    end
  end


end
