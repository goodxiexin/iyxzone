class GameFactory

  def self.create cond={}
    # merge cond and default options
    cond = {
      :no_areas       => false,
      :no_servers     => false,
      :no_professions => false,
      :no_races       => false
    }.merge(cond)

    # check out some flags
    no_areas = cond.delete(:no_areas)
    no_servers = cond.delete(:no_servers)
    no_professions = cond.delete(:no_professions)
    no_races = cond.delete(:no_races)
    
    # build game
    game = Factory.create :game, cond

    # build associations
    if !no_areas
      area = Factory.create :game_area, :game_id => game.id
    end

    if !no_races
      race = Factory.create :game_race, :game_id => game.id
    end

    if !no_professions
      prof = Factory.create :game_profession, :game_id => game.id
    end

    if no_areas and !no_servers
      server = Factory.create :game_server, :game_id => game.id
    elsif !no_areas and !no_servers
      server = Factory.create :game_server, :game_id => game.id, :area_id => area.id
    end

    game.reload
  end

end
