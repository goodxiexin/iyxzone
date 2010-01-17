class GameRace < ActiveRecord::Base

  belongs_to :game

  def validate
    if name.blank?
      errors.add_to_base('没有名字')
      return
    end

    if game_id.blank?
      errors.add_to_base('没有游戏')
    else
      game = Game.find(:first, :conditions => {:id => game_id})
      if game.blank?
        errors.add_to_base("游戏不存在")
      elsif game.no_races
        errors.add_to_base('该游戏没有种族')
      end
    end
  end

end
