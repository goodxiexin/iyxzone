class User::Polls::InvitationsController < UserBaseController

  layout 'app'

  def new
    @friends = current_user.friends - @poll.invitations.map(&:user)
  end

  def create
    if @poll.update_attributes(:invitees => params[:values])
      redirect_to poll_url(@poll)
    else
      flash.now[:error] = '生成邀请出错'
      render :action => 'new'
    end
  end

	def destroy
		if @invitation.destroy
      redirect_js poll_url(@invitation.poll)
    else
      render_js_error
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
