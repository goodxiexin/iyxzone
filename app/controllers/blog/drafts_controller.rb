class Blog::DraftsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit, :update, :destroy]

  before_filter :not_blog_required, :only => [:edit, :update, :destroy]

  def index
    @blogs = current_user.drafts.paginate :page => params[:page], :per_page => 15
  end

  def create
    if @blog = current_user.drafts.create(params[:blog].merge({:poster_id => current_user.id, :draft => true}))
      render :update do |page|
        page.redirect_to edit_draft_url(@blog)
      end
      #render :json => {:draft_id => @blog.id, :tags => @blog.tags.map{|t| {:id => t.id, :friend_login => t.tagged_user.login, :friend_id => t.tagged_user_id}}}
      #render :update do |page|
      #  page.alert "保存成功,继续写吧"
      #  page << "Iyxzone.Blog.Builder.draftID = #{@blog.id};"
      #  page << "$('errors').innerHTML = '';"
      #end
    else
      render :update do |page|
        page.replace_html :errors, :partial => 'blog/validation_errors'
      end
    end
  rescue FriendTag::TagNoneFriendError
    render :text => '只能标记你的朋友'
  end

  def edit
  end

  def update
    if @blog.update_attributes(params[:blog])
      render :json => {:draft_id => @blog.id, :tags => @blog.tags.map{|t| {:id => t.id, :friend_login => t.tagged_user.login, :friend_id => t.tagged_user_id}}}
      #render :update do |page|
      #  page.alert "保存成功,继续写吧"
      #  page << "$('errors').innerHTML = '';"
      #end
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
    if ['index', 'create'].include? params[:action]
      @user = current_user
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @blog = Blog.find(params[:id])
      @user = @blog.poster
    end
  rescue
    not_found
  end

  def not_blog_required
    @blog.draft || not_found
  end

end
