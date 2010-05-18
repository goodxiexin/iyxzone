class GameCharacterFactory

  def self.create cond={}
    game        = Factory.create :game
    area        = Factory.create :game_area, :game_id => game.id
    server      = Factory.create :game_server, :game_id => game.id, :area_id => area.id
    profession  = Factory.create :game_profession, :game_id => game.id
    race        = Factory.create :game_race, :game_id => game.id

    cond = {
      :game_id        => game.id,
      :area_id        => area.id,
      :server_id      => server.id,
      :profession_id  => profession.id,
      :race_id        => race.id
    }.merge(cond)

    Factory.create :game_character, cond 
  end

end

