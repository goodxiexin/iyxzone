class AddAdditionalGamesAreasAndServers < ActiveRecord::Migration
  def self.up
		thisgameid = Game.find(:first, :conditions => ["name = ?","疯狂飚车"]).id
		aRecord = GameArea.create( :name => '体验大区', :game_id => thisgameid)
		aRecord.servers.create(:name => '体验一服',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '电信大区', :game_id => thisgameid)
		aRecord.servers.create(:name => '电信一服',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '网通大区', :game_id => thisgameid)
		aRecord.servers.create(:name => '网通一服',  :game_id => thisgameid)

		thisgameid = Game.find(:first, :conditions => ["name = ?","黄易群侠传online"]).id
		aRecord = GameArea.create( :name => '一区', :game_id => thisgameid)
		aRecord.servers.create(:name => '逐鹿中原',  :game_id => thisgameid)
		aRecord.servers.create(:name => '战神图录',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '二区', :game_id => thisgameid)
		aRecord.servers.create(:name => '披荆斩棘',  :game_id => thisgameid)
		aRecord.servers.create(:name => '时空浪族',  :game_id => thisgameid)
		aRecord.servers.create(:name => '侠义谷',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '三区', :game_id => thisgameid)
		aRecord.servers.create(:name => '九五至尊',  :game_id => thisgameid)
		aRecord.servers.create(:name => '破碎虚空',  :game_id => thisgameid)
		aRecord.servers.create(:name => '王者归来',  :game_id => thisgameid)

		thisgameid = Game.find(:first, :conditions => ["name = ?","海盗王online"]).id
		aRecord = GameArea.create( :name => '电信一区华东', :game_id => thisgameid)
		aRecord.servers.create(:name => '斗转星移',  :game_id => thisgameid)
		aRecord.servers.create(:name => '老骥伏枥',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '网通一区东北', :game_id => thisgameid)
		aRecord.servers.create(:name => '海阔天空',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '新手专区', :game_id => thisgameid)
		aRecord.servers.create(:name => '新人天堂',  :game_id => thisgameid)
		aRecord.servers.create(:name => '雏鹰展翅',  :game_id => thisgameid)

		thisgameid = Game.find(:first, :conditions => ["name = ?","劲爆足球"]).id
		GameServer.create( :name => '电信', :game_id => thisgameid)
		GameServer.create( :name => '网通', :game_id => thisgameid)

		thisgameid = Game.find(:first, :conditions => ["name = ?","龙神传说"]).id
		aRecord = GameArea.create( :name => '电信一区', :game_id => thisgameid)
		aRecord.servers.create(:name => '功夫牛',  :game_id => thisgameid)
		aRecord.servers.create(:name => '粉红兔／小老虎',  :game_id => thisgameid)
		aRecord.servers.create(:name => '帝企鹅',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '电信二区', :game_id => thisgameid)
		aRecord.servers.create(:name => '功夫牛',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '网通一区', :game_id => thisgameid)
		aRecord.servers.create(:name => '忍者猫/海蓝兔',  :game_id => thisgameid)
		aRecord.servers.create(:name => '新手营',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '浙江一区', :game_id => thisgameid)
		aRecord.servers.create(:name => '小老虎',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '浙江特区', :game_id => thisgameid)
		aRecord.servers.create(:name => '功夫牛/小仓鼠/机器狗/小老虎',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '广东一区', :game_id => thisgameid)
		aRecord.servers.create(:name => '小松鼠',  :game_id => thisgameid)
		aRecord = GameArea.create( :name => '广东二区', :game_id => thisgameid)
		aRecord.servers.create(:name => '帝企鹅',  :game_id => thisgameid)

		thisgameid = Game.find(:first, :conditions => ["name = ?","冲锋online(RUSH)"]).id
		GameServer.create( :name => '电信', :game_id => thisgameid)
		GameServer.create( :name => '网通', :game_id => thisgameid)

		thisgameid = Game.find(:first, :conditions => ["name = ?","三国征战online"]).id
		aRecord = GameArea.create( :name => '测试服务器', :game_id => thisgameid)
		aRecord.servers.create(:name => '测试服务器',  :game_id => thisgameid)
		
		aGame = Game.find(268)
		aGame.name = '三国杀'
		aGame.professions.clear
		aGame.professions_count = 0
		aGame.save
		GameServer.create( :name => '三国杀', :game_id => aGame.id)

		thisgameid = Game.find(:first, :conditions => ["name = ?","游戏人生"]).id
		aRecord = GameArea.create( :name => '游戏人生', :game_id => thisgameid)
		aRecord.servers.create(:name => '诺亚方舟',  :game_id => thisgameid)

		aGame = Game.find(360)
		aGame.name = '石器时代'
		aGame.save
		GameServer.create( :name => '上海电信一', :game_id => aGame.id)
		GameServer.create( :name => '上海电信二', :game_id => aGame.id)
		GameServer.create( :name => '上海电信三', :game_id => aGame.id)
		GameServer.create( :name => '上海电信四', :game_id => aGame.id)
		GameServer.create( :name => '北京网通一', :game_id => aGame.id)
		GameServer.create( :name => '北京网通二', :game_id => aGame.id)
		GameServer.create( :name => '中华网', :game_id => aGame.id)
		GameServer.create( :name => '北京网通三', :game_id => aGame.id)

		aGame = Game.find(83)
		aGame.areas.clear
		aGame.areas_count = 0
		aGame.servers.clear
		aGame.servers_count = 0
		aGame.save
gamearea1 = GameArea.create(
          :name => "福建1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea1.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea1.id)
GameServer.create(
          :name => "3服",
          :game_id => aGame.id,
          :area_id => gamearea1.id)
GameServer.create(
          :name => "5服",
          :game_id => aGame.id,
          :area_id => gamearea1.id)
gamearea3 = GameArea.create(
          :name => "山东1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea3.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea3.id)
GameServer.create(
          :name => "3服",
          :game_id => aGame.id,
          :area_id => gamearea3.id)
GameServer.create(
          :name => "5服",
          :game_id => aGame.id,
          :area_id => gamearea3.id)
GameServer.create(
          :name => "6服",
          :game_id => aGame.id,
          :area_id => gamearea3.id)
GameServer.create(
          :name => "7服",
          :game_id => aGame.id,
          :area_id => gamearea3.id)
GameServer.create(
          :name => "8服",
          :game_id => aGame.id,
          :area_id => gamearea3.id)
gamearea21 = GameArea.create(
          :name => "广东2区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea21.id)
gamearea4 = GameArea.create(
          :name => "电信1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea4.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea4.id)
GameServer.create(
          :name => "3服",
          :game_id => aGame.id,
          :area_id => gamearea4.id)
GameServer.create(
          :name => "5服",
          :game_id => aGame.id,
          :area_id => gamearea4.id)
gamearea5 = GameArea.create(
          :name => "北京1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea5.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea5.id)
GameServer.create(
          :name => "3服",
          :game_id => aGame.id,
          :area_id => gamearea5.id)
GameServer.create(
          :name => "5服",
          :game_id => aGame.id,
          :area_id => gamearea5.id)
GameServer.create(
          :name => "6服",
          :game_id => aGame.id,
          :area_id => gamearea5.id)
GameServer.create(
          :name => "7服",
          :game_id => aGame.id,
          :area_id => gamearea5.id)
gamearea6 = GameArea.create(
          :name => "上海1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea6.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea6.id)
GameServer.create(
          :name => "3服",
          :game_id => aGame.id,
          :area_id => gamearea6.id)
GameServer.create(
          :name => "5服",
          :game_id => aGame.id,
          :area_id => gamearea6.id)
GameServer.create(
          :name => "6服",
          :game_id => aGame.id,
          :area_id => gamearea6.id)
GameServer.create(
          :name => "7服",
          :game_id => aGame.id,
          :area_id => gamearea6.id)
gamearea7 = GameArea.create(
          :name => "江苏1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea7.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea7.id)
GameServer.create(
          :name => "3服",
          :game_id => aGame.id,
          :area_id => gamearea7.id)
GameServer.create(
          :name => "5服",
          :game_id => aGame.id,
          :area_id => gamearea7.id)
GameServer.create(
          :name => "6服",
          :game_id => aGame.id,
          :area_id => gamearea7.id)
GameServer.create(
          :name => "7服",
          :game_id => aGame.id,
          :area_id => gamearea7.id)
gamearea8 = GameArea.create(
          :name => "东北1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea8.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea8.id)
GameServer.create(
          :name => "3服",
          :game_id => aGame.id,
          :area_id => gamearea8.id)
gamearea9 = GameArea.create(
          :name => "四川1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea9.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea9.id)
GameServer.create(
          :name => "3服",
          :game_id => aGame.id,
          :area_id => gamearea9.id)
gamearea10 = GameArea.create(
          :name => "湖北1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea10.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea10.id)
gamearea11 = GameArea.create(
          :name => "河南1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea11.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea11.id)
gamearea12 = GameArea.create(
          :name => "安徽1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea12.id)
gamearea13 = GameArea.create(
          :name => "广西1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea13.id)
gamearea14 = GameArea.create(
          :name => "湖南1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea14.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea14.id)
gamearea16 = GameArea.create(
          :name => "香港大区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea16.id)
gamearea17 = GameArea.create(
          :name => "云南1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea17.id)
gamearea18 = GameArea.create(
          :name => "江西1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea18.id)
gamearea19 = GameArea.create(
          :name => "陕西1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea19.id)
gamearea20 = GameArea.create(
          :name => "黑龙江1区",
          :game_id => aGame.id)
GameServer.create(
          :name => "1服",
          :game_id => aGame.id,
          :area_id => gamearea20.id)
GameServer.create(
          :name => "2服",
          :game_id => aGame.id,
          :area_id => gamearea20.id)
  end

  def self.down
  end
end
