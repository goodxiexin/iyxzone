class User::CharactersController < UserBaseController

	def new
    @games = Game.find(:all, :order => 'pinyin ASC')
	  @character = GameCharacter.new
  end

  def show
    @character = GameCharacter.find(params[:id])
    render :json => @character.to_json(:include => [:user => {:only => [:name]}])
  end

  def index
    cond = @guild.blank? ? {} : {:game_id => @guild.game_id, :server_id => @guild.game_server_id, :area_id => @guild.game_area_id}
    @characters = current_user.characters.find(:all, :conditions => cond)
    render :json => @characters, :only => [:id, :name]  
  end

protected
  
  def setup
    if ["index"].include? params[:action]
      @guild = Guild.find(params[:guild_id]) unless params[:guild_id].blank?
    end
  end

end
