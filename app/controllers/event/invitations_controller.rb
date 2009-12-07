class Event::InvitationsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:new, :create_multiple]

  before_filter :invitee_required, :only => [:edit, :update]

  def new
    @friends = @user.friends
  end

  def create_multiple
    @users.each { |user| @event.invitations.create(:participant_id => user.id) }
    redirect_to event_url(@event)
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    @invitation.update_attribute('status', params[:status])
  end

  def search
    @friends = @user.friends.find_all {|f| f.login.include?(params[:key])}
    render :partial => 'friends'
  end

protected

  def setup
    if ['new', 'search'].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
    elsif ['create_multiple'].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
      @users = params[:users].blank? ? [] : @user.friends.find(params[:users])
    elsif ['edit', 'update'].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
      @invitation = @event.invitations.find(params[:id])
    end
  end

  def invitee_required
    @invitation.participant == current_user || not_found
  end

end
