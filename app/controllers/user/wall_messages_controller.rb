class User::WallMessagesController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  def create
    @message = @wall.comments.build(params[:comment].merge({:poster_id => current_user.id}))
    if @message.save
      render :update do |page|
        page.insert_html :top, "comments", :partial => 'user/wall_messages/wall_message', :object => @message
        page << "$('comment_content').value = '';"
      end
    else
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
    @messages = @wall.comments.paginate :page => params[:page], :per_page => 20
  end

protected

  def setup
    if ['index', 'create'].include? params[:action]
      @wall = get_wall
      @can_view = can_view?
      @can_reply = can_reply?
      @can_delete = can_delete?
    elsif ['destroy'].include? params[:action]
      @message = Comment.find(params[:id])
    end
  end

end
