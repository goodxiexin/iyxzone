class AddDota < ActiveRecord::Migration
  def self.up
game743 = Game.create(
			:name => "Dota",
			:official_web => "http://www.getdota.com/",
			:sale_date => "2006-4-26",
			:company => "暴雪",
			:agent => "IceFrog",
			:no_areas => true,
			:no_races => true,
			:no_professions => true,
			:description => "欧美竞技游戏")
Gameswithhole.create( :txtid => 743, :sqlid => game743.id, :gamename => game743.name )
			game743.tag_list = "dota, 竞技, 3D"
			game743.save
			GameServer.create(:name => "battle.net", :game_id => game743.id)
			GameServer.create(:name => "浩方平台", :game_id => game743.id)
			GameServer.create(:name => "VS平台", :game_id => game743.id)
			GameServer.create(:name => "QQ平台", :game_id => game743.id)
			GameServer.create(:name => "掌门人平台", :game_id => game743.id)
			GameServer.create(:name => "GG平台", :game_id => game743.id)
  end

  def self.down
  end
end
