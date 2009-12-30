class User::StatusesController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  def index
    @statuses = @user.statuses.paginate :page => params[:page], :per_page => 10
  end

  def friends
    @statuses = current_user.status_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10
  end

  def create
    @status = @user.statuses.build(params[:status])
    unless @status.save
			render :update do |page|
				page << "error(保存时发生错误)"
			end
		end
  end

  def destroy
    if @status.destroy
      render :update do |page|
        page << "facebox.close();$('status_#{@status.id}').remove();"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:id])
			@status = Status.find(params[:status_id]) if params[:status_id]
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
		elsif ["create", "friends"].include? params[:action]
			@user = current_user
    elsif ["destroy"].include? params[:action]
      @user = current_user
      @status = Status.find(params[:id])
    end
  rescue
    not_found
  end

end
