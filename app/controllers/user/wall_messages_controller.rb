class User::WallMessagesController < UserBaseController

  def create
    @message = Comment.new((params[:comment] || {}).merge({:poster_id => current_user.id}))
    unless @message.save
      render_js_error
    end
  end

  def destroy
    if @message.destroy
      render_js_code "facebox.close();Effect.BlindUp($('comment_#{@message.id}'));"
    else
      render_js_error
    end
  end

  def index
    @messages = @wall.comments.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => params[:wall_id], :wall_type => params[:wall_type]}}
    render :partial => 'wall_messages', :locals => {:messages => @messages}    
  end

protected

  def setup
    if ['index'].include? params[:action]
      @wall = params[:wall_type].camelize.constantize.find(params[:wall_id])
      require_view_privilege @wall
    elsif ['destroy'].include? params[:action]
      @message = Comment.find(params[:id])
      require_delete_privilege @message
    end
  end

  def require_delete_privilege message
    message.is_deleteable_by?(current_user) || render_not_found
  end

  def require_view_privilege wall
    wall.is_comment_viewable_by?(current_user) || render_not_found
  end

end
