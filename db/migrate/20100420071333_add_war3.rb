class AddWar3 < ActiveRecord::Migration
  def self.up
game742 = Game.create(
			:name => "魔兽争霸3",
			:official_web => "www.blizzard.com/",
			:sale_date => "2003-6-22",
			:company => "暴雪",
			:agent => "暴雪",
			:no_areas => true,
			:no_races => true,
			:description => "欧美大型即时战略游戏")
Gameswithhole.create( :txtid => 742, :sqlid => game742.id, :gamename => game742.name )
			game742.tag_list = "奇幻, RTS, 即时战略, 3D"
			game742.save
			GameServer.create(:name => "battle.net", :game_id => game742.id)
			GameServer.create(:name => "浩方平台", :game_id => game742.id)
			GameServer.create(:name => "VS平台", :game_id => game742.id)
			GameServer.create(:name => "QQ平台", :game_id => game742.id)
			GameServer.create(:name => "掌门人平台", :game_id => game742.id)
			GameServer.create(:name => "GG平台", :game_id => game742.id)
    GameProfession.create(
        :name => "人族",
        :game_id => game742.id)
    GameProfession.create(
        :name => "兽族",
        :game_id => game742.id)
    GameProfession.create(
        :name => "不死族",
        :game_id => game742.id)
    GameProfession.create(
        :name => "暗夜精灵族",
        :game_id => game742.id)
    GameProfession.create(
        :name => "随机",
        :game_id => game742.id)
  end

  def self.down
		g = Game.find(:first, :conditions => "name='魔兽争霸3'")
		g.destroy
  end
end
