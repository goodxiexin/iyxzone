class User::Polls::VotesController < UserBaseController

  def create
		@vote = @poll.votes.build(:voter_id => current_user.id, :answer_ids => params[:votes])
		
    if @vote.save
      render :json => {:code => 1}
      #redirect_to poll_url(@poll)
		else
      render :json => {:code => 0}
			#flash[:error] = "#{@vote.errors.on(:answer_ids)}: #{@vote.errors.on(:poll_id)}"#保存的时候发生错误"
			#redirect_to poll_url(@poll)
		end
  end

protected

  def setup
    @poll = Poll.find(params[:poll_id])
    require_verified @poll
  end

end
