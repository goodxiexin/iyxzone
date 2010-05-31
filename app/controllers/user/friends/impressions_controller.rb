class User::Friends::ImpressionsController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  def index
    @friends = current_user.friends.paginate :page => params[:page], :per_page => PER_PAGE, :order => 'login ASC'
  end

end
