class User::Games::BlogsController < UserBaseController

  layout 'app'

  def index
    @game = Game.find(params[:game_id])
    @blogs = @game.blogs.nonblocked.for('friend').prefetch([{:poster => :profile}]).paginate :page => params[:page], :per_page => 10
  end

end
