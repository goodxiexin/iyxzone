class GameRace < ActiveRecord::Base

  belongs_to :game, :counter_cache => 'races_count'

end
