class User::Polls::AnswersController < UserBaseController

  def new
  end
 
  def create
    if @poll.update_attributes(:answers => params[:poll][:answers])
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    @poll = Poll.find(params[:poll_id])
    require_verified @poll
    require_owner @poll.poster
  end

end
