class User::Games::ComradesController < UserBaseController

	layout 'app'

	def index
		@comrades = []
		if @playing
      servers = current_user.servers.all(:conditions => { :game_id => @game.id})
		  @comrades = GameCharacter.paginate :page => params[:page], :per_page => 20, :conditions => {:server_id => servers.map(&:id)}
    end
	end

	def search
		@comrades = []
		if @playing
			servers = current_user.servers.all(:conditions=> { :game_id => @game.id})
      @comrades = GameCharacter.all :conditions => {:server_id => servers.map(&:id)}
		end
    @characters = User.search(params[:key]).map {|user| user.characters}.flatten
		@comrades = @characters & @comrades
    @comrades = @comrades.paginate :page => params[:page], :per_page => 20 
	end

	def character_search
		@comrades = []
		if @playing
      servers = current_user.servers.all(:conditions => {:game_id => @game.id})
      @comrades = GameCharacter.search(params[:key], :conditions => {:server_id => servers.map(&:id)})
    end
    @comrades = @comrades.paginate :page => params[:page], :per_page => 20 
	end

protected

	def setup
		@game = Game.find(params[:game_id])
		@playing = current_user.has_game? @game
	end

end
