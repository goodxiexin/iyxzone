class GameCharacterFactory

  def self.build arg={}
      Factory.build :game_character, arg
  end

  def self.create arg={}
      Factory.create :game_character, arg
  end

end

