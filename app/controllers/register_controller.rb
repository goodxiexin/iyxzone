class RegisterController < ApplicationController

	def new_character
	end

	def edit_character
    @id = params[:id].to_i
		@character = GameCharacter.new(params[:character])
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
