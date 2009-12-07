class GameProfession < ActiveRecord::Base

  belongs_to :game, :counter_cache => 'professions_count'

end
