class User::CommentsController < UserBaseController

  def create
    @comment = Comment.new((params[:comment] || {}).merge({:poster_id => current_user.id}))
    unless @comment.save
      render :update do |page|
        page << "error('评论由于某些问题而无法保存');"
      end
    end
  end

  def destroy
    if @comment.destroy
      render :update do |page|
        page << "facebox.close();Effect.BlindUp($('comment_#{@comment.id}'));"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def index
    @comments = @commentable.comments
    render :partial => 'comment', :collection => @comments
  end

protected

  def setup
    if ['index'].include? params[:action]
      @commentable = params[:commentable_type].camelize.constantize.find(params[:commentable_id])
      require_view_privilege @commentable
    elsif ['destroy'].include? params[:action]
      @comment = Comment.find(params[:id])
      require_delete_privilege @comment
    end
  end

  def require_delete_privilege comment
    comment.is_deleteable_by? current_user || render_not_found
  end

  def require_view_privilege commentable
    commentable.is_comment_viewable_by? current_user || render_not_found
  end

end
