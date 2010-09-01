class User::WallMessagesController < UserBaseController

  def create
    @message = @wall.comments.build(params[:comment].merge({:poster_id => current_user.id}))
   
    if @message.save
      render :json => {:code => 1, :id => @message.id, :html => partial_html('wall_message', :object => @message) }
    else
      render :json => {:code => 0}
    end 
  end

  def destroy
    if @message.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def index
    @messages = @wall.comments.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => params[:wall_id], :wall_type => params[:wall_type]}}
    render :partial => 'wall_messages', :locals => {:messages => @messages}    
  end

  def index_with_form
    @messages = @wall.comments.paginate :page => params[:page], :per_page => 10
    @remote = {:update => 'comments', :url => {:controller => 'user/wall_messages', :action => 'index', :wall_id => params[:wall_id], :wall_type => params[:wall_type]}}
    @recipient = params[:recipient_id].nil? ? nil : User.find(params[:recipient_id]) 
    render :partial => 'wall', :locals => {:messages => @messages, :wall => @wall, :recipient => @recipient}    
  end

protected

  def setup
    if ['index', 'index_with_form', 'create'].include? params[:action]
      @wall = params[:wall_type].camelize.constantize.find(params[:wall_id])
      require_verified @wall if @wall.respond_to?(:rejected?)
      require_view_privilege @wall if params[:action] == 'index'
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
