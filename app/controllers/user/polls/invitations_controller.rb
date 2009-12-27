class User::Polls::InvitationsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:new, :create_multiple]

  before_filter :invitee_required, :only => [:destroy]

  def new
    @friends = @user.friends
  end

  def create_multiple
    @users.each { |user| @poll.invitations.create(:user_id => user.id) }
    redirect_to poll_url(@poll)
  end

	def destroy
		if @invitation.destroy
		  render :update do |page|
			  page.redirect_to poll_url(@poll)
		  end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
	end

	def search
		@friends = current_user.friends.find_all {|f| f.login.include?(params[:key]) }
		render :partial => 'friends'
	end

protected

	def setup
		if ['new'].include? params[:action]
			@poll = Poll.find(params[:poll_id])
			@user = @poll.poster
		elsif ['create_multiple'].include? params[:action]
			@poll = Poll.find(params[:poll_id])
      @user = @poll.poster
			@users = params[:users].blank? ? [] : @user.friends.find(params[:users])
		elsif ['destroy'].include? params[:action]
			@poll = Poll.find(params[:poll_id])
      @user = @poll.poster
			@invitation = @poll.invitations.find(params[:id])
		end
	rescue
		not_found
	end

	def invitee_required
    @invitation.user == current_user || not_found
  end

end
