class Blog::BlogsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :friend_or_owner_required, :only => [:index, :relative]

  before_filter :privilege_required, :only => [:show]

  before_filter :not_draft_required, :only => [:show, :edit, :destroy]

  before_filter :owner_required, :only => [:edit, :update, :destroy]

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

  def show
    @comments = @blog.comments
  end

  def new
    @blog = Blog.new
  end

  def create
    if @blog = current_user.blogs.create(params[:blog].merge({:poster_id => current_user.id}))
      redirect_to blog_url(@blog)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @blog.update_attributes(params[:blog].merge({:draft => false}))
      redirect_to blog_url(@blog)
    else
      render :action => 'edit'
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
    elsif ['new', 'create', 'hot', 'recent'].include? params[:action]
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
    !@blog.draft || not_found
  end

end
