class User::Games::PlayersController < UserBaseController

	layout 'app'

	def index
		@players = @game.characters.find(:all)
		@players = @players.paginate :page=>params[:page], :per_page => 10
	end

	def search
		@players = @game.characters.find(:all)
		@characters = []
    @users = User.search(params[:key])
		@users.each{ |user| @characters = @characters | user.characters}
		@players = @characters & @players
    @players = @players.paginate :page => params[:page], :per_page => 10 
	end

	def character_search
		@players = @game.characters.find(:all)
    @characters = GameCharacter.search(params[:key])
		@players = @characters & @players
    @players = @players.paginate :page => params[:page], :per_page => 10 
	end

protected

	def setup
		@game = Game.find(params[:game_id])
		@playing = current_user.games.include?(@game)
		@user = current_user
	rescue
		not_found
	end

end
