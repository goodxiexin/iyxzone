class GameUpdate20100813 < ActiveRecord::Migration
  def self.up
this_game = Game.create(
				:name => "红族",
				:official_web => "http://www.hongyanol.com/main.html",
				:sale_date => "2010-08-25",
				:company => "柠檬工厂",
				:agent => "柠檬工厂",
				:description => "2.5D大型即时奇幻武侠网络游戏")
this_game.tag_list = "武侠,奇幻,2.5D, 即时战斗,角色扮演"
this_game.save
GameProfession.create(:name => "战神",:game_id => this_game.id)
GameProfession.create(:name => "魔魂",:game_id => this_game.id)
GameProfession.create(:name => "剑灵",:game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","英雄联盟"])
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

this_game = Game.create(
				:name => "红楼Q梦",
				:official_web => "http://www.ly-game.com/",
				:sale_date => "2010-08-30",
				:company => "梵迪网络",
				:agent => "龙耀科技",
				:description => "Q版2D即时武侠网络游戏")
this_game.tag_list = "Q版,武侠,2D, 即时战斗,角色扮演"
this_game.save
GameProfession.create(:name => "人族",:game_id => this_game.id)
GameProfession.create(:name => "魔族",:game_id => this_game.id)
GameProfession.create(:name => "妖族",:game_id => this_game.id)
GameProfession.create(:name => "仙族",:game_id => this_game.id)
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

this_game = Game.create(
				:name => "侠客行",
				:official_web => "http://xkx.kongzhong.com/",
				:sale_date => "2010-08-21",
				:company => "大承网络",
				:agent => "大承网络",
				:description => "3D即时武侠网络游戏")
this_game.tag_list = "武侠,3D, 即时战斗,角色扮演"
this_game.save
GameProfession.create(:name => "剑客",:game_id => this_game.id)
GameProfession.create(:name => "豪侠",:game_id => this_game.id)
GameProfession.create(:name => "霸王",:game_id => this_game.id)
GameProfession.create(:name => "隐者",:game_id => this_game.id)
GameProfession.create(:name => "方士",:game_id => this_game.id)

this_game = Game.create(
				:name => "八仙过海",
				:official_web => "http://8x.798game.com/",
				:sale_date => "2010-08-20",
				:company => "798网络",
				:agent => "798网络",
				:description => "3D神话回合网络游戏")
this_game.tag_list = "神话,3D, 回合制战斗,角色扮演"
this_game.save

this_game = Game.create(
				:name => "梦幻问情",
				:official_web => "http://mhwq.91yx.com/cover/html/",
				:sale_date => "2010-08-19",
				:company => "问天科技",
				:agent => "问天科技",
				:description => "3D神话回合网络游戏")
this_game.tag_list = "神话,3D, 回合制战斗,角色扮演"
this_game.save
GameProfession.create(:name => "碧云宫",:game_id => this_game.id)
GameProfession.create(:name => "烈焰谷",:game_id => this_game.id)
GameProfession.create(:name => "神剑门",:game_id => this_game.id)
GameProfession.create(:name => "修罗殿",:game_id => this_game.id)
GameProfession.create(:name => "玄冥岭",:game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","极速轮滑"])
this_area = GameArea.create( :name => '电信', :game_id => this_game.id)
this_area.servers.create( :name => '电信一区', :game_id => this_game.id)
this_area = GameArea.create( :name => '网通', :game_id => this_game.id)
this_area.servers.create( :name => '网通一区', :game_id => this_game.id)

this_game = Game.create(
				:name => "圣魔之血",
				:official_web => "http://sm.kongzhong.com/",
				:sale_date => "2010-08-18",
				:company => "空中网",
				:agent => "空中网",
				:description => "3D奇幻角色扮演")
this_game.tag_list = "神话,3D, 即时战斗,角色扮演"
this_game.save
GameProfession.create(:name => "神兵",:game_id => this_game.id)
GameProfession.create(:name => "玄翎",:game_id => this_game.id)
GameProfession.create(:name => "乾坤",:game_id => this_game.id)
GameProfession.create(:name => "仙音",:game_id => this_game.id)

this_game = Game.create(
				:name => "快乐神仙",
				:official_web => "http://kl.028yx.com/",
				:sale_date => "2010-08-13",
				:company => "蓝港在线",
				:agent => "四川数字出版",
				:description => "2D回合制神话角色扮演")
this_game.tag_list = "神话,2D, 回合制战斗,角色扮演"
this_game.save
GameServer.create( :name => '傲来国', :game_id => this_game.id)
GameServer.create( :name => '飘仙阁', :game_id => this_game.id)
GameServer.create( :name => '蓬莱岛', :game_id => this_game.id)
GameProfession.create(:name => "大唐官府",:game_id => this_game.id)
GameProfession.create(:name => "化生寺",:game_id => this_game.id)
GameProfession.create(:name => "龙宫",:game_id => this_game.id)
GameProfession.create(:name => "普陀山",:game_id => this_game.id)
GameProfession.create(:name => "盘丝岭",:game_id => this_game.id)
GameProfession.create(:name => "狮驼岭",:game_id => this_game.id)

this_game = Game.create(
				:name => "洛汗",
				:official_web => "http://rohan.com.cn/guide/",
				:sale_date => "2010-08-12",
				:company => "YNK Korea",
				:agent => "零度聚阵",
				:description => "3D奇幻角色扮演")
this_game.tag_list = "奇幻,3D, 即时战斗,角色扮演"
this_game.save
GameProfession.create(:name => "人类",:game_id => this_game.id)
GameProfession.create(:name => "精灵",:game_id => this_game.id)
GameProfession.create(:name => "半精灵",:game_id => this_game.id)
GameProfession.create(:name => "郸",:game_id => this_game.id)
GameProfession.create(:name => "龙族",:game_id => this_game.id)
GameProfession.create(:name => "黑精灵",:game_id => this_game.id)
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

game = Game.find(:first, :conditions => ["name = ?","龙魂"])
game.areas.first.servers.first.name = "龙战天下"
game.areas.first.servers.first.save
game.areas.first.servers.second.name = "歃血为盟"
game.areas.first.servers.second.save
game.areas.first.servers.create( :name => '醉卧沙场', :game_id => game.id)
game.areas.second.servers.first.name = "义结金兰"
game.areas.second.servers.first.save
game.areas.third.servers.first.name = "魂动九州"
game.areas.third.servers.first.save

this_game = Game.find(:first, :conditions => ["name = ?","星空传奇"])
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","仙剑神曲"])
this_area = GameArea.create( :name => '电信一区', :game_id => this_game.id)
this_area.servers.create( :name => '傲剑苍穹', :game_id => this_game.id)
this_area.servers.create( :name => '风起云涌', :game_id => this_game.id)
this_area.servers.create( :name => '紫气东来', :game_id => this_game.id)
this_area.servers.create( :name => '龙战于野', :game_id => this_game.id)
this_area.servers.create( :name => '长虹贯日', :game_id => this_game.id)
this_area = GameArea.create( :name => '网通一区', :game_id => this_game.id)
this_area.servers.create( :name => '纵横天下', :game_id => this_game.id)
this_area.servers.create( :name => '气吞山河', :game_id => this_game.id)
this_area.servers.create( :name => '战无不胜', :game_id => this_game.id)

this_game = Game.find(708)
this_game.destroy
  end

  def self.down
  end
end
