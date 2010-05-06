class User::Games::PlayersController < UserBaseController

	layout 'app'

	def index
		@players = GameCharacter.paginate :page => params[:page], :per_page => 20, :conditions => {:game_id => @game.id}, :include => [{:user => :profile}, :server]
	end

	def search
		@players = User.search(params[:key]).map {|user| user.characters}.flatten & @game.characters
    @players = @players.paginate :page => params[:page], :per_page => 20 
	end

	def character_search
    @players = GameCharacter.search(params[:key], :conditions => {:game_id => @game.id}, :include => [{:user => :profile}, :server])
    @players = @players.paginate :page => params[:page], :per_page => 20 
	end

protected

	def setup
		@game = Game.find(params[:game_id])
	end

end
