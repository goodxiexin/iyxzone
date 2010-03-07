class User::Games::TagsController < User::TagsController

protected

	def get_taggable
		@taggable = Game.find(params[:game_id])
	end

end
