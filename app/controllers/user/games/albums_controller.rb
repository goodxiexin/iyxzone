class User::Games::AlbumsController < UserBaseController

  layout 'app'

  def index
    @game = Game.find(params[:game_id])
    @albums = @game.albums.paginate :conditions => "privilege != 4 AND photos_count != 0", :page => params[:page], :per_page => 10
  end

end
