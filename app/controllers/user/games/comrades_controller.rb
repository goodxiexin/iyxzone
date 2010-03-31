class User::Games::ComradesController < UserBaseController

	layout 'app'

	def index
		@comrades = []
		if current_user.games.include?(@game)
			current_user.servers.find(:all, :conditions=> { :game_id => @game.id}).each { |server|
				@comrades = @comrades | server.characters
			}
		end
		@comrades = @comrades.paginate :page => params[:page], :per_page => 20
	end

	def search
		@comrades = []
		if current_user.games.include?(@game)
			current_user.servers.find(:all, :conditions=> { :game_id => @game.id}).each { |server|
				@comrades = @comrades | server.characters
			}
		end
		@characters = []
    @users = User.search(params[:key])
		@users.each{ |user| @characters = @characters | user.characters}
		@comrades = @characters & @comrades
    @comrades = @comrades.paginate :page => params[:page], :per_page => 20 
	end

	def character_search
		@comrades = []
		if current_user.games.include?(@game)
			current_user.servers.find(:all, :conditions=> { :game_id => @game.id}).each { |server|
				@comrades = @comrades | server.characters
			}
		end
    @characters = GameCharacter.search(params[:key])
		@comrades = @characters & @comrades
    @comrades = @comrades.paginate :page => params[:page], :per_page => 10 
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
