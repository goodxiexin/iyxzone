class Status::StatusesController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:destroy]

  def index
    @statuses = @user.statuses.paginate :page => params[:page], :per_page => 10
  end

  def create
    @status = @user.statuses.build(params[:status])
    if @status.save
      if params[:home].to_i == 1
        render :update do |page|
          page.replace_html "latest_status", :inline => "<%= distance_of_time_in_words_to_now(current_user.latest_status.created_at) %> ago: <span id='latest_status_content'><%= current_user.latest_status.content %></span>"
          page.visual_effect :highlight, 'latest_status', :duration => 2
					page << "$('status_content').clear();"
        end
      else
        render :update do |page|
          page.insert_html :top, 'statuses', :partial => 'status', :object => @status
          page << "facebox.watchClickEvent($('delete_status_#{@status.id}'));$('status_content').value = '';"
        end
      end
    else
			render :update do |page|
				page << "保存时发生错误"
			end
		end
  end

  def destroy
    @status.destroy
    render :update do |page|
      page << "facebox.close();$('status_#{@status.id}').remove();"
    end
  end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:id])
			@status = Status.find(params[:status_id]) if params[:status_id]
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
		elsif ["create"].include? params[:action]
			@user = current_user
    elsif ["destroy"].include? params[:action]
      @user = current_user
      @status = Status.find(params[:id])
    end
  rescue
    not_found
  end

end
