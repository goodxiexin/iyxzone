class Event::RequestsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :poster_required, :only => [:accept, :decline]

  before_filter :privilege_required, :only => [:new, :create]

  def new
    render :action => 'new', :layout => false
  end

  def create
    @request = @event.requests.build(params[:request].merge({:participant_id => current_user.id}))
    if @request.save
			render :update do |page|
				if params[:show].to_i == 0
					page << "facebox.close();$('event_status_#{@event.id}').innerHTML = '你已经发送请求了，耐心等候';$('reply_event_#{@event.id}').innerHTML = '';"
				elsif params[:show].to_i == 1
					flash[:notice] = '成功提交'
					page.redirect_to event_url(@event)
				elsif	params[:show].to_i == 2
					page << "$('event_request_operation_#{@request.id}').innerHTML = '#{msg params[:request][:status].to_i}';"
				end
			end
    else
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
    @request.destroy
    render :update do |page|
      page << "$('event_request_operation_#{@request.id}').innerHTML = '已拒绝';"
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

  def poster_required
    @user == current_user || not_found
  end

end

