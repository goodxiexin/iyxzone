class User::Games::GuildsController < UserBaseController

  layout 'app'

  def index
    @game = Game.find(params[:game_id])
    @guilds = @game.guilds.nonblocked.prefetch([{:president => :profile}, {:album => :cover}, {:game_server => [:area, :game]}, :forum]).paginate :page => params[:page], :per_page => 10
  end

end
