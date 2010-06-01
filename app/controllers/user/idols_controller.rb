class User::IdolsController < UserBaseController

  def index
    @idols = User.match(:is_idol => true).order("fans_count DESC").paginate :page => params[:page], :per_page => 20
  end

end
