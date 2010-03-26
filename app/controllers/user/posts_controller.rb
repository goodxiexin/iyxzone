class User::PostsController < UserBaseController

  layout 'app'

  increment_viewing 'topic', 'topic_id', :only => [:index]

  def index
    @random_topics = Topic.random :limit => 5, :except => [@topic], :conditions => {:forum_id => @forum.id}
    @posts = @topic.posts.paginate :page => params[:page], :per_page => 10
  end

  def create
    @post = @topic.posts.build(params[:post].merge({:poster_id => current_user.id, :forum_id => @forum.id}))
    if @post.save
      redirect_to forum_topic_posts_url(@forum, @topic, :page => (@topic.posts_count + 1)/10 + 1)     
    else
      flash[:error] = '保存出错'
      redirect_to forum_topic_posts_url(@forum, @topic)
    end
  end

  def destroy
    @post.destroy
    render :update do |page|
      page << "$('post_#{@post.id}').remove();alert('成功')"
    end 
  end

protected
 
	def setup
		if ["index", "create"].include? params[:action]
			@forum = Forum.find(params[:forum_id])
			@topic = @forum.topics.find(params[:topic_id])
      @guild = @forum.guild
		elsif ["destroy"].include? params[:action]
			@forum = Forum.find(params[:forum_id])
      @topic = @forum.topics.find(params[:topic_id])
			@post = @topic.posts.find(params[:id])
      @guild = @forum.guild
      @guild.president == current_user || render_not_found
		end
	end

end
