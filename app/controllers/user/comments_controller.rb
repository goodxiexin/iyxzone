class User::CommentsController < UserBaseController

  def create
    @comment = @commentable.comments.build(params[:comment].merge({:poster_id => current_user.id}))

    if @comment.save
      render :json => {:code => 1, :html => partial_html('comment', :object => @comment)}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
    if @comment.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def index
    @offset = params[:offset].to_i || 0
    @limit = params[:limit].to_i || 0
    @comments = @commentable.comments.offset(@offset).limit(@limit).all
    render :partial => 'comment', :collection => @comments
  end

protected

  def setup
    if ['index', 'create'].include? params[:action]
      @commentable = params[:commentable_type].camelize.constantize.find(params[:commentable_id])
      require_verified @commentable if @commentable.respond_to?(:rejected?)
      require_view_privilege @commentable if params[:action] == 'index'
    elsif ['destroy'].include? params[:action]
      @comment = Comment.find(params[:id])
      require_delete_privilege @comment
    end
  end

  def require_delete_privilege comment
    comment.is_deleteable_by?(current_user) || render_not_found
  end

  def require_view_privilege commentable
    commentable.is_comment_viewable_by?(current_user) || render_not_found
  end

end
