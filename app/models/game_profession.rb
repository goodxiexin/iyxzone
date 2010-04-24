class GameProfession < ActiveRecord::Base

	has_many :characters, :class_name => 'GameCharacter', :foreign_key => 'server_id'

  belongs_to :game

end
