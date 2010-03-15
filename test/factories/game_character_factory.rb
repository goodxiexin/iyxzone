require 'base'
require 'game_factory'

class GameCharacterFactory

  def self.build cond={}
  end

  def self.create cond={}
    game = Factory.create(:game, cond)
  end

end

