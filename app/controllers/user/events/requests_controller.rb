class User::Events::RequestsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :privilege_required, :only => [:new]

  def new
    render :action => 'new', :layout => false
  end

  def create
    unless @request = @event.requests.create(params[:request].merge({:participant_id => current_user.id}))
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def accept
    if @request.update_attribute('status', @request.status + 2)
      render :update do |page|
        page << "$('event_request_operation_#{@request.id}').innerHTML = '已成功接受';"
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
        page << "$('event_request_option_#{@request.id}').innerHTML = '已拒绝';"
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
      @event = Event.find(params[:event_id])
      @user = @event.poster
      @privilege = @event.privilege
    elsif ['accept', 'decline'].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
      @privilege = @event.privilege
      @request = @event.requests.find(params[:id])
    end
  rescue
    not_found
  end

  # due to authenticity token, this is no longer needed
=begin
  def poster_required
    @user == current_user || not_found
  end
=end

end

