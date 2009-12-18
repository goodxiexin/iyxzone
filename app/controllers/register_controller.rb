class RegisterController < ApplicationController

	def new_character
	  @games = Game.find(:all, :order => 'pinyin ASC')
  end

	def edit_character
    @id = params[:id].to_i
		@character = GameCharacter.new(params[:character])
    @game = @character.game
    @games = Game.find(:all, :order => 'pinyin ASC')
    @rating = params[:rating].to_i
	end

  def validates_email_uniqueness
    if User.find_by_email(params[:email])
      render :text => 'no'
    else
      render :text => 'yes'
    end
  end

end
