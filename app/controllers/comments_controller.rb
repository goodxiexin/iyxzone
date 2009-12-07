class CommentsController < ApplicationController

  before_filter :login_required, :catch_commentable

  before_filter :catch_comment, :only => [:destroy]

  def create
    @comment = @commentable.comments.build(params[:comment].merge({:poster_id => current_user.id}))
    unless @comment.save
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def destroy
    @comment.destroy
    render :update do |page|
      page << "facebox.close();Effect.BlindUp($('comment_#{@comment.id}'));"
    end
  end

  def index
    @comments = @commentable.comments.paginate :page => params[:page], :per_page => 10
  end

protected

  def catch_commentable
    # implement this in your controllers
  end

  def catch_comment
    @comment = @commentable.comments.find(params[:id])
  rescue
    not_found
  end

end
