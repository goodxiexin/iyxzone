class Blog::CommentsController < CommentsController

  before_filter :owner_required, :only => [:destroy]

	before_filter :privilege_required, :only => [:index, :create]

protected

  def catch_commentable
    @blog = Blog.find(params[:blog_id])
    @user = @blog.poster
		@privilege = @blog.privilege
    @commentable = @blog
  rescue
    not_found
  end 

  def owner_required
    @user == current_user || @comment.poster == current_user || not_found
  end

end
