class User::Polls::InvitationsController < UserBaseController

  layout 'app'

  def new
    @friends = current_user.friends - @poll.invitations.map(&:user)
  end

  def create
    params[:values].each do |user_id| 
      @poll.invitations.create(:user_id => user_id)
    end
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

protected

	def setup
		if ['new', 'create'].include? params[:action]
			@poll = Poll.find(params[:poll_id])
      require_owner @poll.poster
		elsif ['destroy'].include? params[:action]
      @invitation = PollInvitation.find(params[:id])
      require_owner @invitation.user
		end
	end

end
