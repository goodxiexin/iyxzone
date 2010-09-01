class GameUpdate20100825 < ActiveRecord::Migration
  def self.up
		this_game = Game.find(:first, :conditions => ["name = ?","众神之战"])
		this_area = this_game.areas.first
		this_area.name = "电信一区"
		this_area.save
		this_area.servers.create( :name => '翡翠座', :game_id => this_game.id)
		this_area.servers.create( :name => '绿洲座', :game_id => this_game.id)
		this_area.servers.create( :name => '冰封座', :game_id => this_game.id)
		this_area.servers.create( :name => '守望座', :game_id => this_game.id)
		this_area.servers.create( :name => '暮色座', :game_id => this_game.id)
		this_area.servers.create( :name => '泰坦座', :game_id => this_game.id)
		this_area.servers.create( :name => '幻境座', :game_id => this_game.id)
		this_area.servers.create( :name => '疾风座', :game_id => this_game.id)
		this_area.servers.create( :name => '灯塔座', :game_id => this_game.id)
		this_area.servers.create( :name => '荣耀座', :game_id => this_game.id)
		this_area.servers.create( :name => '彗星座', :game_id => this_game.id)
		this_area.servers.create( :name => '光速座', :game_id => this_game.id)
		this_area = this_game.areas.second
		this_area.name = "网通一区"
		this_area.save
		this_area.servers.create( :name => '龙牙座', :game_id => this_game.id)
		this_area.servers.create( :name => '雪山座', :game_id => this_game.id)
		this_area.servers.create( :name => '神殿座', :game_id => this_game.id)
		this_area.servers.create( :name => '鹰角座', :game_id => this_game.id)
		this_area.servers.create( :name => '海港座', :game_id => this_game.id)
		this_area.servers.create( :name => '冰原座', :game_id => this_game.id)
		this_area.servers.create( :name => '烈焰座', :game_id => this_game.id)
		this_area.servers.create( :name => '赞誉座', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信二区', :game_id => this_game.id)
		this_area.servers.create( :name => '旋律座', :game_id => this_game.id)
		this_area.servers.create( :name => '流冰座', :game_id => this_game.id)
		this_area.servers.create( :name => '龙鳞座', :game_id => this_game.id)
		this_area.servers.create( :name => '梦想座', :game_id => this_game.id)
		this_area.servers.create( :name => '王者座', :game_id => this_game.id)
		this_area.servers.create( :name => '风暴座', :game_id => this_game.id)
		this_area.servers.create( :name => '飞翔座', :game_id => this_game.id)
		this_area.servers.create( :name => '苍穹座', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信三区', :game_id => this_game.id)
		this_area.servers.create( :name => '新月座', :game_id => this_game.id)
		this_area.servers.create( :name => '英雄座', :game_id => this_game.id)
		this_area.servers.create( :name => '碧空座', :game_id => this_game.id)
		this_area.servers.create( :name => '炽光座', :game_id => this_game.id)
		this_area = GameArea.create( :name => '网通二区', :game_id => this_game.id)
		this_area.servers.create( :name => '圣战座', :game_id => this_game.id)
		this_area.servers.create( :name => '雷云座', :game_id => this_game.id)
		this_area.servers.create( :name => '凤翼座', :game_id => this_game.id)
		this_area.servers.create( :name => '裂影座', :game_id => this_game.id)
		this_area.servers.create( :name => '旷野座', :game_id => this_game.id)
		this_area.servers.create( :name => '逆鳞座', :game_id => this_game.id)
		this_area.servers.create( :name => '晨曦座', :game_id => this_game.id)
		this_area.servers.create( :name => '月吟座', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信四区', :game_id => this_game.id)
		this_area.servers.create( :name => '音速座', :game_id => this_game.id)
		this_area.servers.create( :name => '幽灵座', :game_id => this_game.id)
		this_area.servers.create( :name => '古神座', :game_id => this_game.id)
		this_area.servers.create( :name => '魔焰座', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信五区', :game_id => this_game.id)
		this_area.servers.create( :name => '霜纹座', :game_id => this_game.id)
		this_area.servers.create( :name => '骤雨座', :game_id => this_game.id)
		this_area.servers.create( :name => '怒吼座', :game_id => this_game.id)
		this_area.servers.create( :name => '幻日座', :game_id => this_game.id)
		this_area.servers.create( :name => '沧海座', :game_id => this_game.id)
		this_area = GameArea.create( :name => '网通三区', :game_id => this_game.id)
		this_area.servers.create( :name => '潜龙座', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信六区', :game_id => this_game.id)
		this_area.servers.create( :name => '烽火座', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信七区', :game_id => this_game.id)
		this_area.servers.create( :name => '冰冠座', :game_id => this_game.id)
		this_area.servers.create( :name => '圣魂座', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信八区', :game_id => this_game.id)
		this_area.servers.create( :name => '深渊座', :game_id => this_game.id)
		this_area.servers.create( :name => '青龙座', :game_id => this_game.id)
		this_area.servers.create( :name => '白虎座', :game_id => this_game.id)
		this_area.servers.create( :name => '朱雀座', :game_id => this_game.id)

		this_game = Game.create(
				:name => "浪漫Q唐",
				:official_web => "http://qt.dkmol.com/index.html",
				:sale_date => "2010-9-10",
				:company => "成都哆可梦",
				:agent => "成都哆可梦",
				:description => "2.5DQ版回合制角色扮演游戏")
		this_game.tag_list = "Q版, 神话, 回合制战斗, 角色扮演, 2.5D"
		this_game.save
		GameRace.create(:name => "侠",:game_id => this_game.id)
		GameRace.create(:name => "道",:game_id => this_game.id)
		GameRace.create(:name => "仙",:game_id => this_game.id)
		GameProfession.create(:name => "上清观",:game_id => this_game.id)
		GameProfession.create(:name => "水晶宫",:game_id => this_game.id)
		GameProfession.create(:name => "唐王府",:game_id => this_game.id)
		GameProfession.create(:name => "天庭",:game_id => this_game.id)
		GameProfession.create(:name => "瓦岗寨",:game_id => this_game.id)
		GameProfession.create(:name => "终南山",:game_id => this_game.id)
		this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
		this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

		this_game = Game.create(
				:name => "鬼舞王者",
				:official_web => "http://gmyha2.17jago.com/",
				:sale_date => "2010-8-30",
				:company => "架构信息科技",
				:agent => "架构信息科技",
				:description => "3DQ版即时战斗角色扮演游戏")
		this_game.tag_list = "Q版,奇幻, 即时战斗, 角色扮演, 3D"
		this_game.save
		GameProfession.create(:name => "魔法师",:game_id => this_game.id)
		GameProfession.create(:name => "黑暗牧师",:game_id => this_game.id)
		GameProfession.create(:name => "巫师",:game_id => this_game.id)
		GameProfession.create(:name => "魔战士",:game_id => this_game.id)
		GameProfession.create(:name => "圣骑士",:game_id => this_game.id)
		GameProfession.create(:name => "游侠",:game_id => this_game.id)
		GameProfession.create(:name => "狂战士",:game_id => this_game.id)
		GameProfession.create(:name => "神射手",:game_id => this_game.id)
		GameServer.create( :name => '莱特瑞恩', :game_id => this_game.id)

		this_game = Game.create(
				:name => "战斗足球",
				:official_web => "http://fso.9igame.com/",
				:sale_date => "2010-8-28",
				:company => "上海艺为",
				:agent => "上海艺为",
				:description => "3DQ版休闲角色扮演游戏")
		this_game.tag_list = "Q版,休闲, 体育, 角色扮演, 3D"
		this_game.save
		this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
		this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

		this_game = Game.create(
				:name => "诸神之战",
				:official_web => "http://zszz.sdo.com/",
				:sale_date => "2010-8-27",
				:company => "锦天科技",
				:agent => "盛大网络",
				:description => "2.5D奇幻角色扮演游戏")
		this_game.tag_list = "奇幻, 即时战斗, 角色扮演, 2.5D"
		this_game.save
		GameProfession.create(:name => "战士",:game_id => this_game.id)
		GameProfession.create(:name => "猎手",:game_id => this_game.id)
		GameProfession.create(:name => "术士",:game_id => this_game.id)
		this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
		this_area.servers.create( :name => '紫电', :game_id => this_game.id)
		this_area.servers.create( :name => '碧血', :game_id => this_game.id)

		this_game = Game.create(
				:name => "勇者斗斗龙",
				:official_web => "http://ddl.go2game.com/",
				:sale_date => "2010-8-27",
				:company => "网游数码科技",
				:agent => "网游数码科技",
				:description => "2DQ版回合制奇幻角色扮演游戏")
		this_game.tag_list = "Q版,奇幻, 回合制战斗, 角色扮演, 2D"
		this_game.save
		GameProfession.create(:name => "咒术师",:game_id => this_game.id)
		GameProfession.create(:name => "主教",:game_id => this_game.id)
		GameProfession.create(:name => "元素使",:game_id => this_game.id)
		GameProfession.create(:name => "圣言使",:game_id => this_game.id)
		GameProfession.create(:name => "机械士",:game_id => this_game.id)
		GameProfession.create(:name => "炮术士",:game_id => this_game.id)
		GameProfession.create(:name => "狂战士",:game_id => this_game.id)
		GameProfession.create(:name => "魔剑士",:game_id => this_game.id)
		this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
		this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

		this_game = Game.create(
				:name => "绝对火力",
				:official_web => "http://af.91.com/",
				:sale_date => "2010-8-23",
				:company => "网龙",
				:agent => "网龙",
				:description => "3D第一人称射击游戏")
		this_game.tag_list = "竞技, 第一人称射击, 3D"
		this_game.save
		this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
		this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

		this_game = Game.find(:first, :conditions => ["name = ?","天之痕OL"])
		this_area = this_game.areas.first
		this_area.servers.create( :name => '锦绣江山', :game_id => this_game.id)
		this_area.servers.create( :name => '雄霸天下', :game_id => this_game.id)
		this_area = this_game.areas.second
		this_area.servers.create( :name => '金戈铁马', :game_id => this_game.id)
		this_area.servers.create( :name => '傲视群雄', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信二区', :game_id => this_game.id)
		this_area.servers.create( :name => '风起云涌', :game_id => this_game.id)
		this_area.servers.create( :name => '纵横四海', :game_id => this_game.id)
		this_area.servers.create( :name => '侠骨柔情', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信三区', :game_id => this_game.id)
		this_area.servers.create( :name => '王者大陆', :game_id => this_game.id)
		this_area = GameArea.create( :name => '电信四区', :game_id => this_game.id)
		this_area.servers.create( :name => '排山倒海', :game_id => this_game.id)
		this_area.servers.create( :name => '峥嵘岁月', :game_id => this_game.id)

		this_game = Game.find(:first, :conditions => ["name = ?","龙之谷"])
		this_area = GameArea.create( :name => '华东电信七区', :game_id => this_game.id)
		this_area.servers.create( :name => '1服-龙魂传世', :game_id => this_game.id)
		this_area.servers.create( :name => '2服-龙行流云', :game_id => this_game.id)
		this_area = GameArea.create( :name => '华北网通五区', :game_id => this_game.id)
		this_area.servers.create( :name => '1服-勇士之刃', :game_id => this_game.id)
		this_area.servers.create( :name => '2服-太阳之都', :game_id => this_game.id)

  end

  def self.down
  end
end
