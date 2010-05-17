class User::Games::PlayersController < UserBaseController

	layout 'app'

  PER_PAGE = 20

  PREFETCH = [{:user => :profile}, :server]

	def index
		@players = GameCharacter.match(:game_id => @game.id).paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
	end

	def search
		@players = User.search(params[:key]).map {|user| user.characters}.flatten
    @players = (@players & @game.characters).paginate :page => params[:page], :per_page => PER_PAGE
	end

	def character_search
    @players = GameCharacter.match(:game_id => @game.id).search(params[:key]).paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
	end

protected

	def setup
		@game = Game.find(params[:game_id])
	end

end
