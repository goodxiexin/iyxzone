#
# 这个类有个问题：
# 如果我们某一天突然对评论也有了对博客一样的浏览权限，那么这个polymorphism controller就不能适用了
# 真有那一天，请在更深层次的域名里定义一个commentsController，并继承该controller
# 其实我觉得上面这种做法更好，我只是为了偷懒才弄成这样
# 所有的polymorphism都有这样的问题，比如wall message, tag, viewing等
#
class User::CommentsController < ApplicationController

  before_filter :login_required, :setup

  def create
    @comment = @commentable.comments.build(params[:comment].merge({:poster_id => current_user.id}))
    unless @comment.save
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def destroy
    if @comment.destroy
      render :update do |page|
        page << "facebox.close();Effect.BlindUp($('comment_#{@comment.id}'));"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def index
    @comments = @commentable.comments
    render :partial => 'comment', :collection => @comments
  end

protected

  def setup
    if ['index', 'create'].include? params[:action]
      @commentable = get_commentable
    elsif ['destroy'].include? params[:action]
      @comment = Comment.find(params[:id])
    end
  rescue
    not_found
  end

  def get_commentable
    @klass = params[:commentable_type].camelize.constantize
    @klass.find(params[:commentable_id])
  rescue
    not_found
  end

end
