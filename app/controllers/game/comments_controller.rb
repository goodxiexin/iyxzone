class Game::CommentsController < CommentsController

	layout 'app'

protected

	def catch_commentable
		@game = Game.find(params[:game_id])
		@commentable = @game
	rescue
		not_found
	end

end
