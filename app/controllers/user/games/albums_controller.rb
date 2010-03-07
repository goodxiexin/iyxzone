class User::Games::AlbumsController < UserBaseController

  layout 'app'

  def index
    @game = Game.find(params[:game_id])
    @albums = @game.albums.paginate :page => params[:page], :per_page => 10
  end

end
