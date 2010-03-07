class User::Polls::InvitationsController < UserBaseController

  layout 'app'

  def new
    @friends = current_user.friends
  end

  def create_multiple
    params[:users].each { |user_id| @poll.invitations.create(:user_id => user_id) }
    redirect_to poll_url(@poll)
  end

	def destroy
		if @invitation.destroy
		  render :update do |page|
			  page.redirect_to poll_url @invitation.poll
		  end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
	end

	def search
		@friends = current_user.friends.search(params[:key])
		render :partial => 'friends'
	end

protected

	def setup
		if ['new', 'create_multiple'].include? params[:action]
			@poll = Poll.find(params[:poll_id])
      require_owner @poll.poster
		elsif ['destroy'].include? params[:action]
      @invitation = PollInvitation.find(params[:id])
      require_owner @invitation.user
		end
	end

end
