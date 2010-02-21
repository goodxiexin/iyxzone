class User::CharactersController < UserBaseController

	def new
    @games = Game.find(:all, :order => 'pinyin ASC')
	  @character = GameCharacter.new
  end

  def show
    render :json => @character.to_json(:include => [:user => {:only => [:name]}])
  end

protected

  def setup
    if ["show"].include? params[:action]
      @character = GameCharacter.find(params[:id])
    end
  rescue
    not_found
  end

end
