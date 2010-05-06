class User::Games::ComradesController < UserBaseController

	layout 'app'

	def index
		@comrades = []
    servers = current_user.servers.all(:conditions => { :game_id => @game.id})
		@comrades = GameCharacter.paginate :page => params[:page], :per_page => 20, :conditions => {:server_id => servers.map(&:id)}, :include => [{:user => :profile}, :server]
	end

	def search
		@comrades = []
		servers = current_user.servers.all(:conditions=> { :game_id => @game.id})
    @comrades = GameCharacter.all :conditions => {:server_id => servers.map(&:id)}
    @characters = User.search(params[:key]).map {|user| user.characters}.flatten
		@comrades = @characters & @comrades
    @comrades = @comrades.paginate :page => params[:page], :per_page => 20 
	end

	def character_search
		@comrades = []
    servers = current_user.servers.all(:conditions => {:game_id => @game.id})
    @comrades = GameCharacter.search(params[:key], :conditions => {:server_id => servers.map(&:id)}, :include => [{:user => :profile}, :server])
    @comrades = @comrades.paginate :page => params[:page], :per_page => 20 
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
