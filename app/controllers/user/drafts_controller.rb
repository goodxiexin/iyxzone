class User::DraftsController < UserBaseController

  layout 'app'

  def index
    @blogs = current_user.drafts.paginate :page => params[:page]
  end

  def create
    @blog = current_user.drafts.build(params[:blog] || {})
    
    if @blog.save
      render :json => {:code => 1, :id => @blog.id}
    else
      render :json => {:code => 0}
    end
  end

  def edit
    @tag_infos = @blog.tags.map {|t| {:tag_id => t.id, :friend_id => t.tagged_user_id, :friend_name => t.tagged_user.login}}.to_json
    @game_infos = @blog.games.map {|g| {:id => g.id, :name => g.name, :pinyin => g.pinyin}}.to_json
  end

  def update
    if @blog.update_attributes(params[:blog] || {})
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
		if @blog.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected
  
  def setup
    if ['edit', 'update', 'destroy'].include? params[:action]
      @blog = Blog.find(params[:id])
      require_draft @blog
      require_owner @blog.poster
    end
  end

  def require_draft blog
    blog.draft || render_not_found
  end

end
