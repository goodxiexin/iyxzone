class GameAttentionObserver < ActiveRecord::Observer

	def before_create attention
		attention.user.raw_increment :game_attentions_count
	end

	def after_destroy attention
		attention.user.raw_decrement :game_attentions_count
	end

end
