class User::TopicsController < UserBaseController

  layout 'app'

  increment_viewing 'topic', :only => [:show]

  PER_PAGE = 20

  def index
    @top_topics = @forum.topics.top.nonblocked.limit(5)
    @topics = @forum.topics.normal.nonblocked.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def top
    @top_topics = @forum.topics.top.nonblocked.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def show
    if !params[:post_id].blank?
      @post = Post.find(params[:post_id])
      params[:page] = @topic.posts.index(@post) / PER_PAGE + 1
    end
    @random_topics = Topic.random :limit => 5, :except => [@topic], :conditions => {:forum_id => @forum.id}
    @posts = @topic.posts.nonblocked.paginate :page => params[:page], :per_page => PER_PAGE
    @cond = {:top => @topic.top}.merge Topic.nonblocked_cond
    @next = @topic.next @cond
    @prev = @topic.prev @cond
  end

  def new
  end

  def create
    @topic = @forum.topics.build(params[:topic].merge({:poster_id => current_user.id}))
    
    if @topic.save
      redirect_to topic_url(@topic)
    else
      render :action => 'new'
    end
  end

  def toggle
    if @topic.toggle_top
      if params[:at] == 'index'
        redirect_to topics_url(:forum_id => @forum) 
      elsif params[:at] == 'forum_show'
        redirect_to forum_url(@forum)
      elsif params[:at] == 'show'
        flash[:notice] = '成功'
        redirect_to topic_url(@topic)
      end
    else
      flash[:error] = '发生错误'
      redirect_to :back
    end
  end

  def destroy
    if @topic.destroy
      if params[:at] == 'index'
        render_js_code "$('topic_#{@topic.id}').remove(); tip('成功')"
      elsif params[:at] == 'forum_show'
        redirect_js forum_url(@forum)
      elsif params[:at] == 'show'
        redirect_js topics_url(:forum_id => @forum.id)
      end
    else
      render_js_error
    end
  end

protected

	def setup
		if ["index", "new", "create", "top"].include? params[:action]
			@forum = Forum.find(params[:forum_id])
      @guild = @forum.guild 
		elsif ["show", "toggle", "destroy"].include? params[:action]
			@topic = Topic.find(params[:id])
      @forum = @topic.forum
      @guild = @forum.guild
      if params[:action] != 'show'
        @guild.president == current_user || render_not_found
      end
		end
	end

end
