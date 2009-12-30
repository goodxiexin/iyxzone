class User::BlogsController < UserBaseController

  layout 'app'

  before_filter :not_draft_required, :except => [:update]

  before_filter :friend_or_owner_required, :only => [:index, :relative]

  before_filter :privilege_required, :only => [:show]

  increment_viewing 'blog', :only => [:show]

  before_filter :owner_required, :only => [:edit]

  def index
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @blogs = @user.blogs.viewable(relationship, :conditions => cond).paginate :page => params[:page], :per_page => 10 
  end

	def hot 
    cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @blogs = Blog.hot.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
  end

  def recent
    cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @blogs = Blog.recent.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
  end

  def relative
    cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @blogs = @user.relative_blogs.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
  end

  def friends
    @blogs = current_user.blog_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10
  end

  def show
    @comments = @blog.comments
  end

  def new
    @blog = Blog.new
  end

  def create
    # merge({:poster_id => current_user.id 必须有，不然tags=方法里poster_id = nil
    if @blog = current_user.blogs.create(params[:blog].merge({:poster_id => current_user.id, :draft => false}))
      render :update do |page|
        page.redirect_to blog_url(@blog)
      end
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'blog/validation_errors'
      end
    end
  end

  def edit
  end

  def update
    if @blog.update_attributes(params[:blog].merge({:draft => false}))
      render :update do |page|
        page.redirect_to blog_url(@blog)
      end
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'blog/validation_errors'
      end
    end
  rescue FriendTag::TagNoneFriendError
    render :text => '只能标记你的朋友'
  end

  def destroy
    if @blog.destroy
			render :update do |page|
				page.redirect_to blogs_url(:id => @user.id)
			end
		else
			render :update do |page|
				page << "error('删除的时候发生错误');"
			end
		end
  end

protected

  def setup
    if ['index', 'hot', 'recent', 'relative'].include? params[:action]
      @user = User.find(params[:id])
    elsif ['new', 'create', 'friends'].include? params[:action]
      @user = current_user
    elsif ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @blog = Blog.find(params[:id])
      @user = @blog.poster
			@privilege = @blog.privilege
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
    end
  rescue
    not_found
  end

  def not_draft_required
    @blog.nil? || !@blog.draft || not_found
  end

end
