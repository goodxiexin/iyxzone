class User::VideosController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  PREFETCH = [{:poster => :profile}]

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
      render :json => {:code => 1, :id => @video.id}
    else
      render :json => {:code => 0}
    end
  end

  def show
    @random_videos = Video.by(@user.id).for(@relationship).nonblocked.random :limit => 5, :except => [@video]
    @cond = Video.privilege_cond(@relationship).merge Video.nonblocked_cond
    @next = @video.next @cond
    @prev = @video.prev @cond
    @count = @user.videos_count @relationship
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

  def edit
    @tag_infos = @video.tags.map {|t| {:tag_id => t.id, :friend_id => t.tagged_user_id, :friend_name => t.tagged_user.login}}.to_json
    @game_infos = @video.games.map {|g| {:id => g.id, :name => g.name, :pinyin => g.pinyin}}.to_json
  end

  def update
    if @video.update_attributes(params[:video] || {})
		  render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
		if @video.destroy
      render :json => {:code => 1}
		else
      render :json => {:code => 0}
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
