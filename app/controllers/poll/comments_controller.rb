class Poll::CommentsController < CommentsController

protected

  def catch_commentable
    @poll = Poll.find(params[:poll_id])
    @user = @poll.poster
    @commentable = @poll
  rescue
    not_found
  end 


end
