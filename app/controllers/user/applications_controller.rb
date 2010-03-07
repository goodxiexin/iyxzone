class User::ApplicationsController < UserBaseController

  layout 'app'

  def show
    @application = Application.find(params[:id])
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

end
