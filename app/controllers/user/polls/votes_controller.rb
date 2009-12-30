class User::Polls::VotesController < UserBaseController

  before_filter :privilege_required

  def create
		if @poll.votes.create(:voter_id => current_user.id, :answer_ids => params[:votes])
			redirect_to poll_url(@poll)
		else
			flash[:error] = "保存的时候发生错误"
			redirect_to poll_url(@poll)
		end
  end

protected

  def setup
    @poll = Poll.find(params[:poll_id])
    @user = @poll.poster
    @privilege = @poll.privilege
  rescue
    not_found
  end

end
