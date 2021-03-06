class User::Polls::InvitationsController < UserBaseController

  layout 'app'

  def new
    @friends = current_user.friends - @poll.invitations.map(&:user)
  end

  def create
    @users = User.find(params[:values])

    if @poll.invite @users
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

	def destroy
		if @invitation.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
	end

protected

	def setup
		if ['new', 'create'].include? params[:action]
			@poll = Poll.find(params[:poll_id])
      require_verified @poll
      require_owner @poll.poster
		elsif ['destroy'].include? params[:action]
      @invitation = PollInvitation.find(params[:id])
      require_owner @invitation.user
		end
	end

end
