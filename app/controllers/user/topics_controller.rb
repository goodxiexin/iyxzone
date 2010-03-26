class User::TopicsController < UserBaseController

  layout 'app'

  def index
    @top_topics = @forum.top_topics.find(:all, :offset => 0, :limit => 5)
    @topics = @forum.normal_topics.paginate :page => params[:page], :per_page => 20
  end

  def top
    @top_topics = @forum.top_topics.paginate :page => params[:page], :per_page => 20
  end

  def new
  end

  def create
    @topic = @forum.topics.build(params[:topic].merge({:poster_id => current_user.id}))
    if @topic.save
      redirect_to forum_topics_url(@forum)
    else
      render :action => 'new'
    end
  end

  def toggle
    if @topic.update_attribute('top', params[:top].to_i)
      render :update do |page|
        page << "alert('成功');"
        page.redirect_to forum_topics_url(@forum) 
      end
    else
      render :update do |page|
        page << "alert('错误');"
      end
    end
  end

  def destroy
    @topic.destroy
    render :update do |page|
      page << "$('topic_#{@topic.id}').remove();alert('成功')"
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
