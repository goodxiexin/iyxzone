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
