class User::TopicsController < UserBaseController

  layout 'app'

  PER_PAGE = 20

  def index
    @hot_topics = Topic.hot.nonblocked.match("forum_id != #{@forum.id}")
    @top_topics = @forum.topics.top.nonblocked.limit(5)
    @topics = @forum.topics.normal.nonblocked.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def top
    @top_topics = @forum.topics.top.nonblocked.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def new
  end

  def create
    @topic = @forum.topics.build(params[:topic].merge({:poster_id => current_user.id}))
    
    if @topic.save
      redirect_to forum_topic_posts_url(@forum, @topic)
    else
      render :action => 'new'
    end
  end

  def toggle
    if @topic.update_attribute('top', params[:top].to_i)
      if params[:at] == 'index'
        redirect_to forum_topics_url(@forum) 
      elsif params[:at] == 'show'
        flash[:notice] = '成功'
        redirect_to forum_topic_posts_url(@forum, @topic)
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
      elsif params[:at] == 'show'
        redirect_js forum_topics_url(@forum)
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
			@forum = Forum.find(params[:forum_id])
			@topic = @forum.topics.find(params[:id])
      @guild = @forum.guild
      if params[:action] != 'show'
        @guild.president == current_user || render_not_found
      end
		end
	end

end
