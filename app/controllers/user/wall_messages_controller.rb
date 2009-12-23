class User::WallMessagesController < ApplicationController

  before_filter :login_required, :setup

  def create
    @message = @wall.comments.build(params[:comment].merge({:poster_id => current_user.id}))
    unless @message.save
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def destroy
    if @message.destroy
      render :update do |page|
        page << "facebox.close();Effect.BlindUp($('comment_#{@message.id}'));"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def index
    @messages = @wall.comments
    render :partial => 'wall_message', :collection => @messages
  end

protected

  def setup
    if ['index', 'create'].include? params[:action]
      @wall = get_wall
    elsif ['destroy'].include? params[:action]
      @message = Comment.find(params[:id])
    end
  rescue
    not_found
  end

  def get_wall
    @klass = params[:wall_type].camelize.constantize
    @klass.find(params[:wall_id])
  rescue
    not_found
  end

end
