class User::CharactersController < UserBaseController

	def new
    @games = Game.find(:all, :order => 'pinyin ASC')
	  @character = GameCharacter.new
  end
	
  def destroy
    if @character.destroy
      render :partial => 'user/profiles/characters', :locals => {:user => current_user}
    else
      render :update do |page|
        page << "error('发生错误，无法删除');"
      end
    end  
  end

protected

	def setup
		if ["destroy"].include? params[:action]
			@character = current_user.characters.find(params[:id])
		end
	rescue
		not_found
	end

end
