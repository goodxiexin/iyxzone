class User::EventsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit]

  def index
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @events = @user.events.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 5
  end

	def hot
		#cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    cond = user_game_conds
    @events = Event.hot.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 5
  end

  def recent
		#cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    cond = user_game_conds
    @events = Event.recent.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 5
	end

  def upcoming
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @events = @user.upcoming_events.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 5
  end

  def participated
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @events = @user.participated_events.find(:all, :conditions => {:game_id => params[:game_id]}).paginate :page => params[:page], :per_page => 5
  end

  def friends
    @events = current_user.event_feed_items.map(&:originator).paginate :page => params[:page], :per_page => 10
  end

  def show
    @participation = @event.participations.find_by_participant_id(current_user.id)
    @album = @event.album
    @comments = @event.comments.paginate :page => params[:page], :per_page => 10
    @can_reply = !(@participation.nil? || !@participation.is_authorized?)
    @can_delete = (current_user == @event.poster)
		render :action => 'show', :layout => 'app2'
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event].merge({:poster_id => current_user.id}))
    if @event.save
      redirect_to new_event_invitation_url(@event)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(params[:event])
      redirect_to event_url(@event)
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @event.destroy
      render :update do |page|
        page.redirect_to events_url(:id => @user.id)
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end  

  #
  # 这个方法在目前的页面用不上
  #
  def search
    case params[:type].to_i
    when 0
      @events = current_user.upcoming_events.search(params[:key]).paginate :page => params[:page], :per_page => 5
    when 1
      @events = Event.hot.search(params[:key]).paginate :page => params[:page], :per_page => 5
    when 2
      @events = Event.recent.search(params[:key]).paginate :page => params[:page], :per_page => 5
    when 3
      @events = current_user.past_events.search(params[:key]).paginate :page => params[:page], :per_page => 5
    end
    @remote = {:update => 'events', :url => {:action => 'search', :controller => 'user/events', :type => params[:type], :key => params[:key]}}
    render :partial => 'user/event/events', :object => @events
  end

protected

  def setup
    if ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @event = Event.find(params[:id])
			@user = @event.poster
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
    elsif ['index', 'hot', 'recent', 'upcoming', 'participated'].include? params[:action]
      @user = User.find(params[:id])
    elsif ['new', 'create', 'friends'].include? params[:action]
      @user = current_user
    end
  rescue
    not_found
  end

end
