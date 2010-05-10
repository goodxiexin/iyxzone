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
    if @guild.blank?
      @characters = current_user.characters
    else
      @characters = GameCharacter.all(:joins => "inner join memberships on memberships.status IN (3,4) and memberships.character_id = game_characters.id and memberships.guild_id = #{@guild.id}")
    end
    render :json => @characters, :only => [:id, :name]  
  end

protected
  
  def setup
    if ["index"].include? params[:action]
      @guild = Guild.find(params[:guild_id]) unless params[:guild_id].blank?
    end
  end

end
