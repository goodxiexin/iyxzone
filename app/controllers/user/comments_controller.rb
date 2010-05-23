class User::CommentsController < UserBaseController

  def create
    @comment = @commentable.comments.build((params[:comment] || {}).merge({:poster_id => current_user.id}))

    unless @comment.save
      render_js_error '评论由于某些问题而无法保存'
    end
  end

  def destroy
    if @comment.destroy
      render_js_code "facebox.close();Effect.BlindUp($('comment_#{@comment.id}'));"
    else
      render_js_error
    end
  end

  def index
    @comments = @commentable.comments
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
