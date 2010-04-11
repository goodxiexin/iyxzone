class User::DraftsController < UserBaseController

  layout 'app'

  def index
    @blogs = current_user.drafts.paginate :page => params[:page], :per_page => 15
  end

  def create
    @blog = Blog.new((params[:blog] || {}).merge({:poster_id => current_user.id, :draft => true}))
    
    if @blog.save
      render :update do |page|
        flash[:notice] = "保存成功，你可以继续写了!"
        page.redirect_to edit_draft_url(@blog)
      end
    else
      render :update do |page|
        page.replace_html :errors, :partial => 'blog/validation_errors'
      end
    end
  end

  def edit
    @album_infos = current_user.all_albums.map {|a| {:id => a.id, :title => a.title, :type => a.class.name.underscore}}.to_json
    @tag_infos = @blog.tags.map {|t| {:tag_id => t.id, :friend_id => t.tagged_user_id, :friend_name => t.tagged_user.login}}.to_json
  end

  def update
    if @blog.update_attributes((params[:blog] || {}).merge({:poster_id => current_user.id, :draft => true}))
      render :json => {:draft_id => @blog.id, :tags => @blog.tags.map{|t| {:id => t.id, :friend_login => t.tagged_user.login, :friend_id => t.tagged_user_id}}}
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'blog/validation_errors'
      end
    end
  end

  def destroy
		if @blog.destroy
      render :update do |page|
        page.redirect_to drafts_url
      end
    else
      render :update do |page|
        page << "error('删除的时候发生错误');"
      end
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
