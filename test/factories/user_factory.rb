class UserFactory

  def self.build cond={}
    Factory.build :user, cond
    create_character user
    user
  end

  def self.create cond={}
    user = Factory.create :user, cond
    create_character user
    user 
  end

private
  
  def self.create_character user
    game = Factory.create :game
    area = Factory.create(:game_area, :game_id => game.id)
    server = Factory.create(:game_server, :game_id => game.id, :area_id => area.id)
    race = Factory.create(:game_race, :game_id => game.id)
    prof = Factory.create(:game_profession, :game_id => game.id)
    Factory.create :game_character, {
      :user_id => user.id, 
      :game_id => game.id,
      :area_id => area.id,
      :server_id => server.id, 
      :race_id => race.id,
      :profession_id => prof.id }
  end

end
