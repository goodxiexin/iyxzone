class AddNewGames < ActiveRecord::Migration
  def self.up
		Game.delete_all("id > 319")
		Gameswithhole.delete_all("sqlid > 319")
	game320 = Game.create(
			:name => "十二天之贰",
			:official_web => "http://12sky2.gfyoyo.com.cn/new/home/index.aspx",
			:sale_date => "2009-4-20",
			:company => "Gigassoft",
			:agent => "悠游网",
              		:no_races=>true,
			:description => "韩国多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 320, :sqlid => game320.id, :gamename => game320.name )
			game320.tag_list = "3D,武侠,中国玄幻"
			game320.save
game321 = Game.create(
			:name => "魔神争霸(天机)",
      			:official_web => "http://ms.ferrygame.com/default.aspx",
      			:sale_date => "2008-10-10",
      			:company => "渡口科技",
      			:agent => "渡口科技",
      			:no_races => true,
      			:description => "3D奇幻角色扮演回合制网游")
Gameswithhole.create( :txtid => 321, :sqlid => game321.id, :gamename => game321.name )
    			game321.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game321.save
game322 = Game.create(
			:name => "通灵王",
			:official_web =>"http://tlw.sdo.com" ,
			:sale_date =>"2008-1-2" ,
			:company =>"悠游数码" ,
			:agent =>"盛大" ,
			:no_races=>true,
			:description => "3D回合制角色扮演游戏")
Gameswithhole.create( :txtid => 322, :sqlid => game322.id, :gamename => game322.name )
			game322.tag_list ="3D,回合制战斗,奇幻,道具收费"
			game322.save

game323 = Game.create(
			:name => "争霸OL（台服）",
			:official_web =>"http://www.zb-game.cn/index.html" ,
			:sale_date =>"2009-06-26" ,
			:company =>"傲天科技" ,
			:agent =>"傲天科技" ,
			:description =>"2D中国特色奇侠风格网游" )
Gameswithhole.create( :txtid => 323, :sqlid => game323.id, :gamename => game323.name )
			game323.tag_list ="中国玄幻,武侠,奇幻,2D,"
			game323.save
game324 = Game.create(
			:name => "童梦OL",
			:official_web => "http://tm.chinagames.net/",
			:sale_date => "2009-7-3",
			:company => "海之童",
			:agent => "中游",
			:no_races => true,
			:description => "国产Q版角色扮演网游")
Gameswithhole.create( :txtid => 324, :sqlid => game324.id, :gamename => game324.name )
			game324.tag_list = "休闲, 3D, 道具收费, 即时战斗, Q版"
			game324.save
game325 = Game.create(
			:name => "华夏免费版",
		      :official_web => "http://www.hxfree.com/hxfree.html",
		      :sale_date => "2004-12-30",
		      :company => "网域",
		      :agent => "网域",
		      :no_races => true,
		      :description => "2D大型角色扮演游戏")
Gameswithhole.create( :txtid => 325, :sqlid => game325.id, :gamename => game325.name )
		    	game325.tag_list = "热血, 奇幻, 角色扮演, 时间收费, 道具收费, 即时战斗, 2D"
			game325.save
game326 = Game.create(
			:name => "钢铁围攻",
			:official_web => "http://tank.fu16.com/",
			:sale_date => "2008-5-5",
			:company =>"非游娱乐" ,
			:agent =>"非游娱乐" ,
			:no_races=>true,
			:description => "国产2D休闲网游")
Gameswithhole.create( :txtid => 326, :sqlid => game326.id, :gamename => game326.name )
			game326.tag_list ="2D,休闲,运动,热血"
			game326.save
game327 = Game.create(
			:name => "仙境传说(台服)",
		      :official_web => "http://ro.sdo.com/home/homepage.htm",
		      :sale_date => "2003-1-1",
		      :company => "GRAVITY",
		      :agent => "盛大",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 327, :sqlid => game327.id, :gamename => game327.name )
    			game327.tag_list = "Q版, 奇幻, 角色扮演, 时间收费, 道具收费, 即时战斗, 2D"
			game327.save
game328 = Game.create(
			:name => "浪漫西游",
			:official_web => "http://xyq.wanku.com/special/fahao/",
			:sale_date => "2010-3-11",
			:company => "火石软件" ,
			:agent => "火石软件" ,
			:description =>"火石软件2010年最新2D回合制网络游戏")
Gameswithhole.create( :txtid => 328, :sqlid => game328.id, :gamename => game328.name )
			game328.tag_list ="回合游戏,2D,Q版, 中国玄幻,休闲"
			game328.save
game329 = Game.create(
			:name => "舞街区",
			:official_web => "http://5jq.szhnet.com/",
			:sale_date => "2008-7-14",
			:company => "游戏蜗牛",
			:agent => "游戏蜗牛",
                        :no_races => true,
                        :no_professions => true,
			:description => "国产休闲音乐舞蹈网游")
Gameswithhole.create( :txtid => 329, :sqlid => game329.id, :gamename => game329.name )
			game329.tag_list = "音乐, 2D,道具收费, 舞蹈, 轻松"
			game329.save
game330 = Game.create(
			:name => "盖娅战记",
			:official_web =>"http://gaiya.17hug.com/" ,
			:sale_date =>"2010-3-9" ,
			:company =>"上海哈克信息科技有限公司" ,
			:agent =>"上海哈克信息科技有限公司" ,
			:no_races=>true,
			:description =>"多人在线角色扮演游戏" )
Gameswithhole.create( :txtid => 330, :sqlid => game330.id, :gamename => game330.name )
			game330.tag_list ="Q版,2D,奇幻"
			game330.save
game331 = Game.create(
			:name => "星座OL",
			:official_web =>"http://www.star65.com/" ,
			:sale_date =>"2010-2-5" ,
			:company =>"雨龙网络" ,
			:agent =>"雨龙网络" ,
			:no_races=>true,
			:description => "以射击为战斗体现的Q版网游")
Gameswithhole.create( :txtid => 331, :sqlid => game331.id, :gamename => game331.name )
			game331.tag_list ="Q版,2D,第一人称射击,奇幻"
			game331.save
game332 = Game.create(
			:name => "封神世界",
			:official_web =>"http://dr.sanle.net/index.asp?nfw=101" ,
			:sale_date =>"2008-6-1" ,
			:company =>"Wizgate" ,
			:agent =>"一起玩" ,
        		:no_races=>true,
			:description =>"多人在线角色扮演游戏" )
Gameswithhole.create( :txtid => 332, :sqlid => game332.id, :gamename => game332.name )
			game332.tag_list ="战争,科幻,道具收费,2D"
			game332.save
game333 = Game.create(
			:name => "诸侯OL海外国际版",
		      :official_web => "http://zh.12ha.com/",
		      :sale_date => "2009-7-3",
		      :company => "金酷",
		      :agent => "金酷",
		      :no_races => true,
		      :description => "3D奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 333, :sqlid => game333.id, :gamename => game333.name )
		    	game333.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game333.save
game334 = Game.create(
			:name => "封神演义OL",
			:official_web => "http://fsyy.cga.com.cn/fc/default.shtml",
			:sale_date => "2010-2-20",
			:company => "福州领域",
			:agent => "浩方在线",
                        :no_races => true,
                        :no_professions => true, 
			:description => "国产神话战场3DRTS即时战略3D休闲竞技网游")
Gameswithhole.create( :txtid => 334, :sqlid => game334.id, :gamename => game334.name )
			game334.tag_list = "战争, 3D, 即时战略, RTS" 
			game334.save
game335 = Game.create(
			:name => "山海志",
			:official_web =>"http://shz.kx1d.com/" ,
			:sale_date =>"2009-4-3" ,
			:company => "上海奥盛",
			:agent => "上海奥盛" ,
			:description => "3D多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 335, :sqlid => game335.id, :gamename => game335.name )
			game335.tag_list ="中国玄幻,3D,奇幻"
			game335.save
game336 = Game.create(
			:name => "战火",
		      :official_web => "http://www.fireol.com/",
		      :sale_date => "2007-11-16",
		      :company => "光联时空",
		      :agent => "游诚时代",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 336, :sqlid => game336.id, :gamename => game336.name )
		    game336.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game336.save
game337 = Game.create(
			:name => "精灵乐章(台服)",
		      :official_web => "http://dj.gfyoyo.com.cn/",
		      :sale_date => "2009-8-13",
		      :company => "亿启数码",
		      :agent => "悠游网",
		      :no_races => true,
		      :description => "Q版3D奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 337, :sqlid => game337.id, :gamename => game337.name )
		    game337.tag_list = "Q版, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game337.save
game338 = Game.create(
			:name => "星际家园II",
			:official_web =>"http://mygame.17173.com/space2/" ,
			:sale_date =>"2008-10-15" ,
			:company =>"西安纷腾互动" ,
			:agent =>"多平台联合运营" ,
			:description => "回合制科幻角色扮演游戏")
Gameswithhole.create( :txtid => 338, :sqlid => game338.id, :gamename => game338.name )
			game338.tag_list ="第一人称射击,道具收费,回合制战斗"
			game338.save
game339 = Game.create(
			:name => "弹头奇兵",
			:official_web =>"http://www.aowonline.com.cn/" ,
			:sale_date =>"2008-5-10" ,
			:company => "游戏橘子",
			:agent =>"神州橘子" ,
              		:no_races=>true,
			:description => "反恐题材的横卷轴射击类休闲网游")
Gameswithhole.create( :txtid => 339, :sqlid => game339.id, :gamename => game339.name )
			game339.tag_list ="第一人称射击,热血,道具收费"
			game339.save
game340 = Game.create(
			:name => "爆爆王(台服)",
			:official_web =>"http://tw.bnb.gamania.com/" ,
			:sale_date =>"2008-5-5" ,
			:company => "游戏橘子",
			:agent =>"游戏橘子公司" ,
              		:no_races=>true,
			:description => "2D Q版在线游戏")
Gameswithhole.create( :txtid => 340, :sqlid => game340.id, :gamename => game340.name )
			game340.tag_list ="道具收费,Q版,休闲"
			game340.save
game341 = Game.create(
			:name => "魔盗OL",
			:official_web => "http://md.sdo.com/",
			:sale_date => "2009-11-19",
			:company =>"厦门联宇" ,
			:agent =>"盛大游戏" ,
       			:no_races=>true,
			:description =>"一款鬼吹灯网游" )
Gameswithhole.create( :txtid => 341, :sqlid => game341.id, :gamename => game341.name )
			game341.tag_list ="奇幻,道具收费"
			game341.save
game342 = Game.create(
			:name => "倩女幽魂",
			:official_web =>"http://qn.163.com/ ",
			:sale_date =>"2009-8-7" ,
			:company =>"网易麾下雷火工作室" ,
			:agent => "网易麾下雷火工作室",
			:description => "大型2.5D固定视角即时制仙侠网游")
Gameswithhole.create( :txtid => 342, :sqlid => game342.id, :gamename => game342.name )
			game342.tag_list ="中国玄幻,2D"
			game342.save
game343 = Game.create(
			:name => "浪漫庄园",
			:official_web => "http://www.leeuu.com/rc/",
			:sale_date =>"2007-8-15" ,
			:company =>"天成胜境" ,
			:agent =>"乐游网" ,
              		:no_races => true,
              		:no_professions => true,
			:description => "一款集娱乐、模拟、养成的大型社区类网游" )
Gameswithhole.create( :txtid => 343, :sqlid => game343.id, :gamename => game343.name )
			game343.tag_list ="养成经营,Q版,休闲,"
			game343.save
game344 = Game.create(
			:name => "海洋骑士团",
			:official_web =>"http://aqu.sdo.com/project/home/index.htm" ,
			:sale_date => "2009-6-5",
			:company => "Actoz Soft",
			:agent => "盛大",
			:no_races => true,
			:description =>"一款水上竞速网游" )
Gameswithhole.create( :txtid => 344, :sqlid => game344.id, :gamename => game344.name )
			game344.tag_list ="Q版,运动,休闲,"
			game344.save
game345 = Game.create(
			:name => "三国群英传2",
			:official_web => "http://sg2.the9.com/main.shtml",
			:sale_date => "2010-4-2",
			:company => "奧汀科技",
			:agent => "第九城市",
			:description => "3D三国类角色扮演游戏")
Gameswithhole.create( :txtid => 345, :sqlid => game345.id, :gamename => game345.name )
			game345.tag_list = "3D, 三国, 角色扮演, 即时战斗"
			game345.save
game346 = Game.create(
			:name => "神话国际中文版",
			:official_web => "http://ryl.mud2u.com/",
			:sale_date =>"2007-9-13" ,
			:company => "NET",
			:agent => "泥巴潭",
			:description => "大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 346, :sqlid => game346.id, :gamename => game346.name )
			game346.tag_list ="3D,道具收费,奇幻"
			game346.save
game347 = Game.create(
			:name => "三国光速版",
			:official_web =>"http://sg.gfyoyo.com.cn/gs/" ,
			:sale_date =>"2006-9-15" ,
			:company =>"奧汀科技" ,
			:agent =>"悠游网" ,
              		:no_races => true,
			:description => "一款三国题材的横向卷轴网络游戏")
Gameswithhole.create( :txtid => 347, :sqlid => game347.id, :gamename => game347.name )
			game347.tag_list ="即时战斗"
			game347.save
game348 = Game.create(
			:name => "QQ西游",
			:official_web =>"http://qqxy.qq.com/" ,
			:sale_date => "2010-1-28",
			:company => "腾讯",
			:agent =>"腾讯", 
              		:no_races => true,
			:description => "一款3D Q版大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 348, :sqlid => game348.id, :gamename => game348.name )
			game348.tag_list ="3D,Q版,中国奇幻"
			game348.save
game349 = Game.create(
			:name => "峥嵘天下",
			:official_web =>"http://zr.5hma.com/" ,
			:sale_date => "2008-10-31",
			:company =>"五花马网络" ,
			:agent =>"五花马网络" ,
 			:no_races => true,
			:description =>"一款3D大型多人在线角色扮演游戏" )
Gameswithhole.create( :txtid => 349, :sqlid => game349.id, :gamename => game349.name )
			game349.tag_list ="玄幻,道具收费,即时战斗,养成经营"
			game349.save
game352 = Game.create(
			:name => "龙的传人",
			:official_web =>"http://ldcr.12ha.com/" ,
			:sale_date =>"2010-1-15" ,
			:company =>"速龙科技" ,
			:agent =>"金酷" ,
			:description =>"一款3D多人在线角色扮演游戏" )
Gameswithhole.create( :txtid => 352, :sqlid => game352.id, :gamename => game352.name )
			game352.tag_list ="3D,中国玄幻"
			game352.save
game355 = Game.create(
			:name => "征途怀旧版",
			:official_web =>"http://zthj.ztgame.com/" ,
			:sale_date =>"2009-4-14" ,
			:company =>"巨人网络" ,
			:agent =>"巨人网络"  ,
               		:no_races=>true,
			:description => "3D大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 355, :sqlid => game355.id, :gamename => game355.name )
			game355.tag_list ="3D,中国玄幻,道具收费"
			game355.save
game356 = Game.create(
			:name => "仙剑神曲",
			:official_web => "http://xjsq.xunlei.com/",
			:sale_date =>"2009-4-1" ,
			:company =>"御风行数码科技" ,
			:agent =>"御风行数码科技" ,
			:no_races=>true,
			:description => "一款3D大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 356, :sqlid => game356.id, :gamename => game356.name )
			game356.tag_list ="3D,中国玄幻,道具收费,"
			game356.save
game357 = Game.create(
			:name => "DECO光黑世界",
			:official_web =>"http://www.17deco.com/" ,
			:sale_date =>"2009-9-7" ,
			:company =>"搜搜游" ,
			:agent =>"搜搜游" ,
			:description =>"中国第一款以半动画风格展现的3D MMORPG最纯粹的战争网游" )
Gameswithhole.create( :txtid => 357, :sqlid => game357.id, :gamename => game357.name )
			game357.tag_list ="3D,战争,Q版,休闲"
			game357.save
game358 = Game.create(
			:name => "天元",
			:official_web =>"http://ty.91.com/" ,
			:sale_date =>"2009-12-23" ,
			:company => "网龙公司",
			:agent =>"网龙公司" ,
			:no_races=>true,
			:description => "一款2D玄幻网络游戏")
Gameswithhole.create( :txtid => 358, :sqlid => game358.id, :gamename => game358.name )
			game358.tag_list ="中国玄幻,2D"
			game358.save
game359 = Game.create(
			:name => "盛大魔界",
		      :official_web => "http://www.mwo.cn/",
		      :sale_date => "2007-11-28",
		      :company => "金酷游戏",
		      :agent => "盛大网络",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 359, :sqlid => game359.id, :gamename => game359.name )
		    game359.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game359.save
game360 = Game.create(
			:name => "幻想世界",
			:official_web =>"http://www.fmonline.net/" ,
			:sale_date =>"2008-9-3" ,
			:company =>"唯晶信息" ,
			:agent =>"九城" ,
			:description =>"一款卡通风格的全3D网游" )
Gameswithhole.create( :txtid => 360, :sqlid => game360.id, :gamename => game360.name )
			game360.tag_list ="3D,Q版,回合制"
			game360.save
game361 = Game.create(
			:name => "传奇3",
			:official_web => "http://mir3.gtgame.com.cn/index.html",
			:sale_date => "2003-5-25",
			:company => "Wemade",
			:agent => "光通",
			:no_races => true,
			:description => "3D 大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 361, :sqlid => game361.id, :gamename => game361.name )
			game361.tag_list ="3D,奇幻,热血"
			game361.save
game362 = Game.create(
			:name => "创世OL",
			:official_web =>"http://cs.gyyx.cn/index_csv2.aspx" ,
			:sale_date => "2009-9-28",
			:company => "光宇在线",
			:agent =>"光宇在线" ,
			:no_races=>true,
			:description =>"一款以上古洪荒为背景的大型3D多人在线角色扮演游戏" )
Gameswithhole.create( :txtid => 362, :sqlid => game362.id, :gamename => game362.name )
			game362.tag_list ="3D ,中国玄幻,道具收费,"
			game362.save
game363 = Game.create(
			:name => "真·女神转生",
			:official_web =>"http://zns.playsea.com/superindex/op.html" ,
			:sale_date => "2009-12-21",
			:company =>"CAVE" ,
			:agent =>"宁波成功" ,
			:description => "一款大型3D多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 363, :sqlid => game363.id, :gamename => game363.name )
			game363.tag_list ="即时战斗,3D,奇幻"
			game363.save
game364 = Game.create(
			:name => "征战",
		      :official_web => "http://zz.lyjoy.com/",
		      :sale_date => "2008-5-13",
		      :company => "风云工作室",
		      :agent => "龙游天下",
		      :description => "3D三国类奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 364, :sqlid => game364.id, :gamename => game364.name )
		    game364.tag_list = "热血, 奇幻, 角色扮演, 三国, 道具收费, 即时战斗, 3D"
			game364.save
game368 = Game.create(
			:name => "新倚天剑与屠龙刀",
			:official_web => "http://yt.linekong.com/",
			:sale_date => "2008-11-27",
			:company => "蓝港在线",
			:agent =>"蓝港在线" ,
			:no_races =>true,
			:description =>"首款将回合制模式与武侠风格融合的网游大作" )
Gameswithhole.create( :txtid => 368, :sqlid => game368.id, :gamename => game368.name )
			game368.tag_list ="奇幻,中国奇幻, 回合制"
			game368.save
game370 = Game.create(
			:name => "QQ仙境",
			:official_web => "http://xj.qq.com/",
			:sale_date =>"2009-7-14" ,
			:company =>"Nextplay" ,
			:agent =>"腾讯" ,
			:no_races =>true,
			:description =>"Q版横版动作网游")
Gameswithhole.create( :txtid => 370, :sqlid => game370.id, :gamename => game370.name )
			game370.tag_list ="Q版,2D"
			game370.save
game371 = Game.create(
			:name => "预言OL(IS版)",
		      :official_web => "http://www.yuyan.com/",
		      :sale_date => "2008-4-29",
		      :company => "暴雨信息",
		      :agent => "暴雨信息",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 371, :sqlid => game371.id, :gamename => game371.name )
		      game371.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game371.save
game372 = Game.create(
			:name => "创世西游",
			:official_web => "http://csxy.163.com/index.html",
			:sale_date =>"2009-4-3" ,
			:company => "网易",
			:agent => "网易" ,
			:no_races =>true,
			:description =>"一款大型3D回合制东方神幻网游" )
Gameswithhole.create( :txtid => 372, :sqlid => game372.id, :gamename => game372.name )
			game372.tag_list ="3D,回合制,奇幻,中国奇幻"
			game372.save
game373 = Game.create(
			:name => "QQ自由幻想",
			:official_web => "http://ffo.qq.com/index.shtml",
			:sale_date =>"2007-9-11" ,
			:company =>"腾讯公司" ,
			:agent =>"腾讯公司" ,
			:no_races =>true,
			:description => "大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 373, :sqlid => game373.id, :gamename => game373.name )
			game373.tag_list ="2D,道具收费,奇幻,中国奇幻"
			game373.save
game375 = Game.create(
			:name => "水浒Q传2",
			:official_web =>"http://sh2.wanku.com/" ,
			:sale_date => "2009-3-12",
			:company =>"火石软件" ,
			:agent =>"火石软件" ,
			:description =>"3D在线游戏" )
Gameswithhole.create( :txtid => 375, :sqlid => game375.id, :gamename => game375.name )
			game375.tag_list ="3D,Q版,中国奇幻,回合制"
			game375.save
game376 = Game.create(
			:name => "QQ华夏",
			:official_web =>"http://qqhx.qq.com/main.html" ,
			:sale_date =>"2007-5-10" ,
			:company => "腾讯公司",
			:agent =>"腾讯公司" ,
			:no_races => true,
			:description => "角色扮演游戏")
Gameswithhole.create( :txtid => 376, :sqlid => game376.id, :gamename => game376.name )
			game376.tag_list ="奇幻,中国奇幻,2.5D"
			game376.save
game378 = Game.create(
			:name => "新卓越之剑",
			:official_web =>"http://ge.the9.com/" ,
			:sale_date => "2008-11-13",
			:company =>"IMC" ,
			:agent =>"第九城市" ,
			:no_races => true,
			:description =>"3DMMORPG, 即时战斗" )
Gameswithhole.create( :txtid => 378, :sqlid => game378.id, :gamename => game378.name )
			game378.tag_list ="3D,即时战斗,战斗收费"
			game378.save
game379 = Game.create(
			:name => "神魔大陆",
			:official_web => "http://shenmo.wanmei.com/",
			:sale_date => "2010-3-25",
			:company => "完美时空",
			:agent => "完美时空",
			:description => "奇幻大型3D角色扮演游戏")
Gameswithhole.create( :txtid => 379, :sqlid => game379.id, :gamename => game379.name )
			game379.tag_list = "奇幻, 3D, 即时战斗, 史诗"
			game379.save
game380 = Game.create(
			:name => "神话风云",
			:official_web => "http://sh.wushen.com/",
			:sale_date => "2010-3-12",
			:company => "武神世纪",
			:agent => "武神世纪",
			:no_races => true,
			:description => "中国大型3D角色扮演游戏")
Gameswithhole.create( :txtid => 380, :sqlid => game380.id, :gamename => game380.name )
			game380.tag_list = "奇幻, 3D, 即时战斗, 史诗"
			game380.save
game381 = Game.create(
			:name => "剑侠情缘(台服)",
		      :official_web => "http://jx.xoyo.com/index1/index.shtml",
		      :sale_date => "2003-9-23",
		      :company => "金山西山居",
		      :agent => "金山西山居",
		      :no_races => true,
		      :description => "国产2D角色扮演游戏")
Gameswithhole.create( :txtid => 381, :sqlid => game381.id, :gamename => game381.name )
		      game381.tag_list = "热血, 武侠, 角色扮演, 时间收费, 即时战斗, 2D"
			game381.save
game382 = Game.create(
			:name => "格斗10",
			:official_web => "http://gd.wulitou.com/index.html",
			:sale_date => "2009-5-14",
			:company => "朝鸿网络",
			:agent => "百海互娱",
			:no_races => true,
			:description => "横版格斗类网络游戏")
Gameswithhole.create( :txtid => 382, :sqlid => game382.id, :gamename => game382.name )
			game382.tag_list = "Q版, 横板战斗, 格斗, 2D, 道具收费"
			game382.save
game383 = Game.create(
			:name => "十二封印",
			:official_web => "http://www.12fy.com/",
			:sale_date => "2009-11-13",
			:company => "华夏飞讯",
			:agent => "华夏飞讯",
			:no_races => true,
			:description => "国产大型3D角色扮演游戏")
Gameswithhole.create( :txtid => 383, :sqlid => game383.id, :gamename => game383.name )
			game383.tag_list = "奇幻, 3D, 即时战斗, 热血, 道具收费"
			game383.save
game384 = Game.create(
			:name => "无双勇气",
			:official_web => "http://wsyq.169.net/",
			:sale_date => "2009-11-15",
			:company => "HeySpace",
			:agent => "HeySpace",
			:no_races => true,
			:description => "国产2.5ARPG网游")
Gameswithhole.create( :txtid => 384, :sqlid => game384.id, :gamename => game384.name )
			game384.tag_list = "奇幻, 2D, 即时战斗, 热血, 道具收费"
			game384.save
game385 = Game.create(
			:name => "吞食天地2",
			:official_web => "http://ts2.sdo.com/index.html",
			:sale_date => "2009-6-20",
			:company => "中华网龙",
			:agent => "盛大网络",
			:no_races => true,
			:description => "Q版回合制角色扮演游戏")
Gameswithhole.create( :txtid => 385, :sqlid => game385.id, :gamename => game385.name )
			game385.tag_list = "2D, 回合制战斗, Q版, 道具收费, 中国玄幻"
			game385.save
game386 = Game.create(
			:name => "墨香(台服)",
		      :official_web => "http://ms.runup.cn/top.php",
		      :sale_date => "2008-11-20",
		      :company => "EYA(韩国)",
		      :agent => "千峰云起",
		      :no_races => true,
		      :no_professions => true,
		      :description => "2D武侠, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 386, :sqlid => game386.id, :gamename => game386.name )
		    game386.tag_list = "热血, 武侠, 角色扮演, 道具收费, 即时战斗, 2D"
			game386.save
game387 = Game.create(
			:name => "天骄II",
		      :official_web => "http://tjpk.object.com.cn/",
		      :sale_date => "2007-5-23",
		      :company => "目标在线",
		      :agent => "目标在线",
		      :no_races => true,
		      :description => "2D奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 387, :sqlid => game387.id, :gamename => game387.name )
		    game387.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game387.save
game388 = Game.create(
			:name => "大秦天下",
			:official_web => "http://dq.daqinsoft.com/",
			:sale_date => "2010-5-1",
			:company => "大秦信息",
			:agent => "大秦信息",
			:no_races => true,
			:description => "民族2D角色扮演网游")
Gameswithhole.create( :txtid => 388, :sqlid => game388.id, :gamename => game388.name )
			game388.tag_list = "2D, 即时战斗, 热血, 道具收费, 武侠"
			game388.save
game389 = Game.create(
			:name => "新仙界传",
			:official_web => "http://www.xjz2.com.cn/index.aspx",
			:sale_date => "2009-10-20",
			:company => "宏象网络",
			:agent => "宏象网络",
			:no_races => true,
			:description => "中国玄幻2D角色扮演网游")
Gameswithhole.create( :txtid => 389, :sqlid => game389.id, :gamename => game389.name )
			game389.tag_list = "2D, 回合制战斗, Q版, 道具收费, 中国玄幻"
			game389.save
game390 = Game.create(
			:name => "倚天2外传",
			:official_web => "http://yt2w.catv.net/",
			:sale_date => "2009-12-15",
			:company => "韩国YMIR公司",
			:agent => "中广网",
			:no_races => true,
			:description => "韩国3D角色扮演网游")
Gameswithhole.create( :txtid => 390, :sqlid => game390.id, :gamename => game390.name )
			game390.tag_list = "3D, 即时战斗, 热血, 道具收费, 玄幻"
			game390.save
game392 = Game.create(
			:name => "武林群侠传(台服)",
		      :official_web => "http://50.catv.net/",
		      :sale_date => "2009-7-11",
		      :company => "中华网龙",
		      :agent => "中广网",
		      :no_races => true,
		      :description => "大型3D角色扮演游戏")
Gameswithhole.create( :txtid => 392, :sqlid => game392.id, :gamename => game392.name )
		      game392.tag_list = "史诗, 武侠, 角色扮演, 道具收费, 即时战斗, 3D"
			game392.save
game393 = Game.create(
			:name => "极限街区",
			:official_web => "http://run.moliyo.com/",
			:sale_date => "2008-12.22",
			:company => "摩力游",
			:agent => "摩力游",
			:no_races => true,
			:description => "极限运动的角色扮演游戏")
Gameswithhole.create( :txtid => 393, :sqlid => game393.id, :gamename => game393.name )
			game393.tag_list = "极限运动, 体育, 轻松, 道具收费, 3D"
			game393.save
game394 = Game.create(
			:name => "天尊(台服)",
			:official_web => "http://www.ooxxplay.com/index.html",
			:sale_date => "2009-1-1",
			:company => "唐颂信息",
			:agent => "悠扬网络",
			:no_races => true,
			:no_professions => true,
			:description => "国产3D角色扮演游戏")
Gameswithhole.create( :txtid => 394, :sqlid => game394.id, :gamename => game394.name )
			game394.tag_list = "3D, 热血, 道具收费, 奇幻, 即时战斗"
			game394.save
game395 = Game.create(
			:name => "天堂(台服)",
		      :official_web => "http://www.lineage.com.cn/page=default",
		      :sale_date => "2003-1-8",
		      :company => "NCSoft",
		      :agent => "新浪乐谷",
		      :description => "2D奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 395, :sqlid => game395.id, :gamename => game395.name )
		      game395.tag_list = "热血, 奇幻, 角色扮演, 时间收费, 即时战斗, 2D"
			game395.save
game396 = Game.create(
			:name => "空战世纪",
			:official_web => "http://kz.d5online.com/",
			:sale_date => "2009-12-23",
			:company => "JC娱乐",
			:agent => "五海信息",
			:no_races => true,
			:no_professions => true,
			:description => "3D休闲飞行射击游戏")
Gameswithhole.create( :txtid => 396, :sqlid => game396.id, :gamename => game396.name )
			game396.tag_list ="3D, 射击, 飞行, 仿真, 道具收费"
			game396.save
game397 = Game.create(
			:name => "铁血迷情OL",
			:official_web => "http://www.dk2.com.cn/",
			:sale_date => "2006-11-1",
			:company => "韩国metro tech",
			:agent => "天图科技",
			:no_races => true,
			:description => "韩国3D角色扮演游戏")
Gameswithhole.create( :txtid => 397, :sqlid => game397.id, :gamename => game397.name )
			game397.tag_list = "3D, 热血, 道具收费, 奇幻, 即时战斗"
			game397.save
game398 = Game.create(
			:name => "流星蝴蝶剑",
			:official_web => "http://lx.9you.com/",
			:sale_date => "2010-3-20",
			:company => "久游",
			:agent => "久游",
			:no_races => true,
			:no_professions => true,
			:description => "3D动作武侠角色扮演游戏")
Gameswithhole.create( :txtid => 398, :sqlid => game398.id, :gamename => game398.name )
			game398.tag_list = "3D, 动作, 武侠, 热血, 即时战斗"
			game398.save
game399 = Game.create(
			:name => "天之翼",
			:official_web => "http://tzyol.7uif.com/web/index.html",
			:sale_date => "2009-4-23",
			:company => "奇人快游网络",
			:agent => "奇人快游网络",
			:no_races => true,
			:description => "3D回合飞行角色扮演游戏")
Gameswithhole.create( :txtid => 399, :sqlid => game399.id, :gamename => game399.name )
			game399.tag_list = "3D, 飞行, 回合制战斗, 热血"
			game399.save
game400 = Game.create(
			:name => "炫舞吧",
			:official_web => "http://58.gyyx.cn/Index_HotDance.aspx",
			:sale_date => "2009-9-29",
			:company => "光宇华夏",
			:agent => "光宇华夏",
			:no_races => true,
			:no_professions => true,
			:description => "休闲舞蹈类游戏")
Gameswithhole.create( :txtid => 400, :sqlid => game400.id, :gamename => game400.name )
			game400.tag_list = "3D, 休闲, 舞蹈, 轻松, 道具收费"
			game400.save
game401 = Game.create(
			:name => "边锋茶苑游戏专区",
			:official_web => "http://www.gameabc.com",
			:sale_date => "2001-1-1",
			:company => "边锋游戏",
			:agent => "边锋游戏",
			:description => "边锋游戏专区")
Gameswithhole.create( :txtid => 401, :sqlid => game401.id, :gamename => game401.name )
			game401.tag_list = "游戏平台, 休闲"
			game401.save
game402 = Game.create(
			:name => "超能英雄",
			:official_web => "http://rs.wanku.com/index.html",
			:sale_date => "2009-7-15",
			:company => "火石",
			:agent => "火石",
			:no_races => true,
			:description => "Q版pk游戏")
Gameswithhole.create( :txtid => 402, :sqlid => game402.id, :gamename => game402.name )
			game402.tag_list = "Q版, PK, 3D, 回合制战斗, 道具收费"
			game402.save
game403 = Game.create(
			:name => "飙车世界",
			:official_web => "http://rw.joyzone.com.cn/",
			:sale_date => "2009-9-15",
			:company => "天纵网络",
			:no_races => true,
			:no_professions => true,
			:agent => "天纵网络",
			:description => "仿真赛车网游")
Gameswithhole.create( :txtid => 403, :sqlid => game403.id, :gamename => game403.name )
			game403.tag_list = "仿真, 赛车, 休闲, 竞技, 道具收费, 3D"
			game403.save
game406 = Game.create(
			:name => "乱(台服)",
			:official_web => "http://www.ran.com.tw/",
			:sale_date => "2009-1-1",
			:company => "MIN COMMUNICATION",
			:agent => "雷穹科技",
			:no_races => true,
			:description => "3D青春热血角色扮演网游")
Gameswithhole.create( :txtid => 406, :sqlid => game406.id, :gamename => game406.name )
			game406.tag_list = "3D, 青春, 热血, 即时战斗"
			game406.save
game408 = Game.create(
			:name => "圣传OL",
			:official_web => "http://www.hyszol.com/",
			:sale_date => "2009-4-30",
			:company => "欢跃数码",
			:agent => "欢跃数码",
			:no_races => true,
			:description => "3D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 408, :sqlid => game408.id, :gamename => game408.name )
			game408.tag_list = "3D, 奇幻, 即时战斗, 道具收费, 热血"
			game408.save
game409 = Game.create(
			:name => "勇OL(台服)",
			:official_web => "http://www.yong-online.com.tw/",
			:sale_date => "2007-10-29",
			:company => "Min Communications",
			:agent => "Min Communications",
			:description => "3D学院风格动作RPG")
Gameswithhole.create( :txtid => 409, :sqlid => game409.id, :gamename => game409.name )
			game409.tag_list = "3D, 学院, 即时战斗, 热血"
			game409.save
game410 = Game.create(
			:name => "真·女神转生(台)",
			:official_web => "http://zns.playsea.com/index.shtml",
			:sale_date => "2009-12-21",
			:company =>"CAVE" ,
			:agent =>"宁波成功" ,
			:description => "一款大型3D多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 410, :sqlid => game410.id, :gamename => game410.name )
			game410.tag_list ="即时战斗,3D,奇幻"
			game410.save
game411 = Game.create(
			:name => "新浪游戏专区",
			:official_web => "http://games.sina.com.cn/",
			:sale_date => "2002-2-22",
			:company => "新浪",
			:agent => "新浪",
			:no_races => true,
			:no_professions => true,
			:description => "新浪游戏")
Gameswithhole.create( :txtid => 411, :sqlid => game411.id, :gamename => game411.name )
			game411.tag_list = "游戏平台"
			game411.save
game412 = Game.create(
			:name => "武林外传(台服)",
			:official_web => "http://wulin.gameflier.com/",
			:sale_date => "2008-10-25",
			:company => "完美时空",
			:agent => "游戏新干线",
			:no_races => true,
		      	:description => "Q版3D神话角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 412, :sqlid => game412.id, :gamename => game412.name )
game412.tag_list = "Q版, 神话, 角色扮演, 道具收费, 即时战斗, 3D"
			game412.save
game413 = Game.create(
			:name => "情天OL",
			:official_web => "http://www.playqt.com/",
			:sale_date => "2009-7-1",
			:company => "兴正鹤图",
			:agent => "网元网",
			:no_races => true,
			:description => "3D锁视角Q版回合制网络游戏")
Gameswithhole.create( :txtid => 413, :sqlid => game413.id, :gamename => game413.name )
			game413.tag_list = "3D, Q版, 回合制战斗, 道具收费, 奇幻"
			game413.save
game414 = Game.create(
			:name => "QQ游戏平台",
			:official_web => "http://games.qq.com/esports/qqbattle/",
			:sale_date => "2007-1-1",
			:company => "腾讯",
			:agent => "腾讯",
			:description => "QQ游戏平台")
Gameswithhole.create( :txtid => 414, :sqlid => game414.id, :gamename => game414.name )
			game414.tag_list = "游戏平台, QQ"
			game414.save
game415 = Game.create(
			:name => "征途2",
			:official_web => "http://zt2.ztgame.com/",
			:sale_date => "2010-6-1",
			:company => "巨人网络",
			:agent => "巨人网络",
			:no_races => true,
			:no_professions => true,
			:description => "国产大型角色扮演网游")
Gameswithhole.create( :txtid => 415, :sqlid => game415.id, :gamename => game415.name )
			game415.tag_list = "3D, 热血, 征途, 即时战斗"
			game415.save
game416 = Game.create(
			:name => "争霸天下",
			:official_web => "http://zb.gyyx.cn/index_zb.htm",
			:sale_date => "2007-9-27",
			:company => "傲天科技",
			:agent => "光宇在线",
			:no_races => true,
			:description => "国产2D角色扮演游戏")
Gameswithhole.create( :txtid => 416, :sqlid => game416.id, :gamename => game416.name )
			game416.tag_list = "2D, 热血, 道具收费, 即时战斗, 中国玄幻"
			game416.save
game417 = Game.create(
			:name => "战神",
			:official_web => "http://www.zhanshengame.com/",
			:sale_date => "2008-12-20",
			:company => "普瑞通网络科技",
			:agent => "中青宝网",
			:no_races => true,
			:description => "大型2D角色扮演网游")
Gameswithhole.create( :txtid => 417, :sqlid => game417.id, :gamename => game417.name )
			game417.tag_list = "2D, 热血, 道具收费, 即时战斗, 神话"
			game417.save
game418 = Game.create(
			:name => "中华英雄",
			:official_web => "http://zhyx.changyou.com/",
			:sale_date => "2010-4-22",
			:company => "搜狐畅游",
			:agent => "搜狐畅游",
			:no_races => true,
			:description => "3D武侠角色扮演游戏")
Gameswithhole.create( :txtid => 418, :sqlid => game418.id, :gamename => game418.name )
			game418.tag_list = "3D, 武侠, 角色扮演, 即时战斗, 道具收费"
			game418.save
game419 = Game.create(
			:name => "仙侣奇缘3",
			:official_web => "http://www.xlqy.net/index.html",
			:sale_date => "2008-5-15",
			:company => "巅峰软件",
			:agent => "巅峰软件",
			:no_races => true,
			:description => "国产2D角色扮演网游")
Gameswithhole.create( :txtid => 419, :sqlid => game419.id, :gamename => game419.name )
			game419.tag_list = "2D, 热血, 道具收费, 奇幻, 即时战斗"
			game419.save
game420 = Game.create(
			:name => "热血江湖(台服)",
			:official_web => "http://www.wayi.com.tw/hot/",
		      :sale_date => "2005-4-20",
		      :company => "Mgame&KRGsoft",
		      :agent => "一起玩游戏网",
		      :no_races => true,
		      :description => "3D卡通武侠, 角色扮演")
Gameswithhole.create( :txtid => 420, :sqlid => game420.id, :gamename => game420.name )
		      game420.tag_list = "Q版, 武侠, 角色扮演, 道具收费, 即时战斗, 3D"
			game420.save
game423 = Game.create(
			:name => "大话西游2",
			:official_web => "http://xy2.163.com/",
			:sale_date => "2007-8-15",
			:company => "网易",
			:agent => "网易",
		      :description => "国产2D休闲角色扮演游戏")
Gameswithhole.create( :txtid => 423, :sqlid => game423.id, :gamename => game423.name )
		      game423.tag_list = "Q版, 神话, 角色扮演, 时间收费, 回合制战斗, 2D"
			game423.save
game424 = Game.create(
			:name => "霸业OL",
			:official_web => "http://by.365jishi.com/index.do",
			:sale_date => "2009-10-20",
			:company => "劭文数码科技",
			:agent => "劭文数码科技",
			:no_races => true,
			:description => "国产3D大型网络游戏")
Gameswithhole.create( :txtid => 424, :sqlid => game424.id, :gamename => game424.name )
			game424.tag_list = "3D, 热血, 奇幻, 道具收费, 即时战斗"
			game424.save
game425 = Game.create(
			:name => "热舞派对百度版",
			:official_web => "http://rwpd.wanmei.com/",
			:sale_date => "2005-1-1",
			:company => "完美时空",
			:agent => "完美时空",
			:no_races => true,
			:no_professions => true,
			:description => "音乐舞蹈休闲类游戏")
Gameswithhole.create( :txtid => 425, :sqlid => game425.id, :gamename => game425.name )
			game425.tag_list = "音乐, 舞蹈, 休闲, 道具收费"
			game425.save
game426 = Game.create(
			:name => "乱武江山OL",
			:official_web => "http://td.bao3.com/",
			:sale_date => "2009-8-6",
			:company => "宝3网络",
			:agent => "宝3网络",
			:no_races => true,
			:description => "国产2D玄幻角色扮演网游")
Gameswithhole.create( :txtid => 426, :sqlid => game426.id, :gamename => game426.name )
			game426.tag_list = "2D, 中国玄幻, 热血, 道具收费, 即时战斗"
			game426.save
game427 = Game.create(
			:name => "QQ炫舞",
			:official_web => "http://x5.qq.com/",
			:sale_date => "2008-3-10",
			:company => "永航科技",
			:agent => "腾迅",
			:no_races => true,
			:no_professions => true,
			:description => "舞蹈类休闲游戏")
Gameswithhole.create( :txtid => 427, :sqlid => game427.id, :gamename => game427.name )
			game427.tag_list = "休闲, 舞蹈, 道具收费, 3D, 音乐"
			game427.save
game430 = Game.create(
			:name => "边缘",
			:official_web => "http://www.92fly.com/",
			:sale_date => "2007-10-12",
			:company => "飞越梦幻科技",
			:agent => "飞越梦幻科技",
			:no_races => true,
			:description => "国产3D角色扮演游戏")
Gameswithhole.create( :txtid => 430, :sqlid => game430.id, :gamename => game430.name )
			game430.tag_list = "3D, 奇幻, 热血, 即时战斗, 道具收费"
			game430.save
game431 = Game.create(
			:name => "秦殇世界",
			:official_web => "http://qssj.object.com.cn/",
			:sale_date => "2008-8-31",
			:company => "目标软件",
			:agent => "目标软件",
			:no_races => true,
			:description => "2D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 431, :sqlid => game431.id, :gamename => game431.name )
			game431.tag_list = "2D, 奇幻, 角色扮演, 即时战斗"
			game431.save
game432 = Game.create(
			:name => "昆仑OL",
			:official_web => "http://kl.zy528.com/",
			:sale_date => "2010-3-18",
			:company => "智艺网络",
			:agent => "智艺网络",
			:description => "国产神话2D角色扮演网游")
Gameswithhole.create( :txtid => 432, :sqlid => game432.id, :gamename => game432.name )
			game432.tag_list = "热血, 神话, 2D, 道具收费, 即时战斗"
			game432.save
game433 = Game.create(
			:name => "巨星",
			:official_web => " http://jx.sdo.com/web3/home/index.asp",
			:sale_date => "2009-4-28",
			:company => "盛大",
			:agent => "盛大",
			:no_races => true,
			:no_professions => true,
			:description => "音乐休闲类游戏")
Gameswithhole.create( :txtid => 433, :sqlid => game433.id, :gamename => game433.name )
			game433.tag_list = "音乐, 休闲, 3D, 道具收费, 竞技" 
			game433.save
game434 = Game.create(
			:name => "顺游魔神争霸",
		      	:official_web => "http://ms.ferrygame.com/default.aspx",
		      	:sale_date => "2008-10-10",
		      	:company => "渡口科技",
		      	:agent => "顺游",
		      	:no_races => true,
		      	:description => "3D奇幻, 角色扮演回合制网游")
Gameswithhole.create( :txtid => 434, :sqlid => game434.id, :gamename => game434.name )
		    	game434.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game434.save
game435 = Game.create(
			:name => "秦伤免费版",
		      :official_web => "http://qs.zhaouc.net/",
		      :sale_date => "2005-9-12",
		      :company => "目标软件",
		      :agent => "壮游科技",
		      :no_races => true,
		      :description => "2D奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 435, :sqlid => game435.id, :gamename => game435.name )
		    	game435.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game435.save
game438 = Game.create(
			:name => "逐鹿征战",
			:official_web => "http://zz.likow.cn/",
			:sale_date => "2009-03-05",
			:company => "风云工作室",
			:agent => "莱克网络",
			:no_races => true,
			:description => "国产三国类型3D角色扮演")
Gameswithhole.create( :txtid => 438, :sqlid => game438.id, :gamename => game438.name )
			game438.tag_list = "三国, 热血, 3D, 即时战斗, 道具收费, 角色扮演"
			game438.save
game439 = Game.create(
			:name => "石器时代2",
			:official_web => "http://www.sa2.cc/",
			:sale_date => "2010-4-10",
			:company => "Digipark",
			:agent => "胜思网络",
			:no_races => true,
			:no_professions => true,
			:description => "3D休闲角色扮演游戏")
Gameswithhole.create( :txtid => 439, :sqlid => game439.id, :gamename => game439.name )
			game439.tag_list = "休闲, 3D, 角色扮演, 道具收费, 回合制战斗"
			game439.save
game441 = Game.create(
			:name => "穿越OL",
			:official_web => "http://cy.sdo.com/",
			:sale_date => "2009-7-7",
			:company => "穿越网络",
			:agent => "盛大网络",
			:no_races => true,
			:description => "2D穿越题材角色扮演游戏")
Gameswithhole.create( :txtid => 441, :sqlid => game441.id, :gamename => game441.name )
			game441.tag_list = "2D, 穿越, 角色扮演, Q版, 回合制战斗"
			game441.save
game442 = Game.create(
			:name => "猎刃",
			:official_web => "http://www.joy-china.net/lieren/index.html",
			:sale_date => "",
			:company => "中娱在线",
			:agent => "中娱在线",
			:description => "类似怪物猎人的网络游戏")
Gameswithhole.create( :txtid => 442, :sqlid => game442.id, :gamename => game442.name )
			game442.tag_list = ""
			game442.save
game443 = Game.create(
			:name => "天外飞仙",
			:official_web => "http://fx.51yx.com/",
			:sale_date => "2010-2-26",
			:company => "游戏巅峰",
			:agent => "神雕网络",
			:no_races => true,
			:description => "国产2D神话角色扮演")
Gameswithhole.create( :txtid => 443, :sqlid => game443.id, :gamename => game443.name )
			game443.tag_list = "2D, 神话, 角色扮演, 道具收费, 即时战斗"
			game443.save
game444 = Game.create(
			:name => "新天下无双",
			:official_web => "http://www.qhjoy.com/",
			:sale_date => "2010-3-16",
			:company => "青火联合网络科技",
			:agent => "青火联合网络科技",
			:no_races => true,
			:description => "国产2D奇幻角色扮演")
Gameswithhole.create( :txtid => 444, :sqlid => game444.id, :gamename => game444.name )
			game444.tag_list = "奇幻, 2D, 热血, 道具收费, 即时战斗, 角色扮演"
			game444.save
game445 = Game.create(
			:name => "仙魔OL",
			:official_web => "http://xm.jooov.cn/",
			:sale_date => "2010-3-18",
			:company => "吉位网",
			:agent => "吉位网",
			:description => "国产3D奇幻角色扮演")
Gameswithhole.create( :txtid => 445, :sqlid => game445.id, :gamename => game445.name )
			game445.tag_list = "奇幻, 3D, 热血, 道具收费, 即时战斗, 角色扮演"
			game445.save
game446 = Game.create(
			:name => "QQ音速",
			:official_web => "http://r2.qq.com/2006web/index.shtml",
			:sale_date => "2006-7-6",
			:company => "Seed9",
			:agent => "腾讯",
			:no_races => true,
			:no_professions => true,
			:description => "QQ休闲竞速游戏")
Gameswithhole.create( :txtid => 446, :sqlid => game446.id, :gamename => game446.name )
			game446.tag_list = "QQ, 休闲, 竞技, 赛车, 3D, 道具收费"
			game446.save
game447 = Game.create(
			:name => "武林外传2",
		      :official_web => "http://wulin2.wanmei.com/main.htm",
		      :sale_date => "2006-8-28",
		      :company => "完美时空",
		      :agent => "完美时空",
		      :no_races => true,
		      :description => "Q版3D神话, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 447, :sqlid => game447.id, :gamename => game447.name )
		      game447.tag_list = "Q版, 神话, 角色扮演, 道具收费, 即时战斗, 3D"
			game447.save
game448 = Game.create(
			:name => "星际争霸2",
			:official_web => "http://www.starcraft2.com/",
			:sale_date => "2009-11-23",
			:company => "暴雪",
			:agent => "暴雪",
			:no_races => true,
			:description => "即时战略")
Gameswithhole.create( :txtid => 448, :sqlid => game448.id, :gamename => game448.name )
			game448.tag_list = "即时战略, 3D, 星际, 战争, 策略"
			game448.save
game449 = Game.create(
			:name => "龙虎门",
			:official_web => "lhm.moliyo.com",
			:sale_date => "2006-12-11",
			:company => "奥义互动",
			:agent => "摩力游",
			:no_races => true,
			:no_professions => true,
			:description => "线上卡片游戏")
Gameswithhole.create( :txtid => 449, :sqlid => game449.id, :gamename => game449.name )
			game449.tag_list = "卡片, 竞技, 2D"
			game449.save
game450 = Game.create(
			:name => "大唐豪侠外传",
			:official_web => "http://dtw.163.com/",
			:sale_date => "2009-11-06",
			:company => "网易",
			:agent => "网易",
			:no_races => true,
			:description => "国产武侠角色扮演游戏")
Gameswithhole.create( :txtid => 450, :sqlid => game450.id, :gamename => game450.name )
			game450.tag_list = "热血, 武侠, 3D, 道具收费, 即时战斗, 角色扮演"
			game450.save
game452 = Game.create(
			:name => "信长之野望",
			:official_web => "http://nol.zrplay.com/",
			:sale_date => "2008-11-13",
			:company => "KOEI光荣",
			:agent => "中青创先",
			:no_races => true,
			:description => "日产古代战争角色扮演")
Gameswithhole.create( :txtid => 452, :sqlid => game452.id, :gamename => game452.name )
			game452.tag_list = "日本战争, 信长, 角色扮演, 热血, 3D, 即时战斗, 时间收费"
			game452.save
game453 = Game.create(
			:name => "蜀山仙魔传",
			:official_web => "http://my.tuiyouxi.cn/ss/hreg.aspx",
			:sale_date => "2009-2-13",
			:company => "辛巴网络游戏公司",
			:agent => "辛巴网络游戏公司",
			:no_races => true,
			:description => "国产神话3D角色扮演游戏")
Gameswithhole.create( :txtid => 453, :sqlid => game453.id, :gamename => game453.name )
			game453.tag_list = "神话, 3D, 热血, 即时战斗, 道具收费, 角色扮演"
			game453.save
game454 = Game.create(
			:name => "征途时间版",
		      :official_web => "http://zt.ztgame.com/",
		      :sale_date => "2006-4-21",
		      :company => "巨人",
		      :agent => "巨人",
		      :no_races => true,
		      :description => "大型中古玄幻网络游戏")
Gameswithhole.create( :txtid => 454, :sqlid => game454.id, :gamename => game454.name )
		      game454.tag_list = "热血, 神话, 角色扮演, 道具收费, 即时战斗, 2D"
			game454.save
game455 = Game.create(
			:name => "新天骄",
		      :official_web => "http://www.tjnet.com.cn/",
		      :sale_date => "2005-9-28",
		      :company => "目标软件",
		      :agent => "目标软件",
		      :no_areas => true,
		      :no_races => true,
		      :description => "2D角色扮演游戏")
Gameswithhole.create( :txtid => 455, :sqlid => game455.id, :gamename => game455.name )
		      game455.tag_list = "热血, 武侠, 角色扮演, 道具收费, 即时战斗, 2D"
			game455.save
game456 = Game.create(
			:name => "奇迹(台服)",
		      :official_web => "http://www.muchina.com/muchina_main.htm",
		      :sale_date => "2006-8-12",
		      :company => "网禅",
		      :agent => "第九城市",
		      :no_races => true,
		      :description => "国产2D角色扮演游戏")
Gameswithhole.create( :txtid => 456, :sqlid => game456.id, :gamename => game456.name )
		      game456.tag_list = "热血, 奇幻, 角色扮演, 时间收费, 道具收费, 即时战斗, 2D"
			game456.save
game458 = Game.create(
			:name => "新封印传说",
			:official_web => "http://youxi.zol.com.cn/ol/index5109.html",
			:sale_date => "2009-1-21",
			:company => "NFLAVOR",
			:agent => "游戏海",
			:no_races => true,
			:description => "3D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 458, :sqlid => game458.id, :gamename => game458.name )
			game458.tag_list = "3D, 奇幻, 热血, 道具收费, 即时战斗, 角色扮演"
			game458.save
game460 = Game.create(
			:name => "传奇3新传",
			:official_web => "http://www.49773.com/",
		      :sale_date => "2003-7-1",
		      :company => "盛大网络",
		      :agent => "中盛科技",
		      :no_races => true,
		      :description => "2D角色扮演游戏")
Gameswithhole.create( :txtid => 460, :sqlid => game460.id, :gamename => game460.name )
		      game460.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game460.save
game461 = Game.create(
			:name => "QQ魔域",
			:official_web => "http://games.qq.com/tencent/moy/",
		      :sale_date => "2006-3-8",
		      :company => "天晴数码",
		      :agent => "网龙",
		      :no_races => true,
		      :description => "2D奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 461, :sqlid => game461.id, :gamename => game461.name )
		      game461.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game461.save
game462 = Game.create(
			:name => "梦幻情天",
			:official_web => "http://www.playmq.com/",
			:sale_date => "2009-4-15",
			:company => "鹤图工作室",
			:agent => "中视网元",
			:no_races => true,
			:description => "3D回合制网游")
Gameswithhole.create( :txtid => 462, :sqlid => game462.id, :gamename => game462.name )
			game462.tag_list = "3D, 回合制战斗, 道具收费, Q版, 神话, 角色扮演"
			game462.save
game463 = Game.create(
			:name => "百变金刚",
			:official_web => "http://bb.163.com/fab/index.html",
			:sale_date => "2009-6-19",
			:company => "网易",
			:agent => "网易",
			:no_races => true,
			:description => "国产科幻角色扮演网游")
Gameswithhole.create( :txtid => 463, :sqlid => game463.id, :gamename => game463.name )
			game463.tag_list = "科幻, 角色扮演, 即时战斗, 3D, 机器人, 道具收费"
			game463.save
game464 = Game.create(
			:name => "三国群英传(台服)",
			:official_web => "http://kh2.uj.com.tw/",
		      :sale_date => "2005-9-15",
		      :company => "奧汀科技",
		      :agent => "奧汀科技",
		      :no_races => true,
		      :description => "3D三国类角色扮演游戏")
Gameswithhole.create( :txtid => 464, :sqlid => game464.id, :gamename => game464.name )
		    	game464.tag_list = "热血, 三国, 时间收费, 道具收费, 横板策略战斗, 3D"
			game464.save
game465 = Game.create(
			:name => "真三国无双（台服）",
			:official_web => "http://www.musouonline.com.tw/",
		      :sale_date => "2008-4-11",
		      :company => "日本光荣",
		      :agent => "日本光荣",
		      :no_areas => true,
		      :description => "3D动作竞技游戏")
Gameswithhole.create( :txtid => 465, :sqlid => game465.id, :gamename => game465.name )
		      	game465.tag_list = "热血, 动作, 道具收费, 即时战斗, 3D"
			game465.save
game466 = Game.create(
			:name => "烟雨II",
			:official_web => "http://www.y9game.com/",
			:sale_date => "2009-4-6",
			:company => "中青宝网",
			:agent => "乐游互动",
			:no_races => true,
			:description => "国产2D剑侠史诗角色扮演网游")
Gameswithhole.create( :txtid => 466, :sqlid => game466.id, :gamename => game466.name )
			game466.tag_list = "2D, 角色扮演, 武侠, 热血, 道具收费"
			game466.save
game468 = Game.create(
			:name => "魔力战记",
			:official_web => "www.1717moli.com",
			:sale_date => "2009-5-15",
			:company => "深圳神游网络",
			:agent => "深圳神游网络",
			:no_races => true,
			:description => "Q版3D角色扮演游戏")
Gameswithhole.create( :txtid => 468, :sqlid => game468.id, :gamename => game468.name )
			game468.tag_list = "Q版, 即时战斗, 角色扮演, 3D, 道具收费"
			game468.save
game469 = Game.create(
			:name => "宠物王国",
			:official_web => "http://pet.163.com/",
			:sale_date => "2010-2-1",
			:company => "网易",
			:agent => "网易",
			:no_races => true,
			:no_professions => true,
			:description => "Q版3D宠物养成角色扮演网游")
Gameswithhole.create( :txtid => 469, :sqlid => game469.id, :gamename => game469.name )
			game469.tag_list = "Q版, 宠物养成, 角色扮演, 道具收费"
			game469.save
game470 = Game.create(
			:name => "新倚天-王者",
			:official_web => "http://www.yt1.com.cn/",
			:sale_date => "2005-1-1",
			:company => "至尊网络",
			:agent => "至尊网络",
			:no_races => true,
			:description => "2D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 470, :sqlid => game470.id, :gamename => game470.name )
			game470.tag_list = "2D, 奇幻, 角色扮演, 热血, 道具收费"
			game470.save
game471 = Game.create(
			:name => "QQ侠义道II",
			:official_web => "http://games.qq.com/tencent/xyd/",
		      :sale_date => "2007-7-27",
		      :company => "成都梦工厂",
		      :agent => "腾讯",
		      :no_races => true,
		      :description => "2D武侠角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 471, :sqlid => game471.id, :gamename => game471.name )
		    	game471.tag_list = "热血, 武侠, 角色扮演, 道具收费, 即时战斗, 2D"
			game471.save
game472 = Game.create(
			:name => "梦想时空",
			:official_web => "http://mx.hygame.cn/",
			:sale_date => "2009-9-10",
			:company => "雪天网络",
			:agent => "华宇信息",
			:no_races => true,
			:description => "2D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 472, :sqlid => game472.id, :gamename => game472.name )
			game472.tag_list = "2D, 奇幻, 角色扮演, 热血, 道具收费"
			game472.save
game473 = Game.create(
			:name => "RF2变形金刚",
			:official_web => "rf2.quansou.com/",
			:sale_date => "2009-5-1",
			:company => "全搜游戏",
			:agent => "全搜游戏",
			:no_races => true,
			:no_professions => true,
			:description => "机甲战斗角色扮演游戏")
Gameswithhole.create( :txtid => 473, :sqlid => game473.id, :gamename => game473.name )
			game473.tag_list = "角色扮演, 机甲, 战争, 3D, 即时战斗, 道具收费"
			game473.save
game474 = Game.create(
			:name => "魔域(台服)",
		      :official_web => "http://my.91.com/index/",
		      :sale_date => "2006-3-8",
		      :company => "天晴数码",
		      :agent => "网龙",
		      :no_races => true,
		      :description => "2D奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 474, :sqlid => game474.id, :gamename => game474.name )
game474.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game474.save
game475 = Game.create(
			:name => "泡泡游戏",
			:official_web => "http://popogame.163.com/",
			:sale_date => "2007-1-1",
			:company => "网易",
			:agent => "网易",
			:no_races => true,
			:no_professions => true,
			:description => "休闲游戏大厅")
Gameswithhole.create( :txtid => 475, :sqlid => game475.id, :gamename => game475.name )
			game475.tag_list = "休闲, 游戏大厅"
			game475.save
game476 = Game.create(
			:name => "星空战记",
			:official_web => "http://xc.sdo.com/index.html",
			:sale_date => "2009-12-11",
			:company => "成都星漫",
			:agent => "盛大网络",
			:no_races => true,
			:description => "3D休闲角色扮演游戏")
Gameswithhole.create( :txtid => 476, :sqlid => game476.id, :gamename => game476.name )
			game476.tag_list = "Q版, 3D, 角色扮演, 道具收费, 即时战斗"
			game476.save
game477 = Game.create(
			:name => "新热血英豪",
			:official_web => "http://bfo.sdo.com/Web2.0/home/",
			:sale_date => "2009-3-1",
			:company => "CyberStep",
			:agent => "盛大网络",
			:no_races => true,
			:description => "休闲竞技游戏")
Gameswithhole.create( :txtid => 477, :sqlid => game477.id, :gamename => game477.name )
			game477.tag_list = "休闲, 2D, 竞技, 道具收费"
			game477.save
game478 = Game.create(
			:name => "夺宝旋风",
			:official_web => "http://www.dobgame.com",
			:sale_date => "2008-9-20",
			:company => "联宇科技",
			:agent => "数位世纪",
			:no_races => true,
			:no_professions => true,
			:description => "趣味技巧类休闲网络游戏")
Gameswithhole.create( :txtid => 478, :sqlid => game478.id, :gamename => game478.name )
			game478.tag_list = "休闲, 技巧, 竞技, 3D, 道具收费"
			game478.save
game479 = Game.create(
			:name => "八门",
			:official_web => "http://8m.sdo.com/",
			:sale_date => "2008-9-22",
			:company => "普讯科技",
			:agent => "盛大网络",
			:no_races => true,
			:description => "2D神话角色扮演游戏")
Gameswithhole.create( :txtid => 479, :sqlid => game479.id, :gamename => game479.name )
			game479.tag_list = "2D, 神话, 角色扮演, 道具收费, 回合制战斗"
			game479.save
game480 = Game.create(
			:name => "征途（台服）",
			:official_web => "http://zt.lager.com.tw/",
		      	:sale_date => "2006-4-21",
		      	:company => "巨人",
		      	:agent => "雷爵网络",
		      	:no_races => true,
		      	:description => "大型中古玄幻网络游戏")
Gameswithhole.create( :txtid => 480, :sqlid => game480.id, :gamename => game480.name )
		      	game480.tag_list = "热血, 神话, 角色扮演, 道具收费, 即时战斗, 2D"
			game480.save
game482 = Game.create(
			:name => "暗黑时空",
			:official_web => "http://www.cronous.com.cn/",
			:sale_date => "2008-9-18",
			:company => "Lizard Interactive",
			:agent => "全向时空",
			:no_races => true,
			:description => "3D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 482, :sqlid => game482.id, :gamename => game482.name )
			game482.tag_list = "3D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game482.save
game483 = Game.create(
			:name => "数码宝贝",
			:official_web => "http://digimon.gtgame.com.cn/",
			:sale_date => "2008-9-25",
			:company => "光通",
			:agent => "光通",
			:no_races => true,
			:description => "3DQ版角色扮演网游")
Gameswithhole.create( :txtid => 483, :sqlid => game483.id, :gamename => game483.name )
			game483.tag_list = "3D, Q版, 角色扮演, 道具收费"
			game483.save
game484 = Game.create(
			:name => "东方武易",
			:official_web => "http://wy.521g.com/",
			:sale_date => "2010-4-7",
			:company => "武易网络",
			:agent => "武易网络",
			:no_races => true,
			:description => "2D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 484, :sqlid => game484.id, :gamename => game484.name )
			game484.tag_list = "2D, 奇幻, 热血, 角色扮演, 即时战斗, 道具收费"
			game484.save
game485 = Game.create(
			:name => "东游记",
			:official_web => "http://dyj.cdcgames.net/",
			:sale_date => "2010-3-4",
			:company => "炎龙互动网络",
			:agent => "中华网游戏",
			:no_races => true,
			:description => "3D画面横版格斗类网游")
Gameswithhole.create( :txtid => 485, :sqlid => game485.id, :gamename => game485.name )
			game485.tag_list = "3D, 横板战斗, 角色扮演, 道具收费, Q版"
			game485.save
game486 = Game.create(
			:name => "剑侠世界盛大版",
			:official_web => "http://jxsj.sdo.com/",
		      	:sale_date => "2008-3-3",
		      	:company => "金山西山居",
		      	:agent => "盛大网络",
		      	:no_races => true,
		      	:description => "2D武侠角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 486, :sqlid => game486.id, :gamename => game486.name )
		      	game486.tag_list = "热血, 武侠, 角色扮演, 道具收费, 即时战斗, 2D"
			game486.save
game488 = Game.create(
			:name => "奇侠传",
			:official_web => "http://qxz.fangte.com/",
			:sale_date => "2010-4-9",
			:company => "方特网",
			:agent => "方特网",
			:no_races => true,
			:description => "Q版3D角色扮演网络游戏")
Gameswithhole.create( :txtid => 488, :sqlid => game488.id, :gamename => game488.name )
			game488.tag_list = "3D, Q版, 角色扮演, 神话, 即时战斗, 道具收费"
			game488.save
game489 = Game.create(
			:name => "自在飞车",
			:official_web => "http://vote512.sdo.com:8512/demo/fr/default.html",
			:sale_date => "2008-1-14",
			:company => "天实软件",
			:agent => "盛大网络",
			:no_races => true,
			:no_professions => true,
			:description => "3D赛车竞速游戏")
Gameswithhole.create( :txtid => 489, :sqlid => game489.id, :gamename => game489.name )
			game489.tag_list = "竞技, 赛车, 3D, 休闲, 道具收费"
			game489.save
game490 = Game.create(
			:name => "秦皇天下(台服)",
			:official_web => "http://qe.chinesegamer.net/",
			:sale_date => "2009-2-27",
			:company => "厦门网游",
			:agent => "中华网龙",
			:no_races => true,
			:description => "3D奇幻中国古代角色扮演游戏")
Gameswithhole.create( :txtid => 490, :sqlid => game490.id, :gamename => game490.name )
			game490.tag_list = "3D, 奇幻, 中国古代, 角色扮演, 道具收费, 即时战斗"
			game490.save
game491 = Game.create(
			:name => "苍穹之剑",
			:official_web => "http://www.v17173.com/Default.aspx",
			:sale_date => "2010-4-16",
			:company => "讯驰网络",
			:agent => "讯驰网络",
			:description => "2D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 491, :sqlid => game491.id, :gamename => game491.name )
			game491.tag_list = "2D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game491.save
game493 = Game.create(
			:name => "霸道",
			:official_web => "http://www.798game.com/",
			:sale_date => "2008-11-10",
			:company => "798GAME",
			:agent => "798GAME",
			:no_races => true,
			:description => "3D角色扮演游戏")
Gameswithhole.create( :txtid => 493, :sqlid => game493.id, :gamename => game493.name )
			game493.tag_list = "3D, 角色扮演, 神话, 即时战斗, 道具收费"
			game493.save
game494 = Game.create(
			:name => "西西仙境",
			:official_web => "http://xj.xixiwl.com/",
			:sale_date => "2009-12-13",
			:company => "西西网络",
			:agent => "西西网络",
			:no_races => true,
			:description => "Q版3D角色扮演游戏")
Gameswithhole.create( :txtid => 494, :sqlid => game494.id, :gamename => game494.name )
			game494.tag_list = "Q版, 3D, 角色扮演, 即时战斗, 道具收费"
			game494.save
game495 = Game.create(
			:name => "诛仙(台服)",
			:official_web => "http://zx.gameflier.com/",
		      :sale_date => "2009-09-22",
		      :company => "完美时空",
		      :agent => "游戏新干线",
		      :no_races => true,
		      :description => "国产3D大型奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 495, :sqlid => game495.id, :gamename => game495.name )
		      game495.tag_list = "史诗, 神话, 角色扮演, 道具收费, 即时战斗, 3D"
			game495.save
game496 = Game.create(
			:name => "预言OL盛大版",
			:official_web => "http://yy.sdo.com/web1/home/home.html",
		      :sale_date => "2008-4-29",
		      :company => "暴雨信息",
		      :agent => "盛大网络",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 496, :sqlid => game496.id, :gamename => game496.name )
		      game496.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game496.save
game498 = Game.create(
			:name => "地球公社",
			:official_web => "http://www.diqiugs.com/",
			:sale_date => "2009-8-15",
			:company => "腾域",
			:agent => "腾域",
			:description => "休闲游戏平台")
Gameswithhole.create( :txtid => 498, :sqlid => game498.id, :gamename => game498.name )
			game498.tag_list = "游戏平台, 休闲游戏"
			game498.save
game499 = Game.create(
			:name => "光明与黑暗OL",
			:official_web => "http://www.17mmo.com/",
			:sale_date => "2007-12-18",
			:company => "保利盈通",
			:agent => "保利盈通",
			:no_races => true,
			:description => "Q版3D角色扮演游戏")
Gameswithhole.create( :txtid => 499, :sqlid => game499.id, :gamename => game499.name )
			game499.tag_list = "Q版, 3D, 角色扮演, 即时战斗, 道具收费"
			game499.save
game500 = Game.create(
			:name => "梦幻骑士",
			:official_web => "http://qs.forugame.com/mhkiss/index.html",
			:sale_date => "2010-3-19",
			:company => "西瓜软件",
			:agent => "风云网络",
			:description => "Q版3D角色扮演网络游戏")
Gameswithhole.create( :txtid => 500, :sqlid => game500.id, :gamename => game500.name )
			game500.tag_list = "3D, Q版, 网页, 即时战斗, 道具收费, 角色扮演"
			game500.save
game501 = Game.create(
			:name => "纵横-魔武传奇",
			:official_web => "http://www.mowuol.com/",
			:sale_date => "2009-11-31",
			:company => "汗蟒科技",
			:agent => "鑫蟒网络",
			:no_races => true,
			:description => "3D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 501, :sqlid => game501.id, :gamename => game501.name )
			game501.tag_list = "3D, 奇幻, 角色扮演, 热血, 道具收费, 即时战斗"
			game501.save
game503 = Game.create(
			:name => "神谕OL",
			:official_web => "http://sy.game520.cn/",
			:sale_date => "2008-11-11",
			:company => "上海昊嘉",
			:agent => "上海昊嘉",
			:no_races => true,
			:description => "2D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 503, :sqlid => game503.id, :gamename => game503.name )
			game503.tag_list = "2D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game503.save
game504 = Game.create(
			:name => "秦伤时间版",
		      :official_web => "http://qs.zhaouc.net/",
		      :sale_date => "2005-9-12",
		      :company => "目标软件",
		      :agent => "壮游科技",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 504, :sqlid => game504.id, :gamename => game504.name )
		    	game504.tag_list = "热血, 奇幻, 角色扮演, 时间收费, 即时战斗, 2D"
			game504.save
game505 = Game.create(
			:name => "新魔界-战神光辉",
		      	:official_web => "http://www.mwo.cn/",
		      	:sale_date => "2007-11-28",
		      	:company => "金酷游戏",
		      	:agent => "金酷游戏",
		      	:no_races => true,
		      	:description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 505, :sqlid => game505.id, :gamename => game505.name )
		    	game505.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game505.save
game506 = Game.create(
			:name => "极光世界",
			:official_web => "http://www.aiaigame.com/",
			:sale_date => "2009-11-27",
			:company => "极光互动",
			:agent => "极光互动",
			:description => "3D仙侠角色扮演游戏")
Gameswithhole.create( :txtid => 506, :sqlid => game506.id, :gamename => game506.name )
			game506.tag_list = "3D, 仙侠, 角色扮演, 即时战斗, 道具收费"
			game506.save
game507 = Game.create(
			:name => "QQ堂",
			:official_web => "http://qqtang.qq.com/",
			:sale_date => "2006-12-29",
			:company => "腾讯",
			:agent => "腾讯",
			:no_races => true,
			:no_professions => true,
			:description => "休闲炸弹人类网游")
Gameswithhole.create( :txtid => 507, :sqlid => game507.id, :gamename => game507.name )
			game507.tag_list = "休闲, Q版, 炸弹人, 道具收费"
			game507.save
game508 = Game.create(
			:name => "风火之旅（台服）",
			:official_web => "http://fj.gameflier.com/",
		      :sale_date => "2007-12-19",
		      :company => "北京林果",
		      :agent => "游戏新干线",
		      :no_races => true,
		      :description => "国产3D大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 508, :sqlid => game508.id, :gamename => game508.name )
		      	game508.tag_list = "史诗, 奇幻, 角色扮演, 时间收费, 道具收费, 即时战斗, 3D"
			game508.save
game509 = Game.create(
			:name => "QQ幻想",
			:official_web => "http://fo.qq.com/index.shtml",
			:sale_date => "2005-10-25",
			:company => "腾讯",
			:agent => "腾讯",
			:no_races => true,
			:description => "Q版2D角色扮演游戏")
Gameswithhole.create( :txtid => 509, :sqlid => game509.id, :gamename => game509.name )
			game509.tag_list = "Q版, 2D, 时间收费, 角色扮演, 即时战斗"
			game509.save
game510 = Game.create(
			:name => "远征",
			:official_web => "http://yz.szgla.com/",
			:sale_date => "2010-4-1",
			:company => "深圳冰川网络",
			:agent => "深圳冰川网络",
			:no_races => true,
			:description => "2D仙侠角色扮演游戏")
Gameswithhole.create( :txtid => 510, :sqlid => game510.id, :gamename => game510.name )
			game510.tag_list = "2D, 仙侠, 角色扮演, 热血, 道具收费, 即时战斗"
			game510.save
game511 = Game.create(
			:name => "光明与黑暗OL国际",
			:official_web => "http://www.17mmo.com/",
			:sale_date => "2007-12-18",
			:company => "保利盈通",
			:agent => "保利盈通",
			:no_races => true,
			:description => "Q版3D角色扮演游戏")
Gameswithhole.create( :txtid => 511, :sqlid => game511.id, :gamename => game511.name )
			game511.tag_list = "Q版, 3D, 角色扮演, 即时战斗, 道具收费"
			game511.save
game512 = Game.create(
			:name => "龙之刃OL",
			:official_web => "http://l.mop.com/",
			:sale_date => "2009-12-15",
			:company => "千橡游戏",
			:agent => "千橡游戏",
			:no_races => true,
			:description => "网页奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 512, :sqlid => game512.id, :gamename => game512.name )
			game512.tag_list = "2D, 网页, 角色扮演, 奇幻, 道具收费, 回合制战斗"
			game512.save
game513 = Game.create(
			:name => "万王之王3(台服)",
			:official_web => "http://kok3.lager.com.tw/",
			:sale_date => "2009-10-15",
			:company => "巨人网络",
			:agent => "雷爵网络",
			:no_races => true,
			:description => "3D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 513, :sqlid => game513.id, :gamename => game513.name )
			game513.tag_list = "3D, 奇幻, 角色扮演, 即时战斗, 道具收费"
			game513.save
game514 = Game.create(
			:name => "魔界2",
			:official_web => "http://m2.12ha.com/",
			:sale_date => "2010-3-1",
			:company => "鸿利数码",
			:agent => "鸿利数码",
			:description => "3D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 514, :sqlid => game514.id, :gamename => game514.name )
			game514.tag_list = "3D, 角色扮演, 奇幻, 即时战斗, 热血"
			game514.save
game515 = Game.create(
			:name => "梦三国",
			:official_web => "http://www.m3guo.com/",
			:sale_date => "2009-12-10",
			:company => "杭州电魂",
			:agent => "杭州电魂",
			:no_races => true,
			:no_professions => true,
			:description => "dota类竞技游戏")
Gameswithhole.create( :txtid => 515, :sqlid => game515.id, :gamename => game515.name )
			game515.tag_list = "dota, 3D, 竞技"
			game515.save
game516 = Game.create(
			:name => "R2(台服)",
			:official_web => "http://www.r2online.com.tw/",
		      	:sale_date => "2007-12-19",
		      	:company => "NHN Games",
		      	:agent => "NHN Games",
		      	:no_races => true,
		      	:description => "3D大型角色扮演游戏")
Gameswithhole.create( :txtid => 516, :sqlid => game516.id, :gamename => game516.name )
		      	game516.tag_list = "史诗, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game516.save
game517 = Game.create(
			:name => "热舞派对",
			:official_web => "http://rwpd.wanmei.com/",
			:sale_date => "2005-1-1",
			:company => "完美时空",
			:agent => "完美时空",
			:no_races => true,
			:no_professions => true,
			:description => "音乐舞蹈休闲类游戏")
Gameswithhole.create( :txtid => 517, :sqlid => game517.id, :gamename => game517.name )
			game517.tag_list = "音乐, 舞蹈, 休闲, 道具收费"
			game517.save
game518 = Game.create(
			:name => "155热血三国",
			:official_web => "http://www.155game.com/rxsg/",
			:sale_date => "2008-6-3",
			:company => "UU游戏",
			:agent => "UU游戏",
			:description => "策略运营类网页游戏")
Gameswithhole.create( :txtid => 518, :sqlid => game518.id, :gamename => game518.name )
			game518.tag_list = "策略, 运营, 网页, 道具收费"
			game518.save
game519 = Game.create(
			:name => "枫之谷(台湾)",
			:official_web => "http://tw.maplestory.gamania.com/",
		      :sale_date => "2004-7-23",
		      :company => "韩国WIZET",
		      :agent => "盛大网络",
		      :no_races => true,
		      :description => "2D横板卷轴式绿色休闲游戏")
Gameswithhole.create( :txtid => 519, :sqlid => game519.id, :gamename => game519.name )
		      	game519.tag_list = "Q版, 奇幻, 角色扮演, 道具收费, 横板战斗, 2D"
			game519.save
game521 = Game.create(
			:name => "龙腾世界",
			:official_web => "http://lt.baiyou100.com/",
			:sale_date => "2009-10-15",
			:company => "目标软件",
			:agent => "百游",
			:no_races => true,
			:description => "3D仙侠类网络游戏")
Gameswithhole.create( :txtid => 521, :sqlid => game521.id, :gamename => game521.name )
			game521.tag_list = "3D, 仙侠, 角色扮演, 热血, 即时战斗, 道具收费"
			game521.save
game522 = Game.create(
			:name => "真封神国际版",
			:official_web => "http://www.zfsol.com/",
			:sale_date => "2003-1-1",
			:company => "上海米果",
			:agent => "上海米果",
			:no_races => true,
			:description => "2D神话角色扮演游戏")
Gameswithhole.create( :txtid => 522, :sqlid => game522.id, :gamename => game522.name )
			game522.tag_list = "神话, 2D, 即时战斗, 角色扮演, 热血"
			game522.save
game523 = Game.create(
			:name => "巨刃",
			:official_web => "http://jr.jymmo.com/",
			:sale_date => "2010-3-5",
			:company => "劲游网络",
			:agent => "劲游网络",
			:no_races => true,
			:no_professions => true,
			:description => "2.5D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 523, :sqlid => game523.id, :gamename => game523.name )
			game523.tag_list = "奇幻, 2.5D, 角色扮演, 即时战斗"
			game523.save
game524 = Game.create(
			:name => "六道",
			:official_web => "http://www.6dol.com/",
			:sale_date => "2009-9-30",
			:company => "武汉齐进",
			:agent => "武汉齐进",
			:no_races => true,
			:description => "2.5D神话角色扮演网络游戏")
Gameswithhole.create( :txtid => 524, :sqlid => game524.id, :gamename => game524.name )
			game524.tag_list = "2.5D, 神话, 角色扮演, 即时战斗, 道具收费"
			game524.save
game525 = Game.create(
			:name => "热血天下",
			:official_web => "http://rxtx.dayouyouxi.com/",
			:sale_date => "2009-9-26",
			:company => "目标软件",
			:agent => "大有时空",
			:no_races => true,
			:description => "2.5D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 525, :sqlid => game525.id, :gamename => game525.name )
			game525.tag_list = "2.5D, 奇幻, 角色扮演, 即时战斗, 道具收费, 热血"
			game525.save
game526 = Game.create(
			:name => "远航游艺中心",
			:official_web => "www.yhgame.cn",
			:sale_date => "2007-1-1",
			:company => "远航游戏",
			:agent => "远航游戏",
			:no_races => true,
			:no_professions => true,
			:description => "休闲游戏中心")
Gameswithhole.create( :txtid => 526, :sqlid => game526.id, :gamename => game526.name )
			game526.tag_list = "休闲, 游戏平台"
			game526.save
game527 = Game.create(
			:name => "狼队",
			:official_web => "http://wf.skdaren.com/",
			:sale_date => "2010-3-18",
			:company => "盛科达人",
			:agent => "盛科达人",
			:no_races => true,
			:no_professions => true,
			:description => "第一人称射击游戏")
Gameswithhole.create( :txtid => 527, :sqlid => game527.id, :gamename => game527.name )
			game527.tag_list = "第一人称, 射击, 竞技"
			game527.save
game528 = Game.create(
			:name => "新蜀山剑侠",
			:official_web => "http://zu.catv.net/",
			:sale_date => "2007-9-28",
			:company => "中广网",
			:agent => "中广网",
			:no_races => true,
			:description => "国产Q版2D神话角色扮演游戏")
Gameswithhole.create( :txtid => 528, :sqlid => game528.id, :gamename => game528.name )
			game528.tag_list = "2D, Q版, 神话, 角色扮演, 道具收费, 回合制战斗"
			game528.save
game529 = Game.create(
			:name => "暗潮2",
			:official_web => "http://www.anchao2.com/",
			:sale_date => "2008-3-29",
			:company => "暗潮网络",
			:agent => "暗潮网络",
			:description => "2D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 529, :sqlid => game529.id, :gamename => game529.name )
			game529.tag_list = "2D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game529.save
game530 = Game.create(
			:name => "无厘头快快",
			:official_web => "http://kk.wulitou.com/",
			:sale_date => "2007-4-19",
			:company => "北之辰",
			:agent => "百海信息",
			:no_races => true,
			:description => "休闲游戏")
Gameswithhole.create( :txtid => 530, :sqlid => game530.id, :gamename => game530.name )
			game530.tag_list = "休闲, 小游戏"
			game530.save
game532 = Game.create(
			:name => "RF2机甲崛起",
			:official_web => "http://rf2.5u56.com/",
			:sale_date => "2009-4-24",
			:company => "CCR",
			:agent => "广东数通",
			:description => "3D机甲类角色扮演网络游戏")
Gameswithhole.create( :txtid => 532, :sqlid => game532.id, :gamename => game532.name )
			game532.tag_list = "3D, 机甲, 角色扮演, 热血, 道具收费, 即时战斗"
			game532.save
game533 = Game.create(
			:name => "伊希欧之梦（台湾）",
			:official_web => "http://eco.gamecyber.com.tw/",
			:sale_date => "2005-7-31",
			:company => "Game Cyber",
			:agent => "Gungho",
			:no_races => true,
			:description => "Q版2.5D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 533, :sqlid => game533.id, :gamename => game533.name )
			game533.tag_list = "Q版, 2.5D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game533.save
game535 = Game.create(
			:name => "QQ新魔界",
			:official_web => "http://games.qq.com/tencent/mjo/",
		      :sale_date => "2007-11-28",
		      :company => "金酷游戏",
		      :agent => "腾讯",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 535, :sqlid => game535.id, :gamename => game535.name )
		    	game535.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game535.save
game538 = Game.create(
			:name => "战锤OL(台湾)",
			:official_web => "http://www.warhammeronline.com.tw/",
			:sale_date => "2009-5-28",
			:company => "Mythic Entertainment",
			:agent => "和信超",
			:no_races => true,
			:description => "欧美3D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 538, :sqlid => game538.id, :gamename => game538.name )
			game538.tag_list = "3D, 奇幻, 角色扮演, 诗史, 即时战斗"
			game538.save
game540 = Game.create(
			:name => "七剑",
			:official_web => "http://qj.798game.com/",
			:sale_date => "2009-11-1",
			:company => "798GAME",
			:agent => "798GAME",
			:no_races => true,
			:description => "3D武侠角色扮演游戏")
Gameswithhole.create( :txtid => 540, :sqlid => game540.id, :gamename => game540.name )
			game540.tag_list = "3D, 武侠, 角色扮演, 道具收费, 即时战斗, 热血"
			game540.save
game541 = Game.create(
			:name => "顺游新魔界",
			:official_web => "http://xmj.syoogame.com/",
		      :sale_date => "2007-11-28",
		      :company => "金酷游戏",
		      :agent => "顺游",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 541, :sqlid => game541.id, :gamename => game541.name )
		    	game541.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game541.save
game542 = Game.create(
			:name => "蒸汽幻想（台服）",
			:official_web => "http://ns.x-legend.com.tw/",
		      :sale_date => "2007-3-15",
		      :company => "Hanbitsoft",
		      :agent => "天游软件",
		      :description => "Q版3D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 542, :sqlid => game542.id, :gamename => game542.name )
		    	game542.tag_list = "Q版, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game542.save
game543 = Game.create(
			:name => "新海盗王",
			:official_web => "http://xhdw.moliyo.com/",
			:sale_date => "2008-8-15",
			:company => "摩力游",
			:agent => "摩力游",
			:no_races => true,
			:description => "Q版3D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 543, :sqlid => game543.id, :gamename => game543.name )
			game543.tag_list = "Q版, 3D, 角色扮演, 即时战斗, 奇幻"
			game543.save
game545 = Game.create(
			:name => "梦幻龙族传说(台)",
			:official_web => "http://ml.gameflier.com/",
		      :sale_date => "2009-2-26",
		      :company => "barunson",
		      :agent => "冰动娱乐",
		      :no_races => true,
		      :description => "Q版3D角色扮演游戏")
Gameswithhole.create( :txtid => 545, :sqlid => game545.id, :gamename => game545.name )
		    	game545.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game545.save
game547 = Game.create(
			:name => "龙之谷",
			:official_web => "http://dn.sdo.com/web5/home/index.html",
			:sale_date => "2009-12-22",
			:company => "EYEDENTITY",
			:agent => "盛大网络",
			:no_races => true,
			:description => "3D奇幻动作角色扮演网游")
Gameswithhole.create( :txtid => 547, :sqlid => game547.id, :gamename => game547.name )
			game547.tag_list = "3D, 奇幻, 角色扮演, 动作, 道具收费"
			game547.save
game548 = Game.create(
			:name => "无剑世界",
			:official_web => "http://www.jian01.com/",
			:sale_date => "2009-10-16",
			:company => "目标软件",
			:agent => "乐游网",
			:no_races => true,
			:description => "2D武侠角色扮演")
Gameswithhole.create( :txtid => 548, :sqlid => game548.id, :gamename => game548.name )
			game548.tag_list = "武侠, 2D, 即时战斗, 角色扮演"
			game548.save
game549 = Game.create(
			:name => "永恒世界",
			:official_web => "http://yh.lqn.cn/",
			:sale_date => "2009-8-8",
			:company => "雷穹网络",
			:agent => "雷穹网络",
			:no_races => true,
			:description => "3D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 549, :sqlid => game549.id, :gamename => game549.name )
			game549.tag_list = "奇幻, 3D, 即时战斗, 角色扮演, 道具收费"
			game549.save
game550 = Game.create(
			:name => "丝路2(台服)",
			:official_web => "http://www.sro.com.tw/",
		      :sale_date => "2008-4-2",
		      :company => "韩国JOYMAX",
		      :agent => "北京世模科技",
		      :no_races => true,
		      :description => "3D奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 550, :sqlid => game550.id, :gamename => game550.name )
		   	game550.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game550.save
game551 = Game.create(
			:name => "九阴真经OL",
			:official_web => "http://9yin.woniu.com/",
			:sale_date => "2009-9-20",
			:company => "蜗牛电子",
			:agent => "蜗牛电子",
			:no_races => true,
			:description => "3D武侠角色扮演网游")
Gameswithhole.create( :txtid => 551, :sqlid => game551.id, :gamename => game551.name )
			game551.tag_list = "3D, 武侠, 角色扮演, 即时战斗"
			game551.save
game552 = Game.create(
			:name => "神迹-仙魔道",
			:official_web => "http://www.qiqu.com",
			:sale_date => "2005-12-12",
			:company => "奇趣网游",
			:agent => "奇趣网游",
			:description => "2D奇幻角色扮演网络游戏")
Gameswithhole.create( :txtid => 552, :sqlid => game552.id, :gamename => game552.name )
			game552.tag_list = "2D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game552.save
game553 = Game.create(
			:name => "街头篮球2",
			:official_web => "http://www.fs2joy.com/",
			:sale_date => "2010-3-30",
			:company => "JoyCity",
			:agent => "天游",
			:no_races => true,
			:no_professions => true,
			:description => "休闲竞技篮球游戏")
Gameswithhole.create( :txtid => 553, :sqlid => game553.id, :gamename => game553.name )
			game553.tag_list = "休闲, 竞技, 体育, 篮球"
			game553.save
game554 = Game.create(
			:name => "新三国群英传",
			:official_web => "http://sg.gfyoyo.com.cn/heroes/",
		      :sale_date => "2005-9-15",
		      :company => "奧汀科技",
		      :agent => "悠游网",
		      :no_races => true,
		      :description => "3D三国类角色扮演游戏")
Gameswithhole.create( :txtid => 554, :sqlid => game554.id, :gamename => game554.name )
		    game554.tag_list = "热血, 三国, 时间收费, 道具收费, 横板策略战斗, 3D"
			game554.save
game555 = Game.create(
			:name => "问情OL",
			:official_web => "http://wq.wtgame.net/",
			:sale_date => "2009-11-26",
			:company => "问天科技",
			:agent => "问天科技",
			:no_races => true,
			:description => "国产Q版3D回合制角色扮演游戏")
Gameswithhole.create( :txtid => 555, :sqlid => game555.id, :gamename => game555.name )
			game555.tag_list = "Q版, 3D, 角色扮演, 道具收费, 回合制战斗"
			game555.save
game556 = Game.create(
			:name => "武神",
			:official_web => "http://ws.wushen.com/",
			:sale_date => "2009-11-15",
			:company => "武神世纪",
			:agent => "武神世纪",
			:no_races => true,
			:description => "2.5D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 556, :sqlid => game556.id, :gamename => game556.name )
			game556.tag_list = "2.5D, 奇幻, 角色扮演, 即时战斗"
			game556.save
game557 = Game.create(
			:name => "天地传说",
			:official_web => "http://www.td-game.com/tdcs/",
			:sale_date => "2009-10-25",
			:company => "深圳任天下",
			:agent => "深圳任天下",
			:no_races => true,
			:description => "国产2D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 557, :sqlid => game557.id, :gamename => game557.name )
			game557.tag_list = "2D, 奇幻, 角色扮演, 即时战斗, 道具收费"
			game557.save
game558 = Game.create(
			:name => "星辰变",
			:official_web => "http://xcb.sdo.com/web1/home/",
			:sale_date => "2010-4-10",
			:company => "盛大网络",
			:agent => "盛大网络",
			:no_races => true,
			:description => "2D仙侠角色扮演网络游戏")
Gameswithhole.create( :txtid => 558, :sqlid => game558.id, :gamename => game558.name )
			game558.tag_list = "2D, 仙侠, 角色扮演, 即时战斗"
			game558.save
game559 = Game.create(
			:name => "王者之剑(台服)",
			:official_web => "http://ge.wayi.com.tw/",
			:sale_date => "2009-9-20",
			:company => "华义",
			:agent => "华义",
			:no_races => true,
			:description => "3D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 559, :sqlid => game559.id, :gamename => game559.name )
			game559.tag_list = "3D, 奇幻, 角色扮演, 即时战斗, 道具收费"
			game559.save
game560 = Game.create(
			:name => "开心果",
			:official_web => "http://kxg.wanku.com/index.html",
			:sale_date => "2009-12-12",
			:company => "火石软件",
			:agent => "火石软件",
			:no_races => true,
			:no_professions => true,
			:description => "偷菜类休闲网游")
Gameswithhole.create( :txtid => 560, :sqlid => game560.id, :gamename => game560.name )
			game560.tag_list = "偷菜, 休闲, 道具收费"
			game560.save
game562 = Game.create(
			:name => "腾云世界",
			:official_web => "http://www.17teng.com/",
			:sale_date => "2008-9-26",
			:company => "宣游科技",
			:agent => "宣游科技",
			:no_races => true,
			:description => "3D回合制仙侠角色扮演游戏")
Gameswithhole.create( :txtid => 562, :sqlid => game562.id, :gamename => game562.name )
			game562.tag_list = "3D, 回合制战斗, 仙侠, 角色扮演"
			game562.save
game563 = Game.create(
			:name => "铁血迷情完美版",
			:official_web => "http://www.dk2.com.cn/",
			:sale_date => "2006-11-1",
			:company => "韩国metro tech",
			:agent => "天图科技",
			:no_races => true,
			:description => "韩国3D角色扮演游戏")
Gameswithhole.create( :txtid => 563, :sqlid => game563.id, :gamename => game563.name )
			game563.tag_list = "3D, 热血, 道具收费, 奇幻, 即时战斗"
			game563.save
game564 = Game.create(
			:name => "神仙OL",
			:official_web => "http://sx.798game.com/",
			:sale_date => "2009-5-8",
			:company => "魔码奥义",
			:agent => "798GAME",
			:no_races => true,
			:description => "3D神话角色扮演网游")
Gameswithhole.create( :txtid => 564, :sqlid => game564.id, :gamename => game564.name )
			game564.tag_list = "3D, Q版, 神话, 角色扮演, 道具收费"
			game564.save
game566 = Game.create(
			:name => "成吉思汗",
			:official_web => "http://han.70yx.com/",
			:sale_date => "2009-4-10",
			:company => "麒麟网",
			:agent => "麒麟网",
			:description => "3D仙侠类游戏")
Gameswithhole.create( :txtid => 566, :sqlid => game566.id, :gamename => game566.name )
			game566.tag_list ="3D, 仙侠, 道具收费, 即时战斗, 角色扮演"
			game566.save
game567 = Game.create(
			:name => "魔灵",
			:official_web => "http://ml.lqn.cn/",
			:sale_date => "2009-7-17",
			:company => "凯赛科技",
			:agent => "雷穹网络",
			:no_races => true,
			:description => "3D奇幻角色扮演")
Gameswithhole.create( :txtid => 567, :sqlid => game567.id, :gamename => game567.name )
			game567.tag_list = "3D, 奇幻, 角色扮演, 热血, 道具收费, 即时战斗"
			game567.save
game568 = Game.create(
			:name => "六圣群侠传OL",
			:official_web => "http://ls.online-game.com.cn/index.asp",
			:sale_date => "2008-5-29",
			:company => "中华网龙",
			:agent => "游龙在线",
			:no_races => true,
			:no_professions => true,
			:description => "2D角色扮演游戏")
Gameswithhole.create( :txtid => 568, :sqlid => game568.id, :gamename => game568.name )
			game568.tag_list = "2D, 角色扮演, 奇幻, 道具收费, 即时战斗"
			game568.save
game570 = Game.create(
			:name => "希望(台服)",
			:official_web => "http://www.newseal.com.tw/",
		      :sale_date => "2004-12-15",
		      :company => "韩国Grigon",
		      :agent => "光宇华夏",
		      :no_races => true,
		      :description => "休闲3D角色扮演游戏")
Gameswithhole.create( :txtid => 570, :sqlid => game570.id, :gamename => game570.name )
		      	game570.tag_list = "Q版, 休闲, 道具收费, 即时战斗, 3D"
			game570.save
game571 = Game.create(
			:name => "侠客列传",
			:official_web => "http://www.t2xk.com/",
			:sale_date => "2009-11-5",
			:company => "天游",
			:agent => "天游",
			:no_races => true,
			:description => "3D仙侠角色扮演网游")
Gameswithhole.create( :txtid => 571, :sqlid => game571.id, :gamename => game571.name )
			game571.tag_list = "3D, 仙侠, 角色扮演, 即时战斗, 道具收费"
			game571.save
game572 = Game.create(
			:name => "新天羽传奇",
			:official_web => "http://bf.ferrygame.com/cover/index.aspx",
			:sale_date => "2008-8-18",
			:company => "网游数码",
			:agent => "渡口",
			:no_races => true,
			:description => "Q版2D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 572, :sqlid => game572.id, :gamename => game572.name )
			game572.tag_list = "Q版, 2D, 角色扮演, 奇幻, 道具收费, 即时战斗"
			game572.save
game573 = Game.create(
			:name => "地下城与勇士(台)",
			:official_web => "http://tw.dnf.gamania.com/",
			:sale_date => "2008-6-19",
			:company => "Neople",
			:agent => "腾讯",
			:description => "2D横版格斗网游")
Gameswithhole.create( :txtid => 573, :sqlid => game573.id, :gamename => game573.name )
		    	game573.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 横板战斗, 2D"
			game573.save
game577 = Game.create(
			:name => "易三国OL",
			:official_web => "http://ysg.163.com/",
			:sale_date => "2009-10-18",
			:company => "网易",
			:agent => "网易",
			:description => "2.5D回合制角色扮演")
Gameswithhole.create( :txtid => 577, :sqlid => game577.id, :gamename => game577.name )
			game577.tag_list = "2.5D, 回合制战斗, 角色扮演, 道具收费, 三国"
			game577.save
game578 = Game.create(
			:name => "篮球也疯狂",
			:official_web => "http://ball.163.com/",
			:sale_date => "2009-6-1",
			:company => "网易",
			:agent => "网易",
			:no_races => true,
			:no_professions => true,
			:description => "Q版篮球休闲游戏")
Gameswithhole.create( :txtid => 578, :sqlid => game578.id, :gamename => game578.name )
			game578.tag_list = "Q版, 篮球, 运动, 体育, 休闲, 道具收费"
			game578.save
game579 = Game.create(
			:name => "封神争霸OL",
			:official_web => "http://www.fszbol.com/index.html",
			:sale_date => "2009-11-29",
			:company => "天腾在线",
			:agent => "天腾在线",
			:no_races => true,
			:description => "2.5D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 579, :sqlid => game579.id, :gamename => game579.name )
			game579.tag_list = "2.5D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game579.save
game582 = Game.create(
			:name => "神界",
			:official_web => "http://sj.gyyx.cn/",
			:sale_date => "2006-12-21",
			:company => "联竣信息",
			:agent => "光宇华夏",
			:no_races => true,
			:description => "2D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 582, :sqlid => game582.id, :gamename => game582.name )
			game582.tag_list = "2D, 奇幻, 角色扮演, 即时战斗"
			game582.save
game583 = Game.create(
			:name => "极速轮滑",
			:official_web => "http://sg.17game.com/",
			:sale_date => "2008-8-20",
			:company => "Nflavor",
			:agent => "17GAME",
			:no_races => true,
			:no_professions => true,
			:description => "休闲竞速游戏")
Gameswithhole.create( :txtid => 583, :sqlid => game583.id, :gamename => game583.name )
			game583.tag_list = "休闲, 竞速"
			game583.save
game584 = Game.create(
			:name => "征战(台服)",
			:official_web => "http://war.x-legend.com.tw/",
		      :sale_date => "2008-5-13",
		      :company => "风云工作室",
		      :agent => "龙游天下",
		      :description => "3D三国类奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 584, :sqlid => game584.id, :gamename => game584.name )
		    	game584.tag_list = "热血, 奇幻, 角色扮演, 三国, 道具收费, 即时战斗, 3D"
			game584.save
game585 = Game.create(
			:name => "乌龙学院II",
			:official_web => "http://www.wulongonline.com/",
			:sale_date => "2009-2-28",
			:company => "乌龙网络",
			:agent => "乌龙网络",
			:no_races => true,
			:no_professions => true,
			:description => "英语学习游戏")
Gameswithhole.create( :txtid => 585, :sqlid => game585.id, :gamename => game585.name )
			game585.tag_list = "英语学习, 2D, 道具收费"
			game585.save
game586 = Game.create(
			:name => "多玩弹弹堂",
			:official_web => "http://www.duowan.com",
			:sale_date => "2009-10-10",
			:company => "多玩",
			:agent => "多玩",
			:no_races => true,
			:no_professions => true,
			:description => "国产Q版射击类竞技游戏")
Gameswithhole.create( :txtid => 586, :sqlid => game586.id, :gamename => game586.name )
			game586.tag_list = "Q版, 射击, 竞技, 休闲, 道具收费"
			game586.save
game587 = Game.create(
			:name => "神州OL",
			:official_web => "http://www.17shenzhou.com/",
			:sale_date => "2005-1-1",
			:company => "宇峻奥汀",
			:agent => "文永丞信息",
			:no_races => true,
			:description => "国产2D仙侠角色扮演游戏")
Gameswithhole.create( :txtid => 587, :sqlid => game587.id, :gamename => game587.name )
			game587.tag_list = "2D, 仙侠, 角色扮演, 道具收费, 即时战斗"
			game587.save
game588 = Game.create(
			:name => "真封神",
			:official_web => "http://zfs.gamigo.com.cn/default.php",
			:sale_date => "2003-1-1",
			:company => "上海米果",
			:agent => "上海米果",
			:no_races => true,
			:description => "2D神话角色扮演游戏")
Gameswithhole.create( :txtid => 588, :sqlid => game588.id, :gamename => game588.name )
			game588.tag_list = "神话, 2D, 即时战斗, 角色扮演, 热血"
			game588.save
game589 = Game.create(
			:name => "永恒纪元(台湾)",
			:official_web => "http://aion.plaync.com.tw/",
			:sale_date => "2009-4-16",
			:company => "NCSOFT",
			:agent => "盛大在线",
			:description => "韩国大型角色扮演游戏")
Gameswithhole.create( :txtid => 589, :sqlid => game589.id, :gamename => game589.name )
		 	game589.tag_list = "史诗, 奇幻, 角色扮演, 时间收费, 即时战斗, 3D"
			game589.save
game590 = Game.create(
			:name => "八仙OL",
			:official_web => "http://www.8xol.com/",
			:sale_date => "2008-11-5",
			:company => "久连网络科技",
			:agent => "久连网络科技",
			:no_races => true,
			:no_professions =>true,
			:description => "卡片游戏")
Gameswithhole.create( :txtid => 590, :sqlid => game590.id, :gamename => game590.name )
			game590.tag_list = "卡片游戏"
			game590.save
game591 = Game.create(
			:name => "生肖传说",
			:official_web => "http://sx.12ha.com/",
		      :sale_date => "2009-10-23",
		      :company => "金酷游戏",
		      :agent => "金酷游戏",
		      :no_races => true,
		      :description => "Q版3D回合制角色扮演游戏")
Gameswithhole.create( :txtid => 591, :sqlid => game591.id, :gamename => game591.name )
		    game591.tag_list = "Q版, 神话, 角色扮演, 道具收费, 回合制战斗, 3D"
			game591.save
game592 = Game.create(
			:name => "Luna(台服)",
			:official_web => "http://luna.omg.com.tw/",
		      :sale_date => "2009-6-12",
		      :company => "EYA",
		      :agent => "天游",
		      :description => "粉可爱的Q版网游")
Gameswithhole.create( :txtid => 592, :sqlid => game592.id, :gamename => game592.name )
		      	game592.tag_list = "Q版, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game592.save
game594 = Game.create(
			:name => "赤壁(台服)",
			:official_web => "http://www.chibi.com.tw/",
		      :sale_date => "2008-2-28",
		      :company => "完美时空",
		      :agent => "完美时空",
		      :no_races => true,
		      :description => "国产3D大型网络游戏")
Gameswithhole.create( :txtid => 594, :sqlid => game594.id, :gamename => game594.name )
		      	game594.tag_list = "热血, 武侠, 角色扮演, 道具收费, 即时战斗, 3D"
			game594.save
game595 = Game.create(
			:name => "神界外传",
			:official_web => "http://www.shenjiewz.com/",
			:sale_date => "2009-12-4",
			:company => "联竣科技",
			:agent => "江苏友聪",
			:no_races => true,
			:description => "2D奇幻角色扮演")
Gameswithhole.create( :txtid => 595, :sqlid => game595.id, :gamename => game595.name )
			game595.tag_list = "2D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game595.save
game596 = Game.create(
			:name => "新龙影",
			:official_web => "http://www.52sol.com/",
			:sale_date => "2007-12-31",
			:company => "上海智川",
			:agent => "上海智川",
			:no_races => true,
			:description => "3D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 596, :sqlid => game596.id, :gamename => game596.name )
			game596.tag_list = "3D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game596.save
game597 = Game.create(
			:name => "大话轩辕",
			:official_web => "http://xy.51yx.com/",
			:sale_date => "2010-1-7",
			:company => "神雕网络",
			:agent => "神雕网络",
			:no_races => true,
			:description => "2D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 597, :sqlid => game597.id, :gamename => game597.name )
			game597.tag_list = "2D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game597.save
game599 = Game.create(
			:name => "仙剑(台服)",
			:official_web => "http://cpo.gameflier.com/index.asp",
		      :sale_date => "2009-1-9",
		      :company => "大宇",
		      :agent => "游戏新干线",
		      :no_races => true,
		      :description => "3D神话角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 599, :sqlid => game599.id, :gamename => game599.name )
		      	game599.tag_list = "热血, 神话, 角色扮演, 道具收费, 即时战斗, 3D"
			game599.save
game600 = Game.create(
			:name => "传奇外传",
			:official_web => "http://mirs.sdo.com/web5/index.html",
		      :sale_date => "2008-10-23",
		      :company => "盛大在线",
		      :agent => "盛大在线",
		      :no_races => true,
		      :description => "盛大开发传奇系列角色扮演游戏")
Gameswithhole.create( :txtid => 600, :sqlid => game600.id, :gamename => game600.name )
		      	game600.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game600.save
game602 = Game.create(
			:name => "疯狂赛车",
			:official_web => "http://kart.sdo.com/",
		      :sale_date => "2008-5-10",
		      :company => "盛大网络",
		      :agent => "盛大网络",
		      :no_areas => true,
		      :no_races => true,
		      :no_professions => true,
		      :description => "休闲赛车")
Gameswithhole.create( :txtid => 602, :sqlid => game602.id, :gamename => game602.name )
		      	game602.tag_list = "轻松, 休闲, 道具收费, 赛车, 3D"
			game602.save
game603 = Game.create(
			:name => "百年战争",
			:official_web => "http://bn.176.com/",
			:sale_date => "2009-11-26",
			:company => "天盟数码",
			:agent => "天盟数码",
			:no_races => true,
			:description => "Q版3D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 603, :sqlid => game603.id, :gamename => game603.name )
			game603.tag_list = "Q版, 3D, 奇幻, 角色扮演, 道具收费"
			game603.save
game606 = Game.create(
			:name => "梦幻战国",
			:official_web => "http://mhzg.qwd1.com/",
			:sale_date => "2009-9-16",
			:company =>  "网游数码",
			:agent => "趣味第一",
			:no_races => true,
			:description => "Q版2D奇幻角色扮演")
Gameswithhole.create( :txtid => 606, :sqlid => game606.id, :gamename => game606.name )
			game606.tag_list = "Q版, 2D, 奇幻, 角色扮演, 道具收费, 即时战斗"
			game606.save
game607 = Game.create(
			:name => "西西三国",
			:official_web => "http://www.xixisanguo.com/",
			:sale_date => "2009-8-21",
			:company => "西西网络",
			:agent => "西西网络",
			:description => "Q版3D奇幻角色扮演")
Gameswithhole.create( :txtid => 607, :sqlid => game607.id, :gamename => game607.name )
			game607.tag_list = "Q版, 3D, 角色扮演, 奇幻, 即时战斗, 道具收费"
			game607.save
game608 = Game.create(
			:name => "新英雄时代",
			:official_web => "http://xyx.sdo.com/web2/home/",
			:sale_date => "2008-2-25",
			:company => "盛大",
			:agent => "盛大",
      			:no_races => true,
			:description => "国产武侠角色扮演网游")
Gameswithhole.create( :txtid => 608, :sqlid => game608.id, :gamename => game608.name )
			game608.tag_list = "武侠, 2D, 道具收费, 即时战斗, 热血"
			game608.save
game610 = Game.create(
			:name => "龙域天下",
			:official_web => "ly.bao3.com",
			:sale_date => "2009-1-18",
			:company => "盛科网络",
			:agent => "宝3网",
			:description => "国产玄幻类2.5D写实网游")
Gameswithhole.create( :txtid => 610, :sqlid => game610.id, :gamename => game610.name )
			game610.tag_list = "玄幻, 2.5D, 即时战斗, 热血"
			game610.save
game611 = Game.create(
			:name => "大话水浒",
			:official_web => "http://dhsh.changyou.com/",
			:sale_date => "2010-1-5",
			:company => "搜狐畅游",
			:agent => "搜狐畅游",
                        :no_races => true,
			:description => "国产Q版奇幻2D回合制战斗网游")
Gameswithhole.create( :txtid => 611, :sqlid => game611.id, :gamename => game611.name )
			game611.tag_list = "奇幻, 2D, 道具收费, 回合制战斗, Q版"
			game611.save
game612 = Game.create(
			:name => "春秋外传",
			:official_web => "http://cw.xoyo.com/",
			:sale_date => "2009-7-16",
			:company => "金山",
			:agent => "金山",
                        :no_races => true,
			:description => "国产Q版2.5D角色扮演网游")
Gameswithhole.create( :txtid => 612, :sqlid => game612.id, :gamename => game612.name )
			game612.tag_list = "休闲, 2.5D, 道具收费, 即时战略, Q版"
			game612.save
game613 = Game.create(
			:name => "灭神",
			:official_web => "http://www.mieshen.net/",
			:sale_date => "2009-11-10",
			:company => "缔顺科技",
			:agent => "缔顺科技",
			:description => "国产3D神话玄幻MMORPG网游")
Gameswithhole.create( :txtid => 613, :sqlid => game613.id, :gamename => game613.name )
			game613.tag_list = "中国玄幻, 3D, 即时战斗, 热血"
			game613.save
game614 = Game.create(
			:name => "疯狂石头",
			:official_web => "http://st.163.com/",
			:sale_date => "2007-10-29",
			:company => "网易",
			:agent => "网易",
                        :no_races => true,
                        :no_professions => true,
			:description => "国产Q版运动休闲打斗网游")
Gameswithhole.create( :txtid => 614, :sqlid => game614.id, :gamename => game614.name )
			game614.tag_list = "休闲, 2D, 道具收费, 回合制战斗, Q版"
			game614.save
game615 = Game.create(
			:name => "游艺天道",
			:official_web => "http://td.yyge.com/",
		      :sale_date => "2008-7-25",
		      :company => "中青宝网",
		      :agent => "中青宝网",
		      :no_races => true,
		      :description => "2D角色扮演游戏")
Gameswithhole.create( :txtid => 615, :sqlid => game615.id, :gamename => game615.name )
		    	game615.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game615.save
game616 = Game.create(
			:name => "命运2",
			:official_web => "http://www.happydigi.com",
			:sale_date => "2005-12-9",
			:company => "韩光软件",
			:agent => "欢乐数码",
                        :no_races => true,
			:description => "韩国3D奇幻角色扮演多人在线网游")
Gameswithhole.create( :txtid => 616, :sqlid => game616.id, :gamename => game616.name )
			game616.tag_list = "奇幻, 3D, 道具收费, 即时战斗, 史诗"
			game616.save
game617 = Game.create(
			:name => "真三国",
			:official_web => "zsg.hopecool.com",
			:sale_date => "2008-12-26",
			:company => "红图互动",
			:agent => "好客网",
			:description => "国产3D历史题材角色扮演多人在线网游")
Gameswithhole.create( :txtid => 617, :sqlid => game617.id, :gamename => game617.name )
			game617.tag_list = "中国玄幻, 3D, 即时战斗, 热血"
			game617.save
game618 = Game.create(
			:name => "万王之王2(台服)",
			:official_web => "http://kok2.lager.com.tw/",
			:sale_date => "2006-7-7",
			:company => "雷爵网络",
			:agent => "亚洲互动",
			:no_races => true,
			:description => "3D奇幻角色扮演游戏")
Gameswithhole.create( :txtid => 618, :sqlid => game618.id, :gamename => game618.name )
			game618.tag_list = "3D, 奇幻, 角色扮演, 时间收费, "
			game618.save
game619 = Game.create(
			:name => "激战海陆空",
			:official_web => "http://www.pkhlk.com/opencms/export/sites/wwiiol/index.jsp.html",
			:sale_date => "2009-12-12",
			:company => "Playnet",
			:agent => "快乐天成",
                        :no_races => true,
                        :no_professions => true,
			:description => "国外二战题材第一人称射击对战网游" )
Gameswithhole.create( :txtid => 619, :sqlid => game619.id, :gamename => game619.name )
			game619.tag_list = "战争, 3D, 道具收费, 第一人称射击, 仿真"
			game619.save
game620 = Game.create(
			:name => "真水浒",
			:official_web => "http://zsh.hopecool.com/",
			:sale_date => "2008-12-20",
			:company => "红图互动",
			:agent => "好客网",
                        :no_races => true,
			:description => "国产历史多人在线角色扮演网络游戏")
Gameswithhole.create( :txtid => 620, :sqlid => game620.id, :gamename => game620.name )
			game620.tag_list = "武侠, 2.5D, 即时战略, 热血"
			game620.save
game621 = Game.create(
			:name => "神泣(台服)",
			:official_web => "http://shaiya.omg.com.tw/",
		      :sale_date => "2006-11-20",
		      :company => "韩国SONOKONG",
		      :agent => "游戏派对",
		      :no_races => true,
		      :description => "韩国3D角色扮演游戏")
Gameswithhole.create( :txtid => 621, :sqlid => game621.id, :gamename => game621.name )
		      	game621.tag_list = "史诗, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game621.save
game623 = Game.create(
			:name => "传奇三1.45怀旧版",
			:official_web => "http://mir3.gtgame.com.cn/index.html",
			:sale_date => "2003-5-25",
			:company => "Wemade",
			:agent => "光通",
			:description => "3D 大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 623, :sqlid => game623.id, :gamename => game623.name )
			game623.tag_list ="3D,奇幻,热血"
			game623.save
game624 = Game.create(
			:name => "享乐人生",
			:official_web => "http://life.yyge.com/",
			:sale_date => "2010-7-23",
			:company => "广州游艺",
			:agent => "广州游艺",
			:description => "国产现代题材的经营休闲类网游")
Gameswithhole.create( :txtid => 624, :sqlid => game624.id, :gamename => game624.name )
			game624.tag_list = "休闲, 2.5D, 道具收费, 经营, 轻松"
			game624.save
game625 = Game.create(
			:name => "QQ仙侠传",
			:official_web => "http://xxz.qq.com/",
			:sale_date => "2009-10-28",
			:company => "腾讯",
			:agent => "腾讯",
                        :no_races => true,
			:description => "国产3D神话武侠玄幻角色扮演多人在线网游")
Gameswithhole.create( :txtid => 625, :sqlid => game625.id, :gamename => game625.name )
			game625.tag_list = "中国玄幻, 3D, 即时战斗, 热血"
			game625.save
game626 = Game.create(
			:name => "预言OL经典版",
		      :official_web => "http://www.yuyan.com/",
		      :sale_date => "2008-4-29",
		      :company => "暴雨信息",
		      :agent => "暴雨信息",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 626, :sqlid => game626.id, :gamename => game626.name )
		      game626.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game626.save
game627 = Game.create(
			:name => "沧海",
			:official_web => "http://ch.798game.com/",
			:sale_date => "2009-10-16",
			:company => "乐游科技",
			:agent => "798GAME",
                        :no_races => true,
			:description => "国产2.5D武侠网游角色扮演热血网游")
Gameswithhole.create( :txtid => 627, :sqlid => game627.id, :gamename => game627.name )
			game627.tag_list = "武侠, 2.5D, 即时战斗, 热血"
			game627.save
game628 = Game.create(
			:name => "猎国",
			:official_web => "http://www.lieguo.com/",
			:sale_date => "2010-4-7",
			:company => "深红网络",
			:agent => "深红网络",
                        :no_races => true,
			:description => "国产奇幻2.5D角色扮演多人在线网游")
Gameswithhole.create( :txtid => 628, :sqlid => game628.id, :gamename => game628.name )
			game628.tag_list = "奇幻, 2.5D, 即时战斗, 热血"
			game628.save
game629 = Game.create(
			:name => "龙魂",
			:official_web => "http://lh.ztgame.com/",
			:sale_date => "2009-10-22",
			:company => "巨人网络",
			:agent => "巨人网络",
			:description => "国产大型3D神话玄幻角色扮演多人在线网游")
Gameswithhole.create( :txtid => 629, :sqlid => game629.id, :gamename => game629.name )
			game629.tag_list = "中国玄幻, 3D, 道具收费, 即时战斗, 热血"
			game629.save
game631 = Game.create(
			:name => "王者三国",
			:official_web => "http://lj.zqgame.com/",
			:sale_date => "2009-10-15",
			:company => "中青宝网",
			:agent => "中青宝网",
                        :no_races => true,
			:description => "以三国时代为背景的大型3D多人在线角色扮演网游")
Gameswithhole.create( :txtid => 631, :sqlid => game631.id, :gamename => game631.name )
			game631.tag_list = "战争, 3D, 即时战斗, 热血"
			game631.save
game632 = Game.create(
			:name => "闪投部落",
			:official_web => "http://stbl.fangte.com/",
			:sale_date => "2009-9-28",
			:company => "华强游戏",
			:agent => "华强游戏",
                        :no_races => true,
                        :no_professions => true,
			:description => "国产时尚和休闲的对战类网游")
Gameswithhole.create( :txtid => 632, :sqlid => game632.id, :gamename => game632.name )
			game632.tag_list = "休闲, 2.5D, 道具收费, 竞技, Q版"
			game632.save
game633 = Game.create(
			:name => "剑侠世界海外版",
		      :official_web => "http://jxsj.xoyo.com/",
		      :sale_date => "2008-3-3",
		      :company => "金山西山居",
		      :agent => "金山西山居",
		      :no_races => true,
		      :description => "2D武侠角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 633, :sqlid => game633.id, :gamename => game633.name )
		      game633.tag_list = "热血, 武侠, 角色扮演, 道具收费, 即时战斗, 2D"
			game633.save
game634 = Game.create(
			:name => "剑侠2外传",
			:official_web => "http://jw.xoyo.com/",
			:sale_date => "2009-4-3",
			:company => "金山",
			:agent => "金山",
                        :no_races => true,
			:description => "国产2D武侠玄幻角色扮演网游")
Gameswithhole.create( :txtid => 634, :sqlid => game634.id, :gamename => game634.name )
			game634.tag_list = "武侠, 2D, 道具收费, 即时战斗, 热血"
			game634.save
game635 = Game.create(
			:name => "QQ英雄岛",
			:official_web => "http://yxd.21mmo.com/",
			:sale_date => "2009-7-10",
			:company => "深圳网域",
			:agent => "腾讯",
                        :no_races => true,
                        :no_professions => true,
			:description => "大型卡通风格的战略RPG新形态网络游戏")
Gameswithhole.create( :txtid => 635, :sqlid => game635.id, :gamename => game635.name )
			game635.tag_list = "休闲, 3D, 道具收费, 策略, Q版"
			game635.save
game637 = Game.create(
			:name => "泡泡岛",
			:official_web => "http://ppd.sdo.com/",
			:sale_date => "2007-12-28",
			:company => "盛大",
			:agent => "盛大",
                        :no_races => true,
                        :no_professions => true,
			:description => "Q版竞技类休闲网游")
Gameswithhole.create( :txtid => 637, :sqlid => game637.id, :gamename => game637.name )
			game637.tag_list = "休闲, 2D, 竞技, Q版"
			game637.save
game638 = Game.create(
			:name => "魔骑士OL",
			:official_web => "http://mqs.176.com/",
			:sale_date => "2009-12-10",
			:company => "福州天盟数码",
			:agent => "福州天盟数码",
			:description => "国产西方魔幻回合制网游")
Gameswithhole.create( :txtid => 638, :sqlid => game638.id, :gamename => game638.name )
			game638.tag_list = "奇幻, 2D, 回合制战斗, 热血"
			game638.save
game639 = Game.create(
			:name => "魔力宝贝2（台服）",
			:official_web => "http://cg2.uj.com.tw/",
		      :sale_date => "2008-11-1",
		      :company => "SQUARE ENIX",
		      :agent => "久游网",
		      :no_races => true,
		      :description => "3D半即时制角色扮演游戏")
Gameswithhole.create( :txtid => 639, :sqlid => game639.id, :gamename => game639.name )
		      	game639.tag_list = "Q版, 奇幻, 角色扮演, 道具收费, 半即时制战斗, 3D"
			game639.save
game641 = Game.create(
			:name => "江湖行",
			:official_web => "http://jhx.skdaren.com/",
			:sale_date => "2010-3-18",
			:company => "盛科达人",
			:agent => "盛科达人",
                        :no_races => true,
                        :no_professions => true,
			:description => "国产2D大型多人在线角色扮演类网游")
Gameswithhole.create( :txtid => 641, :sqlid => game641.id, :gamename => game641.name )
			game641.tag_list = "武侠, 2D, 道具收费, 即时战斗, 热血"
			game641.save
game642 = Game.create(
			:name => "纳雅外传",
			:official_web => "http://nywz.hitogame.com/",
			:sale_date => "2009-9-28",
			:company => "华游网络",
			:agent => "华游网络",
                        :no_races => true,
			:description => "国产3D回合制角色扮演网戏")
Gameswithhole.create( :txtid => 642, :sqlid => game642.id, :gamename => game642.name )
			game642.tag_list = "奇幻, 3D, 道具收费, 回合制战斗, 休闲"
			game642.save
game644 = Game.create(
			:name => "天堂2(台服)",
			:official_web => "http://lineage2.plaync.com.tw/",
		  :sale_date => "2004-9-8",
		  :company => "Ncsoft",
		  :agent => "Ncsoft",
		  :no_areas => true,
		  :description => "韩国大型角色扮演游戏")
Gameswithhole.create( :txtid => 644, :sqlid => game644.id, :gamename => game644.name )
		  game644.tag_list = "热血, 奇幻, 角色扮演, 时间收费, 道具收费, 即时战斗, 2D"
			game644.save
game645 = Game.create(
			:name => "QQ封神记",
			:official_web => "http://fs.qq.com/",
			:sale_date => "2010-3-1",
			:company => "腾讯",
			:agent => "腾讯",
			:description => "中国神话玄幻横板过关网游")
Gameswithhole.create( :txtid => 645, :sqlid => game645.id, :gamename => game645.name )
			game645.tag_list = "中国玄幻, 2D, 道具收费, 横板战斗, 热血"
			game645.save
game646 = Game.create(
			:name => "东邪西毒",
			:official_web => "http://dxxd.linekong.com/",
			:sale_date => "2010-1-7",
			:company => "蓝港在线",
			:agent => "蓝港在线",
			:description => "中国武侠题材融合玄幻元素的MMORPG网游")
Gameswithhole.create( :txtid => 646, :sqlid => game646.id, :gamename => game646.name )
			game646.tag_list = "武侠, 2D, 即时战斗, 热血"
			game646.save
game647 = Game.create(
			:name => "光之冒险OL",
			:official_web => "http://mx.10sea.com/swf/main.html",
			:sale_date => "2010-4-19",
			:company => "Entwell",
			:agent => "天希网络",
                        :no_races => true,
			:description => "Q版角色扮演新型冒险游戏")
Gameswithhole.create( :txtid => 647, :sqlid => game647.id, :gamename => game647.name )
			game647.tag_list = "休闲, 2.5D, 即时战斗, Q版"
			game647.save
game648 = Game.create(
			:name => "武林群侠传",
		      :official_web => "http://50.catv.net/",
		      :sale_date => "2005-7-11",
		      :company => "中华网龙",
		      :agent => "中广网",
		      :no_races => true,
		      :description => "大型3D角色扮演游戏")
Gameswithhole.create( :txtid => 648, :sqlid => game648.id, :gamename => game648.name )
		      	game648.tag_list = "史诗, 武侠, 角色扮演, 道具收费, 即时战斗, 3D"
			game648.save
game649 = Game.create(
			:name => "天之痕OL",
			:official_web => "http://tzh.ferrygame.com/v2/default.php",
			:sale_date => "2009-12-1",
			:company => "渡口网络",
			:agent => "渡口网络",
                        :no_races => true,
			:description => "国产3D水墨风格MMORPG网络游戏")
Gameswithhole.create( :txtid => 649, :sqlid => game649.id, :gamename => game649.name )
			game649.tag_list = "武侠, 3D, 即时战斗, 史诗"
			game649.save
game650 = Game.create(
			:name => "K1拳霸天下",
			:official_web => "http://k1.9igame.com/",
			:sale_date => "2009-12-23",
			:company => "上海艺为网络科技有限公司",
			:agent => "上海艺为网络科技有限公司",
                        :no_races => true,
			:description => "国产2.5D热血格斗网游")
Gameswithhole.create( :txtid => 650, :sqlid => game650.id, :gamename => game650.name )
			game650.tag_list = "休闲, 2.5D, 横板战斗, 热血"
			game650.save
game651 = Game.create(
			:name => "新江湖OL",
			:official_web => "http://www.jianghuol.com/",
			:sale_date => "2006-8-10",
			:company => "88科技",
			:agent => "88科技",
                        :no_races => true,
			:description => "国产3D武侠角色多人在线网游")
Gameswithhole.create( :txtid => 651, :sqlid => game651.id, :gamename => game651.name )
			game651.tag_list = "武侠, 3D, 道具收费, 即时战斗, 热血"
			game651.save
game652 = Game.create(
			:name => "UU赛艇",
			:official_web => "http://uu.sntaro.com/",
			:sale_date => "2009-6-25",
			:company => "北京圣天龙科技有限公司",
			:agent => "北京圣天龙科技有限公司",
                        :no_races => true,
                        :no_professions => true,
			:description => "国产3D赛艇竞技休闲网游")
Gameswithhole.create( :txtid => 652, :sqlid => game652.id, :gamename => game652.name )
			game652.tag_list = "运动, 3D, 赛艇, 轻松"
			game652.save
game653 = Game.create(
			:name => "晶铁之门",
			:official_web => "http://www.jtzmol.com/WebSite/web/main.html",
			:sale_date => "2010-2-25",
			:company => "汉舟软件",
			:agent => "汉舟软件",
			:description => "国产3D多人在线大型角色扮演网游")
Gameswithhole.create( :txtid => 653, :sqlid => game653.id, :gamename => game653.name )
			game653.tag_list = "奇幻, 3D, 时间或道具收费, 即时战斗, 热血"
			game653.save
game654 = Game.create(
			:name => "千秋霸业",
			:official_web => "http://qqby.zqgame.com/",
			:sale_date => "2010-3-24" ,
			:company => "中青宝网",
			:agent => "中青宝网",
                        :no_races => true,
			:description => "国产热血2D角色扮演网游")
Gameswithhole.create( :txtid => 654, :sqlid => game654.id, :gamename => game654.name )
			game654.tag_list = "战争, 2D, 即时战斗, 热血"
			game654.save
game655 = Game.create(
			:name => "赢世界",
			:official_web => "http://www.win086.com/",
			:sale_date => "2009-12-9",
			:company => "泰赢传媒",
			:agent => "泰赢传媒",
                        :no_races => true,
			:description => "3D玄幻角色扮演网游")
Gameswithhole.create( :txtid => 655, :sqlid => game655.id, :gamename => game655.name )
			game655.tag_list = "玄幻, 3D, 道具收费, 即时战斗, 热血"
			game655.save
game656 = Game.create(
			:name => "Monkey",
			:official_web => "monkey.yxqz.com",
			:sale_date => "2010-1-6",
			:company => "成都魔方",
			:agent => "游戏圈子",
			:description => "国产2D西游记文化MMORPG网游")
Gameswithhole.create( :txtid => 656, :sqlid => game656.id, :gamename => game656.name )
			game656.tag_list = "休闲, 2D, 横板战斗, Q版"
			game656.save
game657 = Game.create(
			:name => "魔域(英文版)",
		      :official_web => "http://my.91.com/index/",
		      :sale_date => "2006-3-8",
		      :company => "天晴数码",
		      :agent => "网龙",
		      :no_races => true,
		      :description => "2D奇幻, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 657, :sqlid => game657.id, :gamename => game657.name )
		      	game657.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game657.save
game658 = Game.create(
			:name => "QQ三国",
			:official_web => "http://sg.qq.com/",
			:sale_date => "2007-6-29",
			:company => "腾讯",
			:agent => "腾讯",
                        :no_races => true,
			:description => "国产2D横版MMORPG网络游戏")
Gameswithhole.create( :txtid => 658, :sqlid => game658.id, :gamename => game658.name )
			game658.tag_list = "中国玄幻, 2D, 道具收费, 横板战斗, Q版"
			game658.save
game660 = Game.create(
			:name => "梦回山海",
			:official_web => "http://mhsh.zqgame.com/",
			:sale_date => "2010-3-12",
			:company => "中青宝网",
			:agent => "中青宝网",
                        :no_races => true,
			:description => "国产奇幻2D回合网络游戏")
Gameswithhole.create( :txtid => 660, :sqlid => game660.id, :gamename => game660.name )
			game660.tag_list = "奇幻, 2D, 道具收费, 回合制战斗, Q版"
			game660.save
game661 = Game.create(
			:name => "大战舰",
			:official_web => "http://dzj.sdo.com/web2/home/index.html",
			:sale_date => "2009-5-27",
			:company => "盛大",
			:agent => "盛大",
                        :no_races => true,
                        :no_professions => true,
			:description => "2D战争策略休闲游戏")
Gameswithhole.create( :txtid => 661, :sqlid => game661.id, :gamename => game661.name )
			game661.tag_list = "星战, 2D, 道具收费, 策略, 轻松"
			game661.save
game663 = Game.create(
			:name => "天尊",
			:official_web => "http://www.ooxxplay.com/index.html",
			:sale_date => "2008-8-12",
			:company => "上海唐颂信息",
			:agent => "上海悠扬网络",
                        :no_races => true,
                        :no_professions => true,
			:description => "中国传统仙侠题材的MMORPG")
Gameswithhole.create( :txtid => 663, :sqlid => game663.id, :gamename => game663.name )
			game663.tag_list = "中国玄幻, 3D, 即时战斗, 热血"
			game663.save
game664 = Game.create(
			:name => "新破天一剑",
			:official_web => "http://www.pcikchina.com/",
			:sale_date => "2007-6-15",
			:company => "MAGICS",
			:agent => "北京伙聚联合网络服务有限公司",
			:no_areas => true,
			:description => "韩国2D玄幻角色扮演网游")
Gameswithhole.create( :txtid => 664, :sqlid => game664.id, :gamename => game664.name )
			game664.tag_list = "玄幻, 2D, 道具收费, 回合制战斗, 热血"
			game664.save
game666 = Game.create(
			:name => "QQ飞车",
			:official_web => "http://speed.qq.com/index.shtml",
			:sale_date => "2007-12-15",
			:company => "腾讯",
			:agent => "腾讯",
                        :no_races => true,
                        :no_professions => true,
			:description => "Q版3D时尚飙车休闲互动游戏")
Gameswithhole.create( :txtid => 666, :sqlid => game666.id, :gamename => game666.name )
			game666.tag_list ="运动, 3D, 道具收费, 赛车, 轻松"
			game666.save
game667 = Game.create(
			:name => "轩辕传奇",
			:official_web => "http://xy.qq.com/",
			:sale_date => "2009-11-17",
			:company => "腾讯",
			:agent => "腾讯",
                        :no_races => true,
			:description => "国产玄幻2.5D角色扮演多人在线网游")
Gameswithhole.create( :txtid => 667, :sqlid => game667.id, :gamename => game667.name )
			game667.tag_list = "玄幻, 2.5D, 即时战斗, 史诗"
			game667.save
game668 = Game.create(
			:name => "秦始皇",
			:official_web => "http://qin.gyyx.cn/",
			:sale_date => "2008-12-31",
			:company => "厦门网游网络",
			:agent => "北京光宇在线",
                        :no_races => true,
			:description => "国产2.5D历史玄幻角色扮演网游")
Gameswithhole.create( :txtid => 668, :sqlid => game668.id, :gamename => game668.name )
			game668.tag_list = "中国玄幻, 2.5D, 道具收费, 即时战斗, 热血"
			game668.save
game669 = Game.create(
			:name => "街头拳皇",
			:official_web => "jtqh.hopecool.com",
			:sale_date => "2008-5-18",
			:company => "红图互动",
			:agent => "红图互动",
      :no_races => true,
      :no_professions => true,
			:description => "国产2D横版格斗网游")
Gameswithhole.create( :txtid => 669, :sqlid => game669.id, :gamename => game669.name )
			game669.tag_list = "休闲, 2D, 道具收费, 横板战斗, 热血"
			game669.save
game670 = Game.create(
			:name => "完美世界(台服)",
		      :official_web => "http://world2.wanmei.com/",
		      :sale_date => "2005-11-25",
		      :company => "完美时空",
		      :agent => "完美时空",
		      :no_races => true,
		      :description => "3D神话, 角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 670, :sqlid => game670.id, :gamename => game670.name )
		      	game670.tag_list = "轻松, 神话, 角色扮演, 时间收费, 即时战斗, 3D"
			game670.save
game671 = Game.create(
			:name => "信仰",
			:official_web => "http://xy.91.com/index/",
			:sale_date => "2004-03-01",
			:company => "天晴数码",
			:agent => "网龙",
                        :no_races => true,
			:description => "西方奇幻风格的多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 671, :sqlid => game671.id, :gamename => game671.name )
			game671.tag_list = "奇幻, 3D, 道具收费, 即时战斗, 热血"
			game671.save
game673 = Game.create(
			:name => "武者OL",
			:official_web => "http://wuzhe.sdo.com/",
			:sale_date => "2009-10-19",
			:company => "盛世游",
			:agent => "盛大",
                        :no_races => true,
                        :no_professions => true,
			:description => "国产2D武侠角色扮演网游")
Gameswithhole.create( :txtid => 673, :sqlid => game673.id, :gamename => game673.name )
			game673.tag_list = "武侠, 2D, 道具收费, 即时战斗, 热血"
			game673.save
game674 = Game.create(
			:name => "上古神殿",
			:official_web => "http://sgsd.153001.com/",
			:sale_date => "2010-6-1",
			:company => "金山",
			:agent => "金山",
      :no_races => true,
      :no_professions => true,
			:description => "罗马神话3D MMORPG网游")
Gameswithhole.create( :txtid => 674, :sqlid => game674.id, :gamename => game674.name )
			game674.tag_list = "奇幻, 3D, 即时战斗, 热血"
			game674.save
game676 = Game.create(
			:name => "奇幻西游",
			:official_web => "http://xy.online-game.com.cn/",
			:sale_date => "2009-10-30",
			:company => "龙图智库",
			:agent => "游龙在线",
			:description => "国产神话玄幻2D角色扮演网游")
Gameswithhole.create( :txtid => 676, :sqlid => game676.id, :gamename => game676.name )
			game676.tag_list = "中国玄幻, 2D, 道具收费, 回合制战斗, Q版"
			game676.save
game677 = Game.create(
			:name => "迅雷游戏专区",
			:official_web => "http://webgame.xunlei.com/",
			:sale_date => "2008-4-21",
			:company => "迅雷",
			:agent => "迅雷",
                        :no_races => true,
                        :no_professions => true,
			:description => "迅雷游戏平台")
Gameswithhole.create( :txtid => 677, :sqlid => game677.id, :gamename => game677.name )
			game677.tag_list = "休闲, 游戏平台, 轻松"
			game677.save
game678 = Game.create(
			:name => "封神榜国际版",
		      :official_web => "http://fs.xoyo.com/",
		      :sale_date => "2004-12-16",
		      :company => "金山西山居",
		      :agent => "金山西山居",
		      :no_races => true,
		      :description => "2D大型角色扮演游戏")
Gameswithhole.create( :txtid => 678, :sqlid => game678.id, :gamename => game678.name )
		    	game678.tag_list = "热血, 神话, 角色扮演, 时间收费, 道具收费, 即时战斗, 2D"
			game678.save
game679 = Game.create(
			:name => "天界传说",
			:official_web => "http://xl.gametop.cn/index.html",
			:sale_date => "2010-2-5",
			:company => "游戏巅峰",
			:agent => "游戏巅峰",
                        :no_races => true,
			:description => "2D国产神话玄幻角色扮演网游")
Gameswithhole.create( :txtid => 679, :sqlid => game679.id, :gamename => game679.name )
			game679.tag_list = "神话玄幻, 2D, 道具收费"
			game679.save
game680 = Game.create(
			:name => "瑪奇(台服)",
		      :official_web => "http://luoqi.tiancity.com/homepage/",
		      :sale_date => "2005-06-28",
		      :company => "NEXON",
		      :agent => "世纪天成",
		      :no_races => true,
		      :description => "Q版3D角色扮演游戏")
Gameswithhole.create( :txtid => 680, :sqlid => game680.id, :gamename => game680.name )
		      	game680.tag_list = "Q版, 奇幻, 角色扮演, 道具收费, 即时战斗, 3D"
			game680.save
game681 = Game.create(
			:name => "机甲世纪革新版",
			:official_web => "http://aoa.woniu.com/",
			:sale_date => "2005-8-27",
			:company => "蜗牛",
			:agent => "蜗牛",
			:description => "国产3D角色扮演科幻机械战争网游")
Gameswithhole.create( :txtid => 681, :sqlid => game681.id, :gamename => game681.name )
			game681.tag_list = "科幻, 3D, 道具收费, 即时战斗, 热血"
			game681.save
game683 = Game.create(
			:name => "新天上碑",
			:official_web => "http://www.game176.com/new1003b/",
			:sale_date => "2006-8-1",
			:company => "韩国HiWin公司",
			:agent => "上海盎然信息技术有限公司",
                        :no_races => true,
                        :no_professions => true,
			:description => "武侠类角色扮演网络游戏")
Gameswithhole.create( :txtid => 683, :sqlid => game683.id, :gamename => game683.name )
			game683.tag_list = "武侠, 2D, 计时收费, 即时战斗, 热血"
			game683.save
game685 = Game.create(
			:name => "逍遥游",
			:official_web => "http://pai.starjoys.cn/",
			:sale_date => "2003-1-1",
			:company => "大连星宇网络公司",
			:agent => "大连星宇网络公司",
			:description => "中国第一款神话背景的集换式卡牌网游")
Gameswithhole.create( :txtid => 685, :sqlid => game685.id, :gamename => game685.name )
			game685.tag_list = "棋牌, 2D, 策略, 轻松"
			game685.save
game687 = Game.create(
			:name => "佣兵天下",
			:official_web => "http://yb.linekong.com/",
			:sale_date => "2010-4-15",
			:company => "蓝港在线",
			:agent => "蓝港在线",
			:description => "国产3D玄幻战争史诗角色扮演网游")
Gameswithhole.create( :txtid => 687, :sqlid => game687.id, :gamename => game687.name )
			game687.tag_list = "玄幻, 3D, 角色扮演, 史诗"
			game687.save
game688 = Game.create(
			:name => "龙骑士online",
			:official_web => "http://lqs2.passionent.com/",
			:sale_date => "2007-9-30",
			:company => "上海派讯",
			:agent => "上海派讯",
                        :no_races => true,
			:description => "国产奇幻3DMMORPG角色扮演网游")
Gameswithhole.create( :txtid => 688, :sqlid => game688.id, :gamename => game688.name )
			game688.tag_list = "奇幻, 3D, 道具收费, 即时战斗, 热血"
			game688.save
game689 = Game.create(
			:name => "天龙八部(台服)",
		      :official_web => "http://tl.sohu.com/",
		      :sale_date => "2007-5-9",
		      :company => "搜狐畅游",
		      :agent => "搜狐畅游",
		      :no_races => true,
		      :description => "中国武侠角色扮演类角色扮演游戏")
Gameswithhole.create( :txtid => 689, :sqlid => game689.id, :gamename => game689.name )
		      	game689.tag_list = "史诗, 武侠, 角色扮演, 道具收费, 即时战斗, 3D"
			game689.save
game690 = Game.create(
			:name => "十二天之贰(台服)",
			:official_web => "http://12sky2.gfyoyo.com.cn/new/home/index.aspx",
			:sale_date => "2009-3-18",
			:company => "Gigas Soft",
			:agent => "悠游网",
                        :no_races => true,
			:description => "韩国3DMMORPG网游")
Gameswithhole.create( :txtid => 690, :sqlid => game690.id, :gamename => game690.name )
			game690.tag_list = "玄幻, 3D, 道具收费, 即时战斗, 热血"
			game690.save
game691 = Game.create(
			:name => "传奇3(IS版)",
			:official_web => "http://mir3.gtgame.com.cn/index.html",
			:sale_date => "2003-5-25",
			:company => "Wemade",
			:agent => "光通",
			:no_races => true,
			:description => "3D 大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 691, :sqlid => game691.id, :gamename => game691.name )
			game691.tag_list ="3D,奇幻,热血"
			game691.save
game692 = Game.create(
			:name => "剑痕",
			:official_web => "http://xa.lyjoy.com",
			:sale_date => "2008-11-05",
			:company => "龙游天下",
			:agent => "龙游天下",
                        :no_races => true,
                        :no_professions => true,
			:description => "中国武侠文化为题材的具有独特风格的MMOPRG网游")
Gameswithhole.create( :txtid => 692, :sqlid => game692.id, :gamename => game692.name )
			game692.tag_list = "武侠, 3D, 即时战斗, 热血"
			game692.save
game695 = Game.create(
			:name => "新苍天",
		      :official_web => "http://ct.sdo.com/project/guide0906/default.html",
		      :sale_date => "2008-12-25",
		      :company => "娱美德（Wemade）",
		      :agent => "盛大网络",
		      :no_races => true,
		      :description => "3D三国类大型角色扮演游戏")
Gameswithhole.create( :txtid => 695, :sqlid => game695.id, :gamename => game695.name )
		    	game695.tag_list = "热血, 武侠, 角色扮演, 道具收费, 即时战斗, 3D"
			game695.save
game696 = Game.create(
			:name => "钢甲洪流",
			:official_web => "http://www.woh.com.cn/index.jsp",
			:sale_date => "2006-10-28",
			:company => "冰锋网络",
			:agent => "冰锋网络",
                        :no_races => true,
                        :no_professions => true,
			:description => "MO-PVP-PVP-MG即大型多人在线第一人称射击网游")
Gameswithhole.create( :txtid => 696, :sqlid => game696.id, :gamename => game696.name )
			game696.tag_list = "战争, 3D, 道具收费, 第一人称射击, 仿真"
			game696.save
game697 = Game.create(
			:name => "新传奇3",
			:official_web => "http://mir3.gtgame.com.cn/index.html",
			:sale_date => "2003-5-25",
			:company => "Wemade",
			:agent => "光通",
			:no_races => true,
			:description => "3D 大型多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 697, :sqlid => game697.id, :gamename => game697.name )
			game697.tag_list ="3D,奇幻,热血"
			game697.save
game698 = Game.create(
			:name => "童年OL",
			:official_web => "http://www.52tn.cn/",
			:sale_date => "2007-11-16",
			:company => "海之童",
			:agent => "海之童",
                        :no_races => true,
                        :no_professions => true,
			:description => "Q版回合制3D网游")
Gameswithhole.create( :txtid => 698, :sqlid => game698.id, :gamename => game698.name )
			game698.tag_list = "休闲, 3D, 道具收费, 回合制战斗, Q版"
			game698.save
game699 = Game.create(
			:name => "武侠世界",
			:official_web => "http://www.wo173.com/",
			:sale_date => "2008-9-27",
			:company => "北京红图互动网络",
			:agent => "北京红图互动网络",
                        :no_races => true,
                        :no_professions => true,
			:description => "国产3D角色扮演武侠网游")
Gameswithhole.create( :txtid => 699, :sqlid => game699.id, :gamename => game699.name )
			game699.tag_list = "武侠, 3D, 即时战斗, 热血"
			game699.save
game700 = Game.create(
			:name => "大唐无双",
			:official_web => "http://dt2.163.com/",
			:sale_date => "2009-9-15",
			:company => "网易",
			:agent => "网易",
			:description => "国产2.5D武侠玄幻角色扮演网游")
Gameswithhole.create( :txtid => 700, :sqlid => game700.id, :gamename => game700.name )
			game700.tag_list = "中国玄幻, 2.5D, 即时战斗, 热血"
			game700.save
game701 = Game.create(
			:name => "QQ飞行岛",
			:official_web => "http://nana.qq.com/",
			:sale_date => "2008-1-21",
			:company => "TOPPIG",
			:agent => "腾讯公司",
                        :no_races => true,
                        :no_professions => true,
			:description => "飞行射击休闲网络游戏")
Gameswithhole.create( :txtid => 701, :sqlid => game701.id, :gamename => game701.name )
			game701.tag_list = "休闲, 2D, 道具收费, 横板战斗, 轻松"
			game701.save
game702 = Game.create(
			:name => "洛汗",
			:official_web => "http://rohan.com.cn/",
			:sale_date =>"2010-4-24" ,
			:company => "Geomind",
			:agent => "中青基业",
      :no_races => true,
			:description => "韩国3D奇幻角色扮演网游")
Gameswithhole.create( :txtid => 702, :sqlid => game702.id, :gamename => game702.name )
			game702.tag_list = "奇幻, 3D, 即时战斗, 热血"
			game702.save
game703 = Game.create(
			:name => "苍茫世界",
			:official_web => "http://www.youlegame.com/",
			:sale_date => "2009-8-26",
			:company => "悠乐网络",
			:agent => "悠乐网络",
                        :no_races => true,
			:description => "2D多人在线角色扮演类网游")
Gameswithhole.create( :txtid => 703, :sqlid => game703.id, :gamename => game703.name )
			game703.tag_list = "奇幻, 2D, 道具收费, 即时战斗, 热血"
			game703.save
game705 = Game.create(
			:name => "魔幻世界",
			:official_web => "http://mh.baiyou100.com/",
			:sale_date => "2010-01-25",
			:company => "盛世奥游",
			:agent => "百游",
                        :no_races => true,
			:description => "国外神话3D角色扮演网游")
Gameswithhole.create( :txtid => 705, :sqlid => game705.id, :gamename => game705.name )
			game705.tag_list = "奇幻, 3D, 道具收费, 即时战斗, 史诗"
			game705.save
game706 = Game.create(
			:name => "降龙之剑",
			:official_web => "http://xlzj.wanmei.com/",
			:sale_date => "2010-3-5",
			:company => "完美时空",
			:agent => "完美时空",
			:description => "国产2D即时玄幻武侠网游")
Gameswithhole.create( :txtid => 706, :sqlid => game706.id, :gamename => game706.name )
			game706.tag_list = "玄幻, 2D, 即时战斗, 热血"
			game706.save
game708 = Game.create(
			:name => "圣域传说",
			:official_web => "http://sz.hysmgame.com/",
			:sale_date => "2010-3-18",
			:company => "欢跃数码",
			:agent => "欢跃数码",
			:description => "国产奇幻角色扮演多人在线网游")
Gameswithhole.create( :txtid => 708, :sqlid => game708.id, :gamename => game708.name )
			game708.tag_list = "奇幻, 3D, 道具收费, 即时战斗, 热血"
			game708.save
game709 = Game.create(
			:name => "星座物语",
			:official_web => "http://www.quwanba.com/xzwy.html",
			:sale_date => "2009-07-17",
			:company => "烽火游戏",
			:agent => "烽火游戏",
                        :no_races => true,
			:description => "角色扮演横板战斗网游")
Gameswithhole.create( :txtid => 709, :sqlid => game709.id, :gamename => game709.name )
			game709.tag_list = "奇幻, 2D, 横板, 横板战斗, 热血"
			game709.save
game710 = Game.create(
			:name => "传世群英传",
			:official_web => "http://act.qyz.sdo.com/",
			:sale_date => "2009-12-04",
			:company => "盛大",
			:agent => "盛大",
                        :no_races => true,
			:description => "国产2D MMORPG网游")
Gameswithhole.create( :txtid => 710, :sqlid => game710.id, :gamename => game710.name )
			game710.tag_list = "武侠玄幻, 2D, 道具收费, 即时战斗, 热血"
			game710.save
game712 = Game.create(
			:name => "鬼吹灯OL",
			:official_web => "http://gui.uqugame.com/index.shtml",
			:sale_date => "2009-10-19",
			:company => "上海游趣网络科技有限公司",
			:agent => "上海游趣网络科技有限公司",
                        :no_races => true,
			:description => "国产奇幻3D多人在线角色扮演游戏")
Gameswithhole.create( :txtid => 712, :sqlid => game712.id, :gamename => game712.name )
			game712.tag_list = "奇幻, 3D, 即时战斗, 热血"
			game712.save
game713 = Game.create(
			:name => "神墓OL",
			:official_web => "http://www.shenmupk.com/",
			:sale_date => "2010-1-22",
			:company => "边城游侠",
			:agent => "边城游侠",
			:description => "国产玄幻多人在线角色扮演类网络游戏")
Gameswithhole.create( :txtid => 713, :sqlid => game713.id, :gamename => game713.name )
			game713.tag_list = "神话玄幻, 2D, 即时战斗, 热血"
			game713.save
game714 = Game.create(
			:name => "网球宝贝",
			:official_web => "http://wq.mangogame.com/",
			:sale_date => "2009-7-15",
			:company => "中娱在线",
			:agent => "中娱在线",
                        :no_races => true,
                        :no_professions => true,
			:description => "国产网球体育运动网游")
Gameswithhole.create( :txtid => 714, :sqlid => game714.id, :gamename => game714.name )
			game714.tag_list = "运动, 2D, 道具收费, 网球, 轻松"
			game714.save
game715 = Game.create(
			:name => "乱世枭雄",
			:official_web => "http://www.yyyt.com/",
			:sale_date => "2007-10-15",
			:company => "广州浩动网络科技有限公司",
			:agent => "广州浩动网络科技有限公司",
			:description => "国产2D武侠玄幻角色扮演网游")
Gameswithhole.create( :txtid => 715, :sqlid => game715.id, :gamename => game715.name )
			game715.tag_list = "中国玄幻, 2D, 道具收费, 即时战斗, 热血"
			game715.save
game716 = Game.create(
			:name => "魔法火枪团",
			:official_web => "http://mf.163.com/",
			:sale_date => "2008-4-15",
			:company => "网易",
			:agent => "网易",
                        :no_races => true,
                        :no_professions => true,
			:description => "国产2D运动休闲射击网玩")
Gameswithhole.create( :txtid => 716, :sqlid => game716.id, :gamename => game716.name )
			game716.tag_list = "休闲, 2D, 道具收费, 横板战斗, 轻松"
			game716.save
game717 = Game.create(
			:name => "上海滩",
			:official_web => "http://www.shtgame.com/",
			:sale_date => "2009-12-11",
			:company => "青岛玩谷网络科技有限公司",
			:agent => "山东万佳网络文化有限公司",
			:description => "国产2D怀旧角色扮演网游")
Gameswithhole.create( :txtid => 717, :sqlid => game717.id, :gamename => game717.name )
			game717.tag_list = "怀旧, 2D, 道具收费, 即时战斗, 热血"
			game717.save
game718 = Game.create(
			:name => "风雨寻秦",
			:official_web => "http://xq.zhaouc.net/",
			:sale_date => "2009-10-15",
			:company => "壮游科技",
			:agent => "壮游科技",
			:description => "国产武侠玄幻角色扮演多人在线网游")
Gameswithhole.create( :txtid => 718, :sqlid => game718.id, :gamename => game718.name )
			game718.tag_list = "中国玄幻, 2D, 道具收费, 即时战斗, 热血"
			game718.save
game719 = Game.create(
			:name => "完美世界前传",
		      :official_web => "http://world2.wanmei.com/",
		      :sale_date => "2005-11-25",
		      :company => "完美时空",
		      :agent => "完美时空",
		      :no_races => true,
		      :description => "3D神话角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 719, :sqlid => game719.id, :gamename => game719.name )
		      	game719.tag_list = "轻松, 神话, 角色扮演, 时间收费, 即时战斗, 3D"
			game719.save
game720 = Game.create(
			:name => "黄易群侠传（台服）",
		      :official_web => "http://hy.iyoyo.com.cn/",
		      :sale_date => "2007-8-3",
		      :company => "中华网龙",
		      :agent => "悠游网",
		      :no_races => true,
		      :description => "国产3D大型角色扮演游戏")
Gameswithhole.create( :txtid => 720, :sqlid => game720.id, :gamename => game720.name )
		    	game720.tag_list = "热血, 神话, 角色扮演, 道具收费, 即时战斗, 3D"
			game720.save
game721 = Game.create(
			:name => "幻想之翼",
			:official_web => "http://fw.gyyx.cn/",
			:sale_date => "2009-3-13",
			:company => "蓝火炬软件",
			:agent => "光宇在线",
                        :no_races => true,
			:description => "国产2D科幻第三人称视角的飞行射击网络游戏")
Gameswithhole.create( :txtid => 721, :sqlid => game721.id, :gamename => game721.name )
			game721.tag_list ="科幻, 2D, 射击, 轻松"
			game721.save
game722 = Game.create(
			:name => "永久基地",
			:official_web => "http://www.19base.com",
			:sale_date => "2010-1-30",
			:company => "武汉天赋",
			:agent => "武汉天赋",
			:description => "国产科幻2DMMORPG网游")
Gameswithhole.create( :txtid => 722, :sqlid => game722.id, :gamename => game722.name )
			game722.tag_list = "科幻, 2D, 即时战斗, 热血"
			game722.save
game723 = Game.create(
			:name => "争霸OL",
			:official_web => "http://www.zb-game.cn/",
			:sale_date => "2009-6-26",
			:company => "傲天科技",
			:agent => "傲天科技",
			:description => "国产玄幻2D角色扮演多人在线网游")
Gameswithhole.create( :txtid => 723, :sqlid => game723.id, :gamename => game723.name )
			game723.tag_list = "玄幻, 2D, 即时战斗, 热血"
			game723.save
game724 = Game.create(
			:name => "预言OL怀旧版",
		      :official_web => "http://www.yuyan.com/",
		      :sale_date => "2008-4-29",
		      :company => "暴雨信息",
		      :agent => "暴雨信息",
		      :no_races => true,
		      :description => "2D奇幻角色扮演角色扮演游戏")
Gameswithhole.create( :txtid => 724, :sqlid => game724.id, :gamename => game724.name )
		  game724.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 即时战斗, 2D"
			game724.save
game725 = Game.create(
			:name => "挑战",
			:official_web => "http://www.dkonline.com.cn/games/dk/intro.htm",
			:sale_date => "2008-10-23",
			:company => "韩国gamehi",
			:agent => "盟邦上海",
      :no_races => true,
			:description => "韩国3D角色扮演MMORPG多人在线网游")
Gameswithhole.create( :txtid => 725, :sqlid => game725.id, :gamename => game725.name )
			game725.tag_list ="玄幻, 3D, 即时战斗, 热血"
			game725.save
game726 = Game.create(
			:name => "聊斋",
			:official_web => "http://lz.798game.com/",
			:sale_date => "2009-6-20",
			:company => "798GAME",
			:agent => "798GAME",
      :no_races => true,
      :no_professions => true,
			:description => "以中国古代文化为背景的Q版大型3D多人在线网络游戏")
Gameswithhole.create( :txtid => 726, :sqlid => game726.id, :gamename => game726.name )
			game726.tag_list = "Q版, 3D, 即时战斗, 轻松"
			game726.save
game728 = Game.create(
			:name => "启程",
			:official_web => "http://www.iqicheng.com/",
			:sale_date => "2008-09-22",
			:company => "飓风闪达",
			:agent => "飓风闪达",
      :no_races => true,
      :no_professions => true,
			:description => "奇幻历险唯美3DMMORPG角色扮演游戏")
Gameswithhole.create( :txtid => 728, :sqlid => game728.id, :gamename => game728.name )
			game728.tag_list = "奇幻, 3D, 即时战斗, 热血"
			game728.save
game729 = Game.create(
			:name => "圣战传奇",
			:official_web => "http://www.xuetiangame.com:81/szcq/main.html",
			:sale_date => "2009-6-27",
			:company => "雪天网络",
			:agent => "我搜网络",
                        :no_races => true,
                        :no_professions => true,
			:description => "2D科学幻想探索类MMORPG游戏")
Gameswithhole.create( :txtid => 729, :sqlid => game729.id, :gamename => game729.name )
			game729.tag_list = "科幻, 2D, 道具收费, 即时战斗, 热血"
			game729.save
game730 = Game.create(
			:name => "西游天下",
			:official_web => "xy.hxage.com",
			:sale_date => "2010-3-10",
			:company => "幻想时代",
			:agent => "幻想时代",
                        :no_races => true,
			:description => "国产奇幻3D角色扮演网游")
Gameswithhole.create( :txtid => 730, :sqlid => game730.id, :gamename => game730.name )
			game730.tag_list = "中国玄幻, 3D, 即时战斗, 热血"
			game730.save
game732 = Game.create(
			:name => "九界",
			:official_web => "http://9j.21mmo.com/",
			:sale_date => "2008-8-27(大陆)",
			:company => "网域",
			:agent => "网域",
                        :no_races => true,
			:description => "大型3D玄幻角色扮演多人在线的网游")
Gameswithhole.create( :txtid => 732, :sqlid => game732.id, :gamename => game732.name )
			game732.tag_list = "中国玄幻, 3D, 即时战斗, 轻松"
			game732.save
game733 = Game.create(
			:name => "王者世界(台服)",
		      :official_web => "http://at.the9.com/",
		      :sale_date => "2009-6-10",
		      :company => "Ndoors",
		      :agent => "第九城市",
		      :no_races => true,
		      :description => "3D回合制策略型角色扮演游戏")
Gameswithhole.create( :txtid => 733, :sqlid => game733.id, :gamename => game733.name )
		      	game733.tag_list = "热血, 奇幻, 角色扮演, 道具收费, 回合制战斗, 3D"
			game733.save
game734 = Game.create(
			:name => "新战国英雄",
			:official_web => "http://zg.zqgame.com/",
			:sale_date => "2008-4-9",
			:company => "宝德网络",
			:agent => "宝德网络",
                        :no_races => true,
			:description => "国产MMORPG多人在线角色扮演网游")
Gameswithhole.create( :txtid => 734, :sqlid => game734.id, :gamename => game734.name )
			game734.tag_list = "中国玄幻, 2D, 道具收费, 即时战斗, 热血"
			game734.save
game735 = Game.create(
			:name => "CDC侠义道",
			:official_web => "http://xyd.cdcgames.net/",
			:sale_date => "2009-6-26",
			:company => "中华网游戏集团",
			:agent => "中华网游戏集团",
                        :no_races => true,
			:description => "国产武侠江湖角色扮演网游")
Gameswithhole.create( :txtid => 735, :sqlid => game735.id, :gamename => game735.name )
			game735.tag_list = "武侠, 2D, 道具收费, 即时战斗, 热血"
			game735.save
game736 = Game.create(
			:name => "热力排球",
			:official_web => "pq.yetime.cn",
			:sale_date =>"2008-7-28" ,
			:company => "中游",
			:agent => "易当网络",
      :no_races => true,
      :no_professions => true,
			:description => "3D运动竞技类休闲网游")
Gameswithhole.create( :txtid => 736, :sqlid => game736.id, :gamename => game736.name )
			game736.tag_list = "运动, 3D, 道具收费, 沙滩排球, 热血"
			game736.save
game738 = Game.create(
			:name => "恋爱盒子OL",
			:official_web => "http://love.online-game.com.cn/",
			:sale_date => "2006-8-30",
			:company => "龙图智库",
			:agent => "游龙在线",
      :no_races => true,
      :no_professions => true,
			:description => "恋爱交友网络游戏")
Gameswithhole.create( :txtid => 738, :sqlid => game738.id, :gamename => game738.name )
			game738.tag_list = "休闲, 2D, 道具收费, 养成经营, Q版"
			game738.save
game739 = Game.create(
			:name => "精灵牧场",
			:official_web => "http://mc.163.com/",
			:sale_date =>"2010-2-3" ,
			:company => "网易",
			:agent => "网易",
      :no_races => true,
      :no_professions => true,
			:description => "国产欧式Q版角色扮演网游")
Gameswithhole.create( :txtid => 739, :sqlid => game739.id, :gamename => game739.name )
			game739.tag_list = "休闲, 3D, 回合制战斗, Q版"
			game739.save
game740 = Game.create(
			:name => "起源",
			:official_web => "http://qy.qs198.com/",
			:sale_date => "2008-1-18",
			:company => "启盛数码",
			:agent => "启盛数码",
      :no_races => true,
			:description => "国产3D角色扮演网游")
Gameswithhole.create( :txtid => 740, :sqlid => game740.id, :gamename => game740.name )
			game740.tag_list = "奇幻, 3D, 道具收费, 即时战斗, 热血"
			game740.save
	end

  def self.down
		Game.delete_all("id > 319")
		Gameswithhole.delete_all("sqlid > 319")
  end
end
