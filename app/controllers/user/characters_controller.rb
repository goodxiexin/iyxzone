class User::CharactersController < UserBaseController

	def new
    @games = Game.find(:all, :order => 'pinyin ASC')
	  @character = GameCharacter.new
  end

  def show
    @character = GameCharacter.find(params[:id])
    render :json => @character.to_json(:include => [:user => {:only => [:name]}])
  end

end
