# 在这个controller里，我们实验下 memory cached
class User::BlogsController < UserBaseController

  layout 'app'

  before_filter :setup_blog_privilege_cond, :only => [:show, :index]

  increment_viewing 'blog', 'id', :only => [:show]

  def index
    @count = @user.blogs_count @relationship
    @blogs = @user.blogs.paginate :page => params[:page], :per_page => 10, :conditions => @privilege
  end

	def hot
    # 或者我们可以直接cache view, page cache，这样是最快的，当然耗费也是最多的 
    @blogs = Rails.cache.fetch "hot_blogs", :expires_in => 30.minutes do
      Blog.hot.to_a # 最好有to_a，不然miss的时候，paginate仍然要执行sql查询
    end.paginate :page => params[:page], :per_page => 10
  end

  def recent
    @blogs = Rails.cache.fetch "recent_blogs", :expires_in => 30.minutes do
      Blog.recent.to_a
    end.paginate :page => params[:page], :per_page => 10
  end

  def relative
    # 这个如果cache，貌似代价反而有点大，所以就算了
    @blogs = @user.relative_blogs.paginate :page => params[:page], :per_page => 10
  end

  def friends
    # 如果cahce，代价有点大
    @blogs = current_user.friend_blogs.paginate :page => params[:page], :per_page => 10
    #current_user.blog_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10
  end

  def show
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
    elsif ['recent', 'hot'].include? params[:action]
      @user = current_user
    elsif ['show'].include? params[:action]
      @blog = Blog.find(params[:id])
      @user = @blog.poster
      require_adequate_privilege @blog
    elsif ['edit', 'destroy', 'update'].include? params[:action]
      @blog = Blog.find(params[:id])
      require_owner @blog.poster
    end
  end

  def setup_blog_privilege_cond
    @relationship = @user.relationship_with current_user
    if @relationship == 'owner'
      @privilege = {:privilege => [1,2,3,4]}
    elsif @relationship == 'friend'
      @privilege = {:privilege => [1,2,3]}
    elsif @relationship == 'same_game'
      @privilege = {:privilege => [1,2]}
    else
      @privilege = {:privilege => 1}
    end    
  end

end
