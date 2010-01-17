class GameServer < ActiveRecord::Base

  belongs_to :game

  belongs_to :area, :class_name => 'GameArea'

	has_many :characters, :class_name => 'GameCharacter', :foreign_key => 'server_id'

	has_many :users, :through => :characters, :uniq => true

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
        errors.add_to_base('游戏不存在')
      elsif !game.no_areas
        if area_id.blank?
          errors.add_to_base('没有服务区')
        elsif GameArea.find(:first, :conditions => {:game_id => game_id, :id => area_id}).blank?
          errors.add_to_base('服务区不存在')
        end
      end
    end
  end

end
