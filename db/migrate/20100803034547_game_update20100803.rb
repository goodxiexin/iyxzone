class GameUpdate20100803 < ActiveRecord::Migration
  def self.up
this_game = Game.create(
				:name => "HON(Heroes of Newerth)",
				:official_web => "http://www.heroesofnewerth.com/",
				:sale_date => "2010-07-08",
				:company => "S2 Games",
				:agent => "S2 Games",
				:description => "仿Dota类网游")
this_game.tag_list = "Dota,竞技"
this_game.save
GameServer.create( :name => 'HON服务器', :game_id => this_game.id)

game_id = Game.find(:first, :conditions => ["name = ?","龙之谷"]).id
this_area = GameArea.create( :name => '华东电信五区', :game_id => game_id)
this_area.servers.create( :name => '1服-剑气飞虹', :game_id => game_id)
this_area.servers.create( :name => '2服-箭雨风暴', :game_id => game_id)
this_area.servers.create( :name => '3服-天堂审判', :game_id => game_id)
this_area.servers.create( :name => '4服-鹰击长空', :game_id => game_id)
this_area = GameArea.create( :name => '华南电信五区', :game_id => game_id)
this_area.servers.create( :name => '1服-龙之巢穴', :game_id => game_id)
this_area.servers.create( :name => '2服-龙之叹息', :game_id => game_id)
this_area.servers.create( :name => '3服-龙眠之地', :game_id => game_id)
this_area.servers.create( :name => '4服-龙神之怒', :game_id => game_id)
this_area = GameArea.create( :name => '西部电信一区', :game_id => game_id)
this_area.servers.create( :name => '1服-龙神禁地', :game_id => game_id)
this_area.servers.create( :name => '2服-神之领域', :game_id => game_id)
this_area.servers.create( :name => '3服-次元空间', :game_id => game_id)
this_area.servers.create( :name => '4服-神秘之境', :game_id => game_id)
this_area = GameArea.create( :name => '华北网通三区', :game_id => game_id)
this_area.servers.create( :name => '1服-风雷激荡', :game_id => game_id)
this_area.servers.create( :name => '2服-风云变幻', :game_id => game_id)
this_area.servers.create( :name => '3服-冰火交织', :game_id => game_id)
this_area.servers.create( :name => '4服-电闪雷鸣', :game_id => game_id)
this_area = GameArea.create( :name => '华东电信六区', :game_id => game_id)
this_area.servers.create( :name => '1服-美丽国度', :game_id => game_id)
this_area.servers.create( :name => '2服-荣耀之城', :game_id => game_id)
this_area.servers.create( :name => '3服-勇者大陆', :game_id => game_id)
this_area.servers.create( :name => '4服-魔幻天堂', :game_id => game_id)
this_area = GameArea.create( :name => '东北网通三区', :game_id => game_id)
this_area.servers.create( :name => '1服-龙的史诗', :game_id => game_id)
this_area.servers.create( :name => '2服-龙战天涯', :game_id => game_id)
this_area.servers.create( :name => '3服-龙心绯月', :game_id => game_id)
this_area.servers.create( :name => '4服-龙游天下', :game_id => game_id)
this_area = GameArea.create( :name => '华南电信六区', :game_id => game_id)
this_area.servers.create( :name => '1服-炎龙天下', :game_id => game_id)
this_area.servers.create( :name => '2服-魔龙之翼', :game_id => game_id)
this_area.servers.create( :name => '3服-圣龙之殿', :game_id => game_id)
this_area.servers.create( :name => '4服-幻龙之影', :game_id => game_id)
this_area = GameArea.create( :name => '华北网通四区', :game_id => game_id)
this_area.servers.create( :name => '1服-激流之谷', :game_id => game_id)
this_area.servers.create( :name => '2服-沉寂之森', :game_id => game_id)
this_area.servers.create( :name => '3服-圣域之门', :game_id => game_id)
this_area.servers.create( :name => '4服-盘龙之峰', :game_id => game_id)
this_area = GameArea.create( :name => '南方电信二区', :game_id => game_id)
this_area.servers.create( :name => '1服-英雄之谷', :game_id => game_id)
this_area.servers.create( :name => '2服-永恒之火', :game_id => game_id)
this_area.servers.create( :name => '3服-王者之意', :game_id => game_id)
this_area.servers.create( :name => '4服-光芒之心', :game_id => game_id)

game = Game.find(:first, :conditions => ["name = ?","猎国"])
game_area = game.areas.find(:first, :conditions => ["name = ?","电信区"])
game_area.servers.first.name = "亚美尼亚"
game_area.servers.first.save
game_area.servers.create( :name => '神秘剑屋', :game_id => game.id)
game_area = game.areas.find(:first, :conditions => ["name = ?","网通区"])
game_area.name = "双线区"
game_area.save
game_area.servers.first.name = "野火原"
game_area.servers.first.save
GameProfession.create(:name => "巫医法师",:game_id => game.id)
GameProfession.create(:name => "术法法师",:game_id => game.id)
GameProfession.create(:name => "强弓弓箭手",:game_id => game.id)
GameProfession.create(:name => "狩猎弓箭手",:game_id => game.id)
GameProfession.create(:name => "血怒战士",:game_id => game.id)
GameProfession.create(:name => "防御战士",:game_id => game.id)

this_game = Game.create(
				:name => "镜花缘OL",
				:official_web => "http://jhy.zy528.com/",
				:sale_date => "2010-7-22",
				:company => "智艺网络科技",
				:agent => "智艺网络科技",
				:description => "Q版神化角色扮演游戏")
this_game.tag_list = "神化,角色扮演,2.5D,道具收费"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)
GameProfession.create(:name => "剑灵武者",:game_id => this_game.id)
GameProfession.create(:name => "血御武者",:game_id => this_game.id)
GameProfession.create(:name => "繁花方士",:game_id => this_game.id)
GameProfession.create(:name => "凋零方士",:game_id => this_game.id)
GameProfession.create(:name => "水镜道士",:game_id => this_game.id)
GameProfession.create(:name => "追火道士",:game_id => this_game.id)
GameProfession.create(:name => "狩猎行者",:game_id => this_game.id)
GameProfession.create(:name => "迷踪行者",:game_id => this_game.id)

this_game = Game.create(
				:name => "蓝海战记",
				:official_web => "http://lh.9you.com/web_v2/index_top.html",
				:sale_date => "2010-6-20",
				:company => "Nettime Soft",
				:agent => "久游网络",
				:description => "Q版3D海战游戏")
this_game.tag_list = "Q版,3D,海战,即时战斗,道具收费"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)
GameProfession.create(:name => "战士",:game_id => this_game.id)
GameProfession.create(:name => "探险家",:game_id => this_game.id)
GameProfession.create(:name => "贵族",:game_id => this_game.id)
GameProfession.create(:name => "圣使",:game_id => this_game.id)

this_game = Game.create(
				:name => "神兵传奇",
				:official_web => "http://sc.9you.com/web_v4/",
				:sale_date => "2010-8-20",
				:company => "久游网络",
				:agent => "久游网络",
				:description => "3D仙侠角色扮演游戏")
this_game.tag_list = "仙侠,3D,角色扮演,即时战斗,道具收费"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)
GameProfession.create(:name => "破炎",:game_id => this_game.id)
GameProfession.create(:name => "戮风",:game_id => this_game.id)
GameProfession.create(:name => "惊天",:game_id => this_game.id)
GameProfession.create(:name => "裂空",:game_id => this_game.id)
GameProfession.create(:name => "凝云",:game_id => this_game.id)
GameProfession.create(:name => "绝尘",:game_id => this_game.id)

this_game = Game.create(
				:name => "侠道金刚",
				:official_web => "http://ct.9you.com/web_v3/",
				:sale_date => "2010-7-13",
				:company => "久游网络",
				:agent => "久游网络",
				:description => "3D星战角色扮演游戏")
this_game.tag_list = "星战,角色扮演,3D,即时战斗,道具收费"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)
GameProfession.create(:name => "战士",:game_id => this_game.id)
GameProfession.create(:name => "隐匿者",:game_id => this_game.id)
GameProfession.create(:name => "机械师",:game_id => this_game.id)
GameProfession.create(:name => "控能师",:game_id => this_game.id)
GameProfession.create(:name => "守护者",:game_id => this_game.id)
GameProfession.create(:name => "侵蚀者",:game_id => this_game.id)

this_game = Game.create(
				:name => "地下城守护者世界",
				:official_web => "http://dk.91.com/",
				:sale_date => "",
				:company => "网龙网络",
				:agent => "网龙网络",
				:description => "地下城守护者的网络版")
this_game.save

this_game = Game.create(
				:name => "梦幻蜀山",
				:official_web => "http://account.gyyx.cn/signupshushan.aspx",
				:sale_date => "",
				:company => "光宇在线",
				:agent => "光宇在线",
				:description => "2D仙侠回合制角色扮演游戏")
this_game.tag_list = "仙侠,角色扮演,2D,回合制战斗"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)
GameRace.create(:name => "天一",:game_id => this_game.id)
GameRace.create(:name => "影月",:game_id => this_game.id)
GameRace.create(:name => "世炎",:game_id => this_game.id)
GameRace.create(:name => "慕容",:game_id => this_game.id)
GameRace.create(:name => "红云",:game_id => this_game.id)
GameRace.create(:name => "沐雨",:game_id => this_game.id)
GameRace.create(:name => "破空",:game_id => this_game.id)
GameRace.create(:name => "墨灵",:game_id => this_game.id)
GameRace.create(:name => "芊语",:game_id => this_game.id)
GameRace.create(:name => "若星",:game_id => this_game.id)
GameRace.create(:name => "雪枫",:game_id => this_game.id)
GameRace.create(:name => "莫轩",:game_id => this_game.id)
GameProfession.create(:name => "峨嵋派",:game_id => this_game.id)
GameProfession.create(:name => "南海派",:game_id => this_game.id)
GameProfession.create(:name => "北冥派",:game_id => this_game.id)
GameProfession.create(:name => "瑶池派",:game_id => this_game.id)
GameProfession.create(:name => "空灵派",:game_id => this_game.id)

this_game = Game.create(
				:name => "战地ol",
				:official_web => "",
				:sale_date => "",
				:company => "艺电计算机软件",
				:agent => "艺电计算机软件",
				:description => "3D第一人称射击游戏")
this_game.tag_list = "战争,3D,第一人称射击"
this_game.save

this_game = Game.create(
				:name => "开心大陆",
				:official_web => "http://kx.linekong.com/",
				:sale_date => "",
				:company => "蓝港在线",
				:agent => "蓝港在线",
				:description => "3D休闲网游")
this_game.tag_list = "休闲,3D"
this_game.save

this_game = Game.create(
				:name => "佣兵天下",
				:official_web => "http://yb.linekong.com/",
				:sale_date => "",
				:company => "蓝港在线",
				:agent => "蓝港在线",
				:description => "3D奇幻角色扮演游戏")
this_game.tag_list = "奇幻,角色扮演,3D,即时战斗"
this_game.save
GameServer.create( :name => '双线1服', :game_id => this_game.id)
GameServer.create( :name => '双线2服', :game_id => this_game.id)
GameServer.create( :name => '双线3服', :game_id => this_game.id)
GameServer.create( :name => '双线4服', :game_id => this_game.id)
GameRace.create(:name => "艾米帝国",:game_id => this_game.id)
GameRace.create(:name => "修斯帝国",:game_id => this_game.id)
GameRace.create(:name => "神圣教廷",:game_id => this_game.id)
GameProfession.create(:name => "大剑士",:game_id => this_game.id)
GameProfession.create(:name => "魔剑士",:game_id => this_game.id)
GameProfession.create(:name => "法师",:game_id => this_game.id)
GameProfession.create(:name => "牧师",:game_id => this_game.id)
GameProfession.create(:name => "兽人战士",:game_id => this_game.id)
GameProfession.create(:name => "邪魔",:game_id => this_game.id)

this_game = Game.create(
				:name => "东邪西毒",
				:official_web => "http://dxxd.linekong.com/",
				:sale_date => "2010-7-23",
				:company => "蓝港在线",
				:agent => "蓝港在线",
				:description => "3D奇幻角色扮演游戏")
this_game.tag_list = "奇幻,角色扮演,3D,即时战斗"
this_game.save
this_area = GameArea.create( :name => '双线服务区', :game_id => this_game.id)
this_area.servers.create( :name => '斗转星移', :game_id => this_game.id)
this_area.servers.create( :name => '六脉神剑', :game_id => this_game.id)
this_area.servers.create( :name => '铁血丹心', :game_id => this_game.id)
this_area.servers.create( :name => '华山论剑', :game_id => this_game.id)
this_area.servers.create( :name => '九阴真经', :game_id => this_game.id)
this_area.servers.create( :name => '亢龙有悔', :game_id => this_game.id)
this_area.servers.create( :name => '凌波微步', :game_id => this_game.id)
this_area.servers.create( :name => '水月洞天', :game_id => this_game.id)
this_area.servers.create( :name => '万岳朝宗', :game_id => this_game.id)
this_area.servers.create( :name => '紫气东来', :game_id => this_game.id)
this_area.servers.create( :name => '碧海潮生', :game_id => this_game.id)
GameProfession.create(:name => "霜凌",:game_id => this_game.id)
GameProfession.create(:name => "落英",:game_id => this_game.id)
GameProfession.create(:name => "魅影",:game_id => this_game.id)
GameProfession.create(:name => "毒灵",:game_id => this_game.id)
GameProfession.create(:name => "正阳",:game_id => this_game.id)
GameProfession.create(:name => "慈光",:game_id => this_game.id)
GameProfession.create(:name => "降龙",:game_id => this_game.id)
GameProfession.create(:name => "伏虎",:game_id => this_game.id)
GameProfession.create(:name => "玄虚",:game_id => this_game.id)
GameProfession.create(:name => "悟修",:game_id => this_game.id)

this_game = Game.create(
				:name => "倾国倾城",
				:official_web => "http://qg.baiyou100.com/",
				:sale_date => "2010-8-12",
				:company => "百游汇",
				:agent => "百游汇",
				:description => "3D奇幻角色扮演游戏")
this_game.tag_list = "奇幻,角色扮演,3D,即时战斗"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)
GameProfession.create(:name => "战士",:game_id => this_game.id)
GameProfession.create(:name => "法师",:game_id => this_game.id)
GameProfession.create(:name => "祭祀",:game_id => this_game.id)
GameProfession.create(:name => "游侠",:game_id => this_game.id)

this_game = Game.create(
				:name => "真爱西游",
				:official_web => "http://love.yxqz.com/",
				:sale_date => "2010-07-07",
				:company => "百游汇",
				:agent => "百游汇",
				:description => "2D奇幻角色扮演游戏")
this_game.tag_list = "奇幻,角色扮演,2D,即时战斗,道具收费"
this_game.save
this_area = GameArea.create( :name => '电信', :game_id => this_game.id)
this_area.servers.create( :name => '世外桃源', :game_id => this_game.id)
this_area.servers.create( :name => '沐星坡', :game_id => this_game.id)
this_area.servers.create( :name => '无量海', :game_id => this_game.id)
this_area.servers.create( :name => '柳林坡', :game_id => this_game.id)
this_area.servers.create( :name => '良木村', :game_id => this_game.id)
this_area.servers.create( :name => '百里坪', :game_id => this_game.id)
this_area.servers.create( :name => '双叉岭', :game_id => this_game.id)
this_area = GameArea.create( :name => '网通', :game_id => this_game.id)
this_area.servers.create( :name => '天外飞仙', :game_id => this_game.id)
this_area.servers.create( :name => '平乐村', :game_id => this_game.id)
this_area.servers.create( :name => '积雷山', :game_id => this_game.id)
this_area.servers.create( :name => '落迦山', :game_id => this_game.id)
GameRace.create(:name => "人族",:game_id => this_game.id)
GameRace.create(:name => "妖族",:game_id => this_game.id)
GameRace.create(:name => "仙族",:game_id => this_game.id)
GameProfession.create(:name => "地玄守卫",:game_id => this_game.id)
GameProfession.create(:name => "破金战将",:game_id => this_game.id)
GameProfession.create(:name => "雾忍刺客",:game_id => this_game.id)
GameProfession.create(:name => "天火翎侠",:game_id => this_game.id)
GameProfession.create(:name => "紫雷法师",:game_id => this_game.id)
GameProfession.create(:name => "灵蛊道尊",:game_id => this_game.id)

this_game = Game.create(
				:name => "极速轮滑",
				:official_web => "http://sg.cdcgames.net/",
				:sale_date => "",
				:company => "中华网游戏集团",
				:agent => "中华网游戏集团",
				:description => "3D竞速休闲游戏")
this_game.tag_list = "竞速,休闲,3D,道具收费"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","梦幻星球"])
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","东游记"])
this_area = GameArea.create( :name => '电信一', :game_id => this_game.id)
this_area.servers.create( :name => '吕阳洞', :game_id => this_game.id)
this_area.servers.create( :name => '白石寨', :game_id => this_game.id)
this_area.servers.create( :name => '梦幻岛', :game_id => this_game.id)
this_area.servers.create( :name => '龙首崖', :game_id => this_game.id)
this_area.servers.create( :name => '不周山', :game_id => this_game.id)
this_area = GameArea.create( :name => '网通一', :game_id => this_game.id)
this_area.servers.create( :name => '如意奔雷', :game_id => this_game.id)
this_area.servers.create( :name => '云中殿堂', :game_id => this_game.id)
this_area.servers.create( :name => '彩虹之国', :game_id => this_game.id)
this_area.servers.create( :name => '贪狼之剑', :game_id => this_game.id)
this_area = GameArea.create( :name => '电信二', :game_id => this_game.id)
this_area.servers.create( :name => '天火之塔', :game_id => this_game.id)
this_area.servers.create( :name => '天诛流火', :game_id => this_game.id)
this_area.servers.create( :name => '泰山压顶', :game_id => this_game.id)
this_area.servers.create( :name => '女娲补天', :game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","梦回山海"])
this_area = GameArea.create( :name => '电信一区', :game_id => this_game.id)
this_area.servers.create( :name => '天帝山', :game_id => this_game.id)
this_area.servers.create( :name => '太华山', :game_id => this_game.id)
this_area.servers.create( :name => '轩辕国', :game_id => this_game.id)
this_area.servers.create( :name => '琅琊台', :game_id => this_game.id)
this_area.servers.create( :name => '苍梧野', :game_id => this_game.id)
this_area.servers.create( :name => '寒梦泽', :game_id => this_game.id)
this_area.servers.create( :name => '天机岛', :game_id => this_game.id)
this_area.servers.create( :name => '青丘国', :game_id => this_game.id)
this_area.servers.create( :name => '从极渊', :game_id => this_game.id)
this_area = GameArea.create( :name => '网通一区', :game_id => this_game.id)
this_area.servers.create( :name => '夸父追日', :game_id => this_game.id)
this_area.servers.create( :name => '女娲补天', :game_id => this_game.id)
this_area.servers.create( :name => '大禹治水', :game_id => this_game.id)
this_area.servers.create( :name => '盘古开天', :game_id => this_game.id)
this_area.servers.create( :name => '后羿射日', :game_id => this_game.id)

this_game = Game.create(
				:name => "天朝",
				:official_web => "http://tc.zqgame.com/",
				:sale_date => "",
				:company => "中青宝",
				:agent => "中青宝",
				:description => "2D仙侠角色扮演游戏")
this_game.tag_list = "仙侠,角色扮演,即时战斗,2D,道具收费"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)
GameProfession.create(:name => "刺客",:game_id => this_game.id)
GameProfession.create(:name => "御翎",:game_id => this_game.id)
GameProfession.create(:name => "鬼谷",:game_id => this_game.id)
GameProfession.create(:name => "妖姬",:game_id => this_game.id)
GameProfession.create(:name => "擎天",:game_id => this_game.id)

this_game = Game.create(
				:name => "三国斩",
				:official_web => "http://sgz.playzy.com/",
				:sale_date => "2010-05-05",
				:company => "杭州趣玩数码",
				:agent => "杭州趣玩数码",
				:description => "桌游")
this_game.tag_list = "桌游,2D,道具收费"
this_game.save
GameServer.create( :name => '三国斩服务器', :game_id => this_game.id)

this_game = Game.create(
				:name => "天骄3",
				:official_web => "http://www.tj3.com.cn/",
				:sale_date => "",
				:company => "目标软件",
				:agent => "目标软件",
				:description => "3D奇幻角色扮演")
this_game.tag_list = "奇幻,角色扮演,3D"
this_game.save

this_game = Game.find(:first, :conditions => ["name = ?","梦想岛"])
game_area = this_game.areas.find(:first, :conditions => ["name = ?","电信"])
game_area.servers.create(:name => '常绿森林', :game_id => this_game.id)
game_area.servers.create(:name => '幽石山谷', :game_id => this_game.id)
game_area.servers.create(:name => '月光林地', :game_id => this_game.id)
game_area = this_game.areas.find(:first, :conditions => ["name = ?","网通"])
game_area.servers.create(:name => '天空之城', :game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","魔骑士OL"])
game_area = this_game.areas.find(:first, :conditions => ["name = ?","电信"])
game_area.name = "电信一区"
game_area.save
game_area.servers.create(:name => '英雄联盟', :game_id => this_game.id)
game_area.servers.create(:name => '永恒大陆', :game_id => this_game.id)
game_area.servers.create(:name => '暗影幻塔', :game_id => this_game.id)
game_area.servers.create(:name => '火焰之剑', :game_id => this_game.id)
game_area.servers.create(:name => '王者之手', :game_id => this_game.id)
game_area.servers.create(:name => '暴风要塞', :game_id => this_game.id)
game_area.servers.create(:name => '天空之城', :game_id => this_game.id)
game_area.servers.create(:name => '月光战场', :game_id => this_game.id)
game_area.servers.create(:name => '圣堂之巅', :game_id => this_game.id)
game_area.servers.create(:name => '烈风冰境', :game_id => this_game.id)
game_area.servers.create(:name => '星空之门', :game_id => this_game.id)
game_area = this_game.areas.find(:first, :conditions => ["name = ?","网通"])
game_area.name = "网通一区"
game_area.save
game_area.servers.create(:name => '辉煌部落', :game_id => this_game.id)
game_area.servers.create(:name => '冰封雪域', :game_id => this_game.id)
game_area.servers.create(:name => '沧澜神殿', :game_id => this_game.id)
game_area.servers.create(:name => '圣光大道', :game_id => this_game.id)
game_area.servers.create(:name => '龙塔圣地', :game_id => this_game.id)
this_area = GameArea.create( :name => '电信二区', :game_id => this_game.id)
this_area.servers.create( :name => '远星之湖', :game_id => this_game.id)
this_area.servers.create( :name => '风之国度', :game_id => this_game.id)

this_game = Game.create(
				:name => "守护者OL",
				:official_web => "http://shz.iyoyo.com.cn/",
				:sale_date => "",
				:company => "Studio Hon",
				:agent => "悠游网",
				:description => "3D奇幻角色扮演")
this_game.tag_list = "奇幻,角色扮演,3D"
this_game.save

this_game = Game.find(:first, :conditions => ["name = ?","精灵乐章"])
game_area = this_game.areas.find(:first, :conditions => ["name = ?","电信区"])
game_area.servers.create(:name => '圣光彩虹', :game_id => this_game.id)
game_area.servers.create(:name => '茉莉之香', :game_id => this_game.id)
game_area.servers.create(:name => '烟雨之湖', :game_id => this_game.id)
game_area.servers.create(:name => '白银之月', :game_id => this_game.id)
game_area.servers.create(:name => '绿色高玩服', :game_id => this_game.id)
game_area = this_game.areas.find(:first, :conditions => ["name = ?","联通区"])
game_area.servers.create(:name => '缪斯', :game_id => this_game.id)
game_area.servers.create(:name => '萌动花园', :game_id => this_game.id)
game_area.servers.create(:name => '风暴星辰', :game_id => this_game.id)
game_area.servers.create(:name => '辣舞', :game_id => this_game.id)

this_game = Game.create(
				:name => "魔卡英雄",
				:official_web => "http://ch.gfyoyo.com.cn/",
				:sale_date => "",
				:company => "悠游网",
				:agent => "悠游网",
				:description => "奇幻角色扮演")
this_game.tag_list = "奇幻,角色扮演"
this_game.save

this_game = Game.create(
				:name => "洛奇英雄传",
				:official_web => "http://mh.tiancity.com/homepage/v1/?acode=index&bannerName=mh#/home",
				:sale_date => "",
				:company => "NEXON",
				:agent => "世纪天成",
				:description => "3D奇幻角色扮演")
this_game.tag_list = "奇幻,角色扮演,3D"
this_game.save

this_game = Game.create(
				:name => "舞型舞秀",
				:official_web => "http://wx.urgamer.com/",
				:sale_date => "",
				:company => "游佳网络",
				:agent => "游佳网络",
				:description => "3D休闲")
this_game.tag_list = "舞蹈,音乐,休闲,3D"
this_game.save

this_game = Game.create(
				:name => "海之梦",
				:official_web => "http://hzm.moliyo.com/",
				:sale_date => "",
				:company => "摩力游",
				:agent => "摩力游",
				:description => "2.5D奇幻角色扮演")
this_game.tag_list = "奇幻,角色扮演,2.5D"
this_game.save

this_game = Game.create(
				:name => "惊天动地2",
				:official_web => "http://jtdd2.moliyo.com/",
				:sale_date => "",
				:company => "摩力游",
				:agent => "摩力游",
				:description => "3D奇幻角色扮演")
this_game.tag_list = "奇幻,角色扮演,3D"
this_game.save

this_game = Game.find(:first, :conditions => ["name = ?","倩女幽魂"])
game_area = this_game.areas.find(:first, :conditions => ["name = ?","技术封测"])
game_area.servers.create(:name => '苏提春晓(电信接入)', :game_id => this_game.id)
game_area.servers.create(:name => '苏提春晓(网通接入)', :game_id => this_game.id)
game_area.servers.create(:name => '开天辟地', :game_id => this_game.id)
game_area.servers.create(:name => '菩提众生', :game_id => this_game.id)
game_area.servers.create(:name => '诸神之战', :game_id => this_game.id)
game_area.servers.create(:name => '兰若古刹', :game_id => this_game.id)
game_area.servers.create(:name => '沧海桑田', :game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","大唐无双"])
this_area = GameArea.create( :name => '纵横天下区', :game_id => this_game.id)
this_area.servers.create( :name => '君临天下', :game_id => this_game.id)
this_area.servers.create( :name => '风起云涌', :game_id => this_game.id)
this_area.servers.create( :name => '锦绣河山', :game_id => this_game.id)
this_area.servers.create( :name => '笑看风云', :game_id => this_game.id)
this_area.servers.create( :name => '天下无双', :game_id => this_game.id)
this_area.servers.create( :name => '笑傲江湖', :game_id => this_game.id)
this_area = GameArea.create( :name => '东北区', :game_id => this_game.id)
this_area.servers.create( :name => '冰雪长白', :game_id => this_game.id)
this_area.servers.create( :name => '镜泊沉梦（万里冰封）', :game_id => this_game.id)
this_area = GameArea.create( :name => '浙江区', :game_id => this_game.id)
this_area.servers.create( :name => '苏堤春晓', :game_id => this_game.id)
this_area.servers.create( :name => '断桥残雪', :game_id => this_game.id)
this_area.servers.create( :name => '龙腾雁荡', :game_id => this_game.id)
this_area.servers.create( :name => '潮涌钱塘', :game_id => this_game.id)
this_area.servers.create( :name => '天台逸海（月满西楼）', :game_id => this_game.id)
this_area = GameArea.create( :name => '四川区', :game_id => this_game.id)
this_area.servers.create( :name => '青城煮酒', :game_id => this_game.id)
this_area.servers.create( :name => '剑门蜀道', :game_id => this_game.id)
this_area.servers.create( :name => '巴山夜雨', :game_id => this_game.id)
this_area.servers.create( :name => '西岭新雪', :game_id => this_game.id)
this_area = GameArea.create( :name => '湖北湖南区', :game_id => this_game.id)
this_area.servers.create( :name => '白云千载', :game_id => this_game.id)
this_area.servers.create( :name => '纵马江湖', :game_id => this_game.id)
this_area.servers.create( :name => '肝胆相照', :game_id => this_game.id)
this_area = GameArea.create( :name => '山东区', :game_id => this_game.id)
this_area.servers.create( :name => '纵横齐鲁', :game_id => this_game.id)
this_area.servers.create( :name => '浩然沧浪（泰山峙岳）', :game_id => this_game.id)
this_area = GameArea.create( :name => '广东区', :game_id => this_game.id)
this_area.servers.create( :name => '浣剑岭南', :game_id => this_game.id)
this_area.servers.create( :name => '江山如画', :game_id => this_game.id)
this_area.servers.create( :name => '七星望月', :game_id => this_game.id)
this_area.servers.create( :name => '粤海风云', :game_id => this_game.id)
this_area.servers.create( :name => '风雨西关', :game_id => this_game.id)
this_area = GameArea.create( :name => '河南区', :game_id => this_game.id)
this_area.servers.create( :name => '醉歌东都', :game_id => this_game.id)
this_area.servers.create( :name => '逐鹿中原', :game_id => this_game.id)
this_area = GameArea.create( :name => '江苏区', :game_id => this_game.id)
this_area.servers.create( :name => '二分明月', :game_id => this_game.id)
this_area.servers.create( :name => '饮马长江', :game_id => this_game.id)
this_area.servers.create( :name => '虎踞金陵', :game_id => this_game.id)
this_area.servers.create( :name => '秦淮迷影', :game_id => this_game.id)
this_area = GameArea.create( :name => '辽宁区', :game_id => this_game.id)
this_area.servers.create( :name => '千山积翠', :game_id => this_game.id)
this_area.servers.create( :name => '游刃星海', :game_id => this_game.id)
this_area = GameArea.create( :name => '河北区', :game_id => this_game.id)
this_area.servers.create( :name => '长虹吞月（清秋白露）', :game_id => this_game.id)
this_area = GameArea.create( :name => '福建区', :game_id => this_game.id)
this_area.servers.create( :name => '烟雨武夷', :game_id => this_game.id)
this_area.servers.create( :name => '碧海情天', :game_id => this_game.id)
this_area = GameArea.create( :name => '北京区', :game_id => this_game.id)
this_area.servers.create( :name => '枫舞香山', :game_id => this_game.id)
this_area.servers.create( :name => '霜落北平', :game_id => this_game.id)
this_area = GameArea.create( :name => '上海区', :game_id => this_game.id)
this_area.servers.create( :name => '沪上明珠', :game_id => this_game.id)
this_area.servers.create( :name => '天若有情', :game_id => this_game.id)
this_area = GameArea.create( :name => '山西陕西区', :game_id => this_game.id)
this_area.servers.create( :name => '铁马金戈', :game_id => this_game.id)
this_area.servers.create( :name => '万夫莫开', :game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","创世西游"])
game_area = this_game.areas.find(:first, :conditions => ["name = ?","技术封测区"])
game_area.servers.create(:name => '五龙纪', :game_id => this_game.id)
this_area = GameArea.create( :name => '开天辟地区', :game_id => this_game.id)
this_area.servers.create( :name => '序命纪', :game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","易三国OL"])
this_game.areas.first.name = "梦回三国"
this_game.areas.first.save
this_game.areas.first.servers.first.name = "三分天下"
this_game.areas.first.servers.first.save

this_game = Game.create(
				:name => "光之轨迹",
				:official_web => "http://gzgj.21mmo.com/",
				:sale_date => "",
				:company => "深圳网域",
				:agent => "深圳网域",
				:description => "2D奇幻角色扮演")
this_game.tag_list = "奇幻,角色扮演,2D"
this_game.save

this_game = Game.create(
				:name => "聊斋",
				:official_web => "http://lz.798game.com/",
				:sale_date => "",
				:company => "北京德信互动",
				:agent => "北京德信互动",
				:description => "3D神话角色扮演")
this_game.tag_list = "神话,角色扮演,3D"
this_game.save

this_game = Game.create(
				:name => "七剑",
				:official_web => "http://qj.798game.com/",
				:sale_date => "",
				:company => "北京德信互动",
				:agent => "北京德信互动",
				:description => "3D神话角色扮演")
this_game.tag_list = "神话,角色扮演,3D"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)
GameProfession.create(:name => "少林",:game_id => this_game.id)
GameProfession.create(:name => "武当",:game_id => this_game.id)
GameProfession.create(:name => "峨眉",:game_id => this_game.id)
GameProfession.create(:name => "终南",:game_id => this_game.id)
GameProfession.create(:name => "昆仑",:game_id => this_game.id)
GameProfession.create(:name => "百花",:game_id => this_game.id)
GameProfession.create(:name => "蓬莱",:game_id => this_game.id)
GameProfession.create(:name => "华山",:game_id => this_game.id)

this_game = Game.find(:first, :conditions => ["name = ?","天之痕OL"])
game_area = this_game.areas.find(:first, :conditions => ["name = ?","电信一区"])
game_area.servers.create(:name => '盘古开天', :game_id => this_game.id)
game_area.servers.create(:name => '女娲转世', :game_id => this_game.id)
this_area = GameArea.create( :name => '网通一区', :game_id => this_game.id)
this_area.servers.create(:name => '梦回轩辕', :game_id => this_game.id)

this_game = Game.create(
				:name => "天翼决",
				:official_web => "http://www.tianyijue.com/",
				:sale_date => "2010-07-30",
				:company => "盛光天翼科技",
				:agent => "盛光天翼科技",
				:description => "Dota类竞技游戏")
this_game.tag_list = "竞技,Dota,3D"
this_game.save
this_area = GameArea.create( :name => '内测服务区', :game_id => this_game.id)
this_area.servers.create( :name => '内测服务器', :game_id => this_game.id)

this_game = Game.create(
				:name => "蓬莱",
				:official_web => "http://pl.gameyj.com/",
				:sale_date => "2010-7-24",
				:company => "亿佳网络",
				:agent => "亿佳网络",
				:description => "Q版2D角色扮演游戏,即时战斗")
this_game.tag_list = "Q版,角色扮演,2D,即时战斗"
this_game.save
this_area = GameArea.create( :name => '电信封测区', :game_id => this_game.id)
this_area.servers.create( :name => '陈桑洲', :game_id => this_game.id)
this_area = GameArea.create( :name => '网通封测区', :game_id => this_game.id)
this_area.servers.create( :name => '随音谷', :game_id => this_game.id)
GameProfession.create(:name => "大刀",:game_id => this_game.id)
GameProfession.create(:name => "妖狐",:game_id => this_game.id)
GameProfession.create(:name => "天宗",:game_id => this_game.id)
GameProfession.create(:name => "武圣",:game_id => this_game.id)

this_game = Game.create(
				:name => "神魔传",
				:official_web => "http://smz.jooov.cn/",
				:sale_date => "2010-08-02",
				:company => "吉位网",
				:agent => "吉位网",
				:description => "Q版2D角色扮演游戏,即时战斗")
this_game.tag_list = "Q版,角色扮演,2D,即时战斗"
this_game.save
game_id = this_game.id
this_area = GameArea.create( :name => '电信全国一区', :game_id => game_id)
this_area.servers.create( :name => '风云', :game_id => game_id)
this_area.servers.create( :name => '永恒', :game_id => game_id)
this_area.servers.create( :name => '天地', :game_id => game_id)
this_area = GameArea.create( :name => '电信全国二区', :game_id => game_id)
this_area.servers.create( :name => '天下', :game_id => game_id)
this_area.servers.create( :name => '盘古', :game_id => game_id)
this_area.servers.create( :name => '江湖', :game_id => game_id)
this_area = GameArea.create( :name => '电信全国三区', :game_id => game_id)
this_area.servers.create( :name => '雄霸', :game_id => game_id)
this_area.servers.create( :name => '开天', :game_id => game_id)
this_area.servers.create( :name => '苍穹', :game_id => game_id)
this_area = GameArea.create( :name => '网通全国一区', :game_id => game_id)
this_area.servers.create( :name => '天涯', :game_id => game_id)
this_area.servers.create( :name => '藏龙', :game_id => game_id)
this_area.servers.create( :name => '豪情', :game_id => game_id)
this_area.servers.create( :name => '玄天', :game_id => game_id)
this_area.servers.create( :name => '至尊', :game_id => game_id)
GameProfession.create(:name => "狂神",:game_id => this_game.id)
GameProfession.create(:name => "霓裳",:game_id => this_game.id)
GameProfession.create(:name => "魅影",:game_id => this_game.id)
GameProfession.create(:name => "昊苍",:game_id => this_game.id)
GameProfession.create(:name => "坠阳",:game_id => this_game.id)

this_game = Game.create(
				:name => "聊个斋",
				:official_web => "http://lgz.momoou.com/index.html",
				:sale_date => "2010-08-03",
				:company => "摩摩欧",
				:agent => "摩摩欧",
				:description => "Q版3D回合制角色扮演游戏")
this_game.tag_list = "Q版,角色扮演,3D,回合制战斗"
this_game.save
this_area = GameArea.create( :name => '封测区', :game_id => this_game.id)
this_area.servers.create( :name => '封测服', :game_id => this_game.id)
GameProfession.create(:name => "鹿皮翁",:game_id => this_game.id)
GameProfession.create(:name => "阴生",:game_id => this_game.id)
GameProfession.create(:name => "壶公",:game_id => this_game.id)
GameProfession.create(:name => "姑射仙子",:game_id => this_game.id)
GameProfession.create(:name => "王子乔",:game_id => this_game.id)
GameProfession.create(:name => "关羽",:game_id => this_game.id)
GameProfession.create(:name => "墨机",:game_id => this_game.id)
GameProfession.create(:name => "萼绿华",:game_id => this_game.id)
GameProfession.create(:name => "太乙仙",:game_id => this_game.id)

this_game = Game.create(
				:name => "降龙之剑",
				:official_web => "http://xlzj.wanmei.com",
				:sale_date => "2010-08-03",
				:company => "完美时空",
				:agent => "完美时空",
				:description => "2D武侠角色扮演游戏")
this_game.tag_list = "武侠,角色扮演,2D,即时战斗"
this_game.save
this_area = GameArea.create( :name => '封测区', :game_id => this_game.id)
this_area.servers.create( :name => '封测服', :game_id => this_game.id)
GameProfession.create(:name => "虎卫",:game_id => this_game.id)
GameProfession.create(:name => "铁羽",:game_id => this_game.id)
GameProfession.create(:name => "月隐",:game_id => this_game.id)
GameProfession.create(:name => "玄真",:game_id => this_game.id)
GameProfession.create(:name => "灵法",:game_id => this_game.id)
GameProfession.create(:name => "仙道",:game_id => this_game.id)

this_game = Game.create(
				:name => "星空之恋",
				:official_web => "http://cn.beanfun.com/xkzl/",
				:sale_date => "2010-08-09",
				:company => "玩酷科技",
				:agent => "游戏橘子",
				:description => "Q版3D角色扮演游戏")
this_game.tag_list = "Q版,角色扮演,3D,即时战斗"
this_game.save
GameProfession.create(:name => "神殿射手",:game_id => this_game.id)
GameProfession.create(:name => "彗星射手",:game_id => this_game.id)
GameProfession.create(:name => "神殿骑士",:game_id => this_game.id)
GameProfession.create(:name => "烈日骑士",:game_id => this_game.id)
GameProfession.create(:name => "星河使者",:game_id => this_game.id)
GameProfession.create(:name => "月焰使者",:game_id => this_game.id)
GameProfession.create(:name => "太阳谕使",:game_id => this_game.id)
GameProfession.create(:name => "曙光先知",:game_id => this_game.id)

this_game = Game.create(
				:name => "绝对女神II",
				:official_web => "http://ts.920game.com/",
				:sale_date => "2010-08-06",
				:company => "创联",
				:agent => "创联",
				:description => "奇幻3D角色扮演游戏")
this_game.tag_list = "奇幻,角色扮演,3D,即时战斗"
this_game.save
GameProfession.create(:name => "奉献骑士",:game_id => this_game.id)
GameProfession.create(:name => "流浪骑士",:game_id => this_game.id)
GameProfession.create(:name => "慧目神秘弓箭手",:game_id => this_game.id)
GameProfession.create(:name => "流浪神秘弓箭手",:game_id => this_game.id)
GameProfession.create(:name => "变身精灵术士",:game_id => this_game.id)
GameProfession.create(:name => "防御精灵术士",:game_id => this_game.id)
GameProfession.create(:name => "破坏神秘术士",:game_id => this_game.id)
GameProfession.create(:name => "守护神秘术士",:game_id => this_game.id)

this_game = Game.create(
				:name => "幻境传说",
				:official_web => "http://www.lofchina.com/main.php",
				:sale_date => "2010-08-1",
				:company => "上海唯艺",
				:agent => "上海唯艺",
				:description => "奇幻2.5D角色扮演游戏")
this_game.tag_list = "奇幻,角色扮演,2.5D,即时战斗"
this_game.save
this_area = GameArea.create( :name => '封测区', :game_id => this_game.id)
this_area.servers.create( :name => '封测服', :game_id => this_game.id)
GameProfession.create(:name => "贲雷骑士",:game_id => this_game.id)
GameProfession.create(:name => "律剑子",:game_id => this_game.id)
GameProfession.create(:name => "新月刀客",:game_id => this_game.id)
GameProfession.create(:name => "魔导师",:game_id => this_game.id)
GameProfession.create(:name => "慕道子",:game_id => this_game.id)
GameProfession.create(:name => "圣修者",:game_id => this_game.id)

this_game = Game.create(
				:name => "英雄联盟",
				:official_web => "http://lol.qq.com/",
				:sale_date => "2010-08-12",
				:company => "RoitGames",
				:agent => "腾讯",
				:description => "奇幻2.5D角色扮演游戏")
this_game.tag_list = "奇幻,角色扮演,2.5D,即时战斗"
this_game.save

this_game = Game.create(
				:name => "星空传奇",
				:official_web => "http://star.9igame.com/mainbai.html",
				:sale_date => "2010-08-12",
				:company => "纷腾互动",
				:agent => "艺为网络",
				:description => "星战2D回合制角色扮演游戏")
this_game.tag_list = "星战,角色扮演,2D,回合制战斗"
this_game.save
GameRace.create(:name => "科特兰共和国",:game_id => this_game.id)
GameRace.create(:name => "地球联邦",:game_id => this_game.id)
GameRace.create(:name => "帝国同盟",:game_id => this_game.id)
GameProfession.create(:name => "强攻机师",:game_id => this_game.id)
GameProfession.create(:name => "重装机师",:game_id => this_game.id)
GameProfession.create(:name => "主控机师",:game_id => this_game.id)

this_game = Game.create(
				:name => "醉逍遥",
				:official_web => "http://www.zuixiaoyao.com/",
				:sale_date => "2010-08-13",
				:company => "GREENSHORE",
				:agent => "GREENSHORE",
				:description => "神话武侠3D角色扮演游戏")
this_game.tag_list = "神话,武侠,角色扮演,3D,即时战斗"
this_game.save
GameProfession.create(:name => "百花",:game_id => this_game.id)
GameProfession.create(:name => "武尊",:game_id => this_game.id)
GameProfession.create(:name => "峨眉",:game_id => this_game.id)
GameProfession.create(:name => "青城",:game_id => this_game.id)
GameProfession.create(:name => "仙禽",:game_id => this_game.id)
  end

  def self.down
  end
end
