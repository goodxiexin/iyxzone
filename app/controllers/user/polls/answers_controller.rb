class User::Polls::AnswersController < UserBaseController

  before_filter :owner_required

  def new
  end
 
  def create
    if @poll.update_attributes(params[:poll])
      render :update do |page|
        page << "facebox.close();"
        page.redirect_to poll_url(@poll)
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    @poll = Poll.find(params[:poll_id])
    @user = @poll.poster
  rescue
    not_found
  end

end
