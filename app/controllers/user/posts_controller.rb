class User::PostsController < UserBaseController

  layout 'app'

  def create
    @post = @topic.posts.build(params[:post].merge({:poster_id => current_user.id}))

    if @post.save
      render :json => {:code => 1, :id => @post.id}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
    if @post.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end 
  end

protected
 
	def setup
		if ["create"].include? params[:action]
			@topic = Topic.find(params[:topic_id])
      require_verified @topic
		elsif ["destroy"].include? params[:action]
			@post = Post.find(params[:id])
      require_verified @post
      require_owner @post.forum.guild.president
		end
	end

end
