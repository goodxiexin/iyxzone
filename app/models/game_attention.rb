class GameAttention < ActiveRecord::Base

  belongs_to :user

  belongs_to :game, :counter_cache => :attentions_count

	def validate_on_create
		if game.attentions.find_by_user_id(user_id)
			errors.add_to_base('你已经关注了这个游戏')
		end
	end

end
