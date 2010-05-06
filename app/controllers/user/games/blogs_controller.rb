class User::Games::BlogsController < UserBaseController

  layout 'app'

  def index
    @game = Game.find(params[:game_id])
    @blogs = @game.blogs.paginate :page => params[:page], :per_page => 10, :include => [{:poster => :profile}]
  end

end
