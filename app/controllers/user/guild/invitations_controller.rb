class User::Guild::InvitationsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:new]

  before_filter :invitee_required, :only => [:edit]

  def new
    @friends = @user.friends
  end

  def create_multiple
    @users.each { |user| @guild.invitations.create(:user_id => user.id) }
    redirect_to guild_url(@guild)
  end

  def edit
    render :action => 'edit', :layout => false
  end

	def accept
		unless @invitation.accept_invitation 
	    render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

	def decline
    unless @invitation.destroy
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def search
    @friends = current_user.friends.find_all {|f| f.login.include?(params[:key])}
    render :partial => 'friends'
  end

protected

  def setup
    if ['new'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
    elsif ['create_multiple'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
      @users = params[:users].blank? ? [] : @user.friends.find(params[:users])
    elsif ['edit', 'accept', 'decline'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
      @invitation = @guild.invitations.find(params[:id])
    end
  rescue
    not_found
  end

  def invitee_required
    @invitation.user == current_user || not_found
  end

end
