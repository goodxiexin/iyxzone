class User::PostsController < UserBaseController

  layout 'app'

  def create
    @post = @topic.posts.build(params[:post].merge({:poster_id => current_user.id}))

    if @post.save
      redirect_to topic_url(@topic, :page => (@topic.posts_count + 1)/20 + 1)     
    else
      flash[:error] = '保存出错'
      redirect_to topic_url(@topic)
    end
  end

  def destroy
    if @post.destroy
      render_js_code  "$('post_#{@post.id}').remove();tip('成功')"
    else
      render_js_error
    end 
  end

protected
 
	def setup
		if ["create"].include? params[:action]
			@topic = Topic.find(params[:topic_id])
      @forum = @topic.forum
      @guild = @forum.guild
		elsif ["destroy"].include? params[:action]
			@post = Post.find(params[:id])
      @guild = @post.topic.forum.guild
      @guild.president == current_user || render_not_found
		end
	end

end
