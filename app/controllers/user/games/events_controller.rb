class User::Games::EventsController < UserBaseController

  layout 'app'

  def index
    @game = Game.find(params[:game_id])
    @events = @game.events.nonblocked.prefetch([{:poster => :profile}, {:album => :cover}, {:game_server => [:area, :game]}]).paginate :page => params[:page], :per_page => 10
  end

end
