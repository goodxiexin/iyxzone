class User::Games::AlbumsController < UserBaseController

  layout 'app'

  def index
    @game = Game.find(params[:game_id])
    @albums = @game.albums.nonblocked.for('friend').paginate :page => params[:page], :per_page => 10, :include => [{:poster => :profile}, :cover, :latest_photos]
  end

end
