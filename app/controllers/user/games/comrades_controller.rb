class User::Games::ComradesController < UserBaseController

	layout 'app'

  PER_PAGE = 20

  PREFETCH = [{:user => :profile}, :server]

	def index
    @servers = current_user.servers.match(:game_id => @game.id)
		@comrades = GameCharacter.match(:server_id => @servers.map(&:id)).paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
	end

	def search
		@servers = current_user.servers.match(:game_id => @game.id)
    @comrades = GameCharacter.match(:server_id => @servers.map(&:id))
    @characters = User.search(params[:key]).map {|user| user.characters}.flatten
		@comrades = (@characters & @comrades).paginate :page => params[:page], :per_page => PER_PAGE
	end

	def character_search
    @servers = current_user.servers.match(:game_id => @game.id)
    @comrades = GameCharacter.match(:server_id => @servers.map(&:id)).search(params[:key]).paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
	end

protected

	def setup
		@game = Game.find(params[:game_id])
    require_has_game @game
	end

  def require_has_game game
    current_user.has_game?(game) || render_not_found
  end

end
