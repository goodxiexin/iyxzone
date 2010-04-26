class GameRace < ActiveRecord::Base

  has_many :characters, :class_name => 'GameCharacter', :foreign_key => 'race_id'

  belongs_to :game

end
