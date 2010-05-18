class BlogFactory

  def self.create cond={}
    # create poster
    poster = Factory.create :user
    
    # create character
    game        = Factory.create :game
    area        = Factory.create :game_area, :game_id => game.id
    server      = Factory.create :game_server, :game_id => game.id, :area_id => area.id
    profession  = Factory.create :game_profession, :game_id => game.id
    race        = Factory.create :game_race, :game_id => game.id
    character   = Factory.create :game_character, {
      :user_id        => poster.id,
      :game_id        => game.id,
      :server_id      => server.id,
      :area_id        => area.id,
      :profession_id  => profession.id,
      :race_id        => race.id
    }

    # create blog
    # 之所有这么做，是因为，数据校验太复杂了，他会检查你是否有该游戏
    Factory.create :blog, {:poster_id => poster.id, :game_id => character.game_id}
  end

end
