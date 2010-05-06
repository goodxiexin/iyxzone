class User::Games::GuildsController < UserBaseController

  layout 'app'

  def index
    @game = Game.find(params[:game_id])
    @guilds = @game.guilds.paginate :page => params[:page], :per_page => 10, :include => [{:president => :profile}, {:album => :cover}, {:game_server => [:area, :game]}, :forum]
  end

end
