class User::Guild::RequestsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  def new
    render :action => 'new', :layout => false
  end

  def create
    @request = @guild.requests.build(params[:request].merge({:user_id => current_user.id}))
    if @request.save
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def accept
    if @request.accept_request 
      render :update do |page|
        page << "alert('成功'); $('guild_request_option_#{@request.id}').innerHTML = '已接受';"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def decline
    if @request.destroy
      render :update do |page|
        page << "facebox.close(); $('guild_request_option_#{@request.id}').innerHTML = '已拒绝';"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ['new', 'create'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
    elsif ['accept', 'decline'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
      @request = @guild.requests.find(params[:id])
    end
  rescue
    not_found
  end

end

