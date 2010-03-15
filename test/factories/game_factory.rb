require 'base'

class GameFactory

  def self.build cond={}
    Factory.build(:game, cond)
  end

  def self.create cond={}
    game = Factory.create(:game, cond)

    if cond[:no_areas].nil?
      area = Factory.create(:game_area, :game_id => game.id)
    end

    if cond[:no_races].nil?
      race = Factory.create(:game_race, :game_id => game.id)
    end

    if cond[:no_professions].nil?
      prof = Factory.create(:game_profession, :game_id => game.id)
    end

    if area.blank?
      server = Factory.create(:game_server, :game_id => game.id)
    else
      server = Factory.create(:game_server, :game_id => game.id, :area_id => area.id)
    end

    game
  end

end
