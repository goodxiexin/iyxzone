class User::BlogsController < UserBaseController

  layout 'app'

  increment_viewing 'blog', 'id', :only => [:show]

  PER_PAGE = 10

  def index
    @relationship = @user.relationship_with current_user
    @privilege = get_privilege_cond @relationship
    @count = @user.blogs_count @relationship
    @blogs = @user.blogs.paginate :page => params[:page], :per_page => PER_PAGE, :conditions => @privilege, :include => [{:poster => :profile}, :share]
  end

	def hot
    @blogs = Blog.hot.paginate :page => params[:page], :per_page => PER_PAGE, :include => [{:poster => :profile}, :share]
  end

  def recent
    @blogs = Blog.recent.paginate :page => params[:page], :per_page => PER_PAGE, :include => [{:poster => :profile}, :share]
  end

  def relative
    @blogs = @user.relative_blogs.paginate :page => params[:page], :per_page => 10, :include => [{:poster => :profile}, :share]
  end

  def friends
    @blogs = current_user.friend_blogs.paginate :page => params[:page], :per_page => 10
  end

  def show
    @relationship = @user.relationship_with current_user
    @privilege = get_privilege_cond @relationship
    @next = @blog.next @privilege
    @prev = @blog.prev @privilege
    @count = @user.blogs_count @relationship
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
        page.replace_html 'errors', :inline => "<%= error_messages_for :blog, :header_message => '遇到以下问题无法保存', :message => nil %>"
      end
    end
  end

  def edit
    @tag_infos = @blog.tags.map {|t| {:tag_id => t.id, :friend_id => t.tagged_user_id, :friend_name => t.tagged_user.login}}.to_json
  end

  def update
    if @blog.update_attributes((params[:blog] || {}).merge({:poster_id => current_user.id, :draft => false}))
      render :update do |page|
        page.redirect_to blog_url(@blog)
      end
    else
      render :update do |page|
        page.replace_html 'errors', :inline => "<%= error_messages_for :blog, :header_message => '遇到以下问题无法保存', :message => nil %>"
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
    elsif ['show'].include? params[:action]
      @blog = Blog.find(params[:id], :include => [{:comments => [:commentable, {:poster => :profile}]}, {:tags => :tagged_user}, {:poster => :profile}])
      require_verified @blog
      @user = @blog.poster
      require_adequate_privilege @blog
    elsif ['edit', 'destroy', 'update'].include? params[:action]
      @blog = Blog.find(params[:id])
      require_owner @blog.poster
    end
  end

end
