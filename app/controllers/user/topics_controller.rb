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
      render :json => {:code => 1, :id => @topic.id} #redirect_to topic_url(@topic)
    else
      render :json => {:code => 0} #action => 'new'
    end
  end

  def toggle
    if @topic.toggle_top
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
    if @topic.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

	def setup
		if ["index", "new", "create", "top"].include? params[:action]
			@forum = Forum.find(params[:forum_id])
      @guild = @forum.guild 
		elsif ["show"].include? params[:action]
      @topic = Topic.find(params[:id])
      @forum = @topic.forum
      @guild = @forum.guild
      require_verified @topic
    elsif ["toggle", "destroy"].include? params[:action]
			@topic = Topic.find(params[:id])
      require_verified @topic
      require_owner @topic.forum.guild.president
		end
	end

end
