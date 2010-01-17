class GameArea < ActiveRecord::Base

  belongs_to :game

  has_many :servers, :class_name => 'GameServer', :foreign_key => 'area_id'  

	has_many :characters, :class_name => 'GameCharacter', :foreign_key => 'server_id'

  has_many :users, :through => :characters, :uniq => true

  def validate
    if name.blank?
      errors.add_to_base("没有名字")
      return
    end
  
    if game_id.blank?  
      errors.add_to_base('没有游戏')
    else
      game = Game.find(:first, :conditions => {:id => game_id})
      if game.blank?
        errors.add_to_base("游戏不存在")
      elsif game.no_areas
        errors.add_to_base('该游戏没有服务区')
      end
    end
  end

end
