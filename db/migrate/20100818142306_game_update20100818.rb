class GameUpdate20100818 < ActiveRecord::Migration
  def self.up
		this_game = Game.find(:first, :conditions => ["name = ?","剑侠情缘3"])
		GameProfession.create(:name => "藏剑",:game_id => this_game.id)
		this_game.areas.last.servers.create( :name => '唯我独尊', :game_id => this_game.id)

		this_game = Game.find(:first, :conditions => ["name = ?","舞型舞秀"])
		GameServer.create( :name => '华东大区', :game_id => this_game.id)
		GameServer.create( :name => '东北大区', :game_id => this_game.id)

  end

  def self.down
  end
end
