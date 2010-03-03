class User::ApplicationsController < UserBaseController

  layout 'app'

  def show
  end

protected

  def setup
    @application = Application.find(params[:id])
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  rescue
    not_found
  end

end
