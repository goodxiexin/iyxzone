class GameCharacterFactory

  def self.create cond={}
    if cond[:game_id].blank?
      game        = Factory.create :game
      area        = Factory.create :game_area, :game_id => game.id
      server      = Factory.create :game_server, :game_id => game.id, :area_id => area.id
      profession  = Factory.create :game_profession, :game_id => game.id
      race        = Factory.create :game_race, :game_id => game.id
    else
      game        = Game.find(cond[:game_id])
      area        = game.areas.first
      server      = game.no_areas ? game.servers.first : game.areas.first.servers.first
      profession  = game.professions.first
      race        = game.races.first
    end

    if cond[:user_id].blank?
      user = Factory.create :user
    else
      user = User.find(cond[:user_id])
    end
       
    cond = {
      :user_id        => user.id,
      :game_id        => game.id,
      :area_id        => area.id,
      :server_id      => server.id,
      :profession_id  => profession.id,
      :race_id        => race.id
    }.merge(cond)

    Factory.create :game_character, cond 
  end

  def self.clone character
    attrs = character.attributes
    attrs.delete(:id)
    attrs.delete(:name)
    Factory.create :game_character, attrs
  end

end

