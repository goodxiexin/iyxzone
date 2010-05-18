class User::BlogsController < UserBaseController

  layout 'app'

  increment_viewing 'blog', 'id', :only => [:show]

  PER_PAGE = 10

  PREFETCH = [{:poster => :profile}, :share]

  def index
    @relationship = @user.relationship_with current_user
    @count = @user.blogs_count @relationship
    @blogs = @user.blogs.nonblocked.for(@relationship).paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

	def hot
    @blogs = Blog.hot.nonblocked.for('friend').paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def recent
    @blogs = Blog.recent.nonblocked.for('friend').paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def relative
    @blogs = @user.relative_blogs.nonblocked.for('friend').paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def friends
    @blogs = Blog.by(current_user.friend_ids).nonblocked.for('friend').paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def show
    @random_blogs = Blog.by(@user.id).for(@relationship).nonblocked.random :limit => 5, :except => [@blog]
    @cond = Blog.nonblocked_cond.merge Blog.privilege_cond(@relationship)
    @next = @blog.next @cond
    @prev = @blog.prev @cond
    @count = @user.blogs_count @relationship
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = current_user.blogs.build(params[:blog] || {})
    
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
    if @blog.update_attributes(params[:blog] || {})
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
      render_js_error '删除的时候发生错误'
		end
  end

protected

  def setup
    if ['index', 'relative'].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ['show'].include? params[:action]
      @blog = Blog.find(params[:id], :include => [{:comments => [:commentable, {:poster => :profile}]}, {:tags => :tagged_user}, {:poster => :profile}])
      require_not_draft @blog
      require_verified @blog
      @user = @blog.poster
      @relationship = @user.relationship_with current_user
      require_adequate_privilege @blog, @relationship
    elsif ['edit', 'destroy', 'update'].include? params[:action]
      @blog = Blog.find(params[:id])
      require_not_draft @blog
      require_verified @blog
      require_owner @blog.poster
    end
  end

  def require_not_draft blog
    !blog.draft || render_not_found
  end

end
