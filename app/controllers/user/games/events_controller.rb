class User::Games::EventsController < UserBaseController

  layout 'app'

  def index
    @game = Game.find(params[:game_id])
    @events = @game.events.paginate :page => params[:page], :per_page => 10, :include => [{:poster => :profile}, {:album => :cover}, {:game_server => [:area, :game]}]
  end

end
