class User::BlogsController < UserBaseController

  layout 'app'

  increment_viewing 'blog', :only => [:show]

  def index
    @relationship = @user.relationship_with current_user
    @blogs = @user.blogs.viewable(@relationship).paginate :page => params[:page], :per_page => 1
  end

	def hot 
    @blogs = Blog.hot.paginate :page => params[:page], :per_page => 10
  end

  def recent
    @blogs = Blog.recent.paginate :page => params[:page], :per_page => 10
  end

  def relative
    @blogs = @user.relative_blogs.paginate :page => params[:page], :per_page => 10
  end

  def friends
    @blogs = current_user.blog_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10
  end

  def show
    @user = @blog.poster
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new((params[:blog] || {}).merge({:poster_id => current_user.id, :draft => false}))
    
    if @blog.save
      render :update do |page|
        page.redirect_to blog_url(@blog)
      end
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'user/blogs/validation_errors'
      end
    end
  end

  def edit
  end

  def update
    if @blog.update_attributes((params[:blog] || {}).merge({:poster_id => current_user.id, :draft => false}))
      render :update do |page|
        page.redirect_to blog_url(@blog)
      end
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'user/blogs/validation_errors'
      end
    end
  end

  def destroy
    if @blog.destroy
			render :update do |page|
				page.redirect_to blogs_url(:uid => current_user.id)
			end
		else
			render :update do |page|
				page << "error('删除的时候发生错误');"
			end
		end
  end

protected

  def setup
    if ['index', 'relative'].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ['recent', 'hot'].include? params[:action]
      @user = User.find(params[:uid])
    elsif ['show'].include? params[:action]
      @blog = Blog.find(params[:id])
      require_adequate_privilege @blog
    elsif ['edit', 'destroy', 'update'].include? params[:action]
      @blog = Blog.find(params[:id])
      require_owner @blog.poster
    end
  end

end
