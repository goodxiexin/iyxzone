class AddProfessionAndRace < ActiveRecord::Migration
  def self.up
		GameProfession.delete_all("game_id > 319")
		GameRace.delete_all("game_id > 319")

GameRace.create(
        :name => "美兰纳",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameRace.create(
        :name => "瑞恩",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "剑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "圣骑士",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "狂战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "神射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "传道士",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "黑暗牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "魔教徒",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameProfession.create(
        :name => "魔战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 357]).sqlid )
GameRace.create(
        :name => "人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 352]).sqlid )
GameRace.create(
        :name => "人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 352]).sqlid )
GameProfession.create(
        :name => "方寸山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 352]).sqlid )
GameProfession.create(
        :name => "普陀山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 352]).sqlid )
GameProfession.create(
        :name => "五庄观",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 352]).sqlid )
GameProfession.create(
        :name => "大雪山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 352]).sqlid )
GameProfession.create(
        :name => "仙族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 552]).sqlid )
GameProfession.create(
        :name => "魔族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 552]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 697]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 697]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 697]).sqlid )
GameRace.create(
        :name => "秦",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameRace.create(
        :name => "赵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameRace.create(
        :name => "楚",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameRace.create(
        :name => "燕",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameRace.create(
        :name => "魏",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameRace.create(
        :name => "齐",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameRace.create(
        :name => "韩",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameProfession.create(
        :name => "骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameProfession.create(
        :name => "谋士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 718]).sqlid )
GameProfession.create(
        :name => "白羊座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "金牛座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "双子座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "巨蟹座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "狮子座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "处女座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "天平座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "天蝎座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "射手座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "摩羯座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "水瓶座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "双鱼座",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 331]).sqlid )
GameProfession.create(
        :name => "剑圣",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "大剑师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "剑魔",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "灵能者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "操魔师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "妖术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "战巫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "大法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "巫妖",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "战将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "狂魔",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "斗狂",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "圣斗士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "诗人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "杀手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "圣骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "龙骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "暗骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "圣者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "智者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "邪魔",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "主教",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "长老",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "妖神",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "法王",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "大祭司",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "妖祭司",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 513]).sqlid )
GameProfession.create(
        :name => "蜀山派",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 358]).sqlid )
GameProfession.create(
        :name => "炎魔罗",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 358]).sqlid )
GameProfession.create(
        :name => "风灵岛",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 358]).sqlid )
GameProfession.create(
        :name => "幽冥宫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 358]).sqlid )
GameRace.create(
        :name => "人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 676]).sqlid )
GameRace.create(
        :name => "仙族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 676]).sqlid )
GameRace.create(
        :name => "魔族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 676]).sqlid )
GameProfession.create(
        :name => "普陀山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 676]).sqlid )
GameProfession.create(
        :name => "五庄观",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 676]).sqlid )
GameProfession.create(
        :name => "大唐官府",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 676]).sqlid )
GameProfession.create(
        :name => "方寸山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 676]).sqlid )
GameProfession.create(
        :name => "魔王寨",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 676]).sqlid )
GameProfession.create(
        :name => "盘丝洞",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 676]).sqlid )
GameProfession.create(
        :name => "中华楼",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 418]).sqlid )
GameProfession.create(
        :name => "黑龙会",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 418]).sqlid )
GameProfession.create(
        :name => "地狱门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 418]).sqlid )
GameProfession.create(
        :name => "昆仑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 443]).sqlid )
GameProfession.create(
        :name => "蓬莱",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 443]).sqlid )
GameProfession.create(
        :name => "蜀山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 443]).sqlid )
GameRace.create(
        :name => "人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameRace.create(
        :name => "精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameRace.create(
        :name => "矮人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameRace.create(
        :name => "巨人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameRace.create(
        :name => "血族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameProfession.create(
        :name => "火枪手",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameProfession.create(
        :name => "牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameProfession.create(
        :name => "吟游诗人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameProfession.create(
        :name => "守护者",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameProfession.create(
        :name => "血魔",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 379]).sqlid )
GameRace.create(
        :name => "瑞",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 323]).sqlid )
GameRace.create(
        :name => "宣",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 323]).sqlid )
GameRace.create(
        :name => "庆",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 323]).sqlid )
GameRace.create(
        :name => "盛",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 323]).sqlid )
GameProfession.create(
        :name => "将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 323]).sqlid )
GameProfession.create(
        :name => "侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 323]).sqlid )
GameProfession.create(
        :name => "道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 323]).sqlid )
GameProfession.create(
        :name => "药",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 323]).sqlid )
GameRace.create(
        :name => "唐军",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameRace.create(
        :name => "义军",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameProfession.create(
        :name => "少林",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameProfession.create(
        :name => "侠隐岛",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameProfession.create(
        :name => "百花医系",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameProfession.create(
        :name => "百花蛊系",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameProfession.create(
        :name => "无名庄",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameProfession.create(
        :name => "蜀山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameProfession.create(
        :name => "天煞盟",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameProfession.create(
        :name => "寒冰门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 700]).sqlid )
GameProfession.create(
        :name => "蓬莱",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 679]).sqlid )
GameProfession.create(
        :name => "昆仑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 679]).sqlid )
GameProfession.create(
        :name => "蜀山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 679]).sqlid )
GameRace.create(
        :name => "天地派",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 717]).sqlid )
GameRace.create(
        :name => "铜雀门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 717]).sqlid )
GameRace.create(
        :name => "青龙帮",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 717]).sqlid )
GameRace.create(
        :name => "白虎堂",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 717]).sqlid )
GameProfession.create(
        :name => "刀客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 717]).sqlid )
GameProfession.create(
        :name => "弩手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 717]).sqlid )
GameProfession.create(
        :name => "旁门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 717]).sqlid )
GameProfession.create(
        :name => "金刚",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 712]).sqlid )
GameProfession.create(
        :name => "葬影",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 712]).sqlid )
GameProfession.create(
        :name => "狙击手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 712]).sqlid )
GameProfession.create(
        :name => "突击兵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 712]).sqlid )
GameProfession.create(
        :name => "寻龙师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 712]).sqlid )
GameProfession.create(
        :name => "唤虫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 712]).sqlid )
GameRace.create(
        :name => "青林",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameRace.create(
        :name => "云泽",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameRace.create(
        :name => "牧原",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameRace.create(
        :name => "沛水",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameRace.create(
        :name => "古岳",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameRace.create(
        :name => "凌风",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameProfession.create(
        :name => "猎手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 629]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 614]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 614]).sqlid )
GameProfession.create(
        :name => "斥候",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 614]).sqlid )
GameProfession.create(
        :name => "乐师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 614]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 378]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 378]).sqlid )
GameProfession.create(
        :name => "道具师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 378]).sqlid )
GameProfession.create(
        :name => "火枪手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 378]).sqlid )
GameProfession.create(
        :name => "元素师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 378]).sqlid )
GameProfession.create(
        :name => "暗黑巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 688]).sqlid )
GameProfession.create(
        :name => "精灵游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 688]).sqlid )
GameProfession.create(
        :name => "祭司",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 688]).sqlid )
GameProfession.create(
        :name => "圣骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 688]).sqlid )
GameProfession.create(
        :name => "死亡骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 688]).sqlid )
GameRace.create(
        :name => "桃花岛",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameRace.create(
        :name => "白驼山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameRace.create(
        :name => "大理段氏",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameRace.create(
        :name => "丐帮",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameRace.create(
        :name => "全真教",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "霜凌",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "落英",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "魅影",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "毒灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "正阳",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "慈光",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "降龙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "伏虎",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "玄虚",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "悟修",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 646]).sqlid )
GameProfession.create(
        :name => "神族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 458]).sqlid )
GameProfession.create(
        :name => "人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 458]).sqlid )
GameProfession.create(
        :name => "魔族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 458]).sqlid )
GameProfession.create(
        :name => "军士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 620]).sqlid )
GameProfession.create(
        :name => "山贼",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 620]).sqlid )
GameProfession.create(
        :name => "武师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 620]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 620]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 631]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 631]).sqlid )
GameProfession.create(
        :name => "文官",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 631]).sqlid )
GameProfession.create(
        :name => "百战营",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 606]).sqlid )
GameProfession.create(
        :name => "飞燕阁",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 606]).sqlid )
GameProfession.create(
        :name => "神农谷",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 606]).sqlid )
GameProfession.create(
        :name => "天玑观",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 606]).sqlid )
GameProfession.create(
        :name => "神秘骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 567]).sqlid )
GameProfession.create(
        :name => "风之冒险家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 567]).sqlid )
GameProfession.create(
        :name => "水精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 567]).sqlid )
GameProfession.create(
        :name => "土精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 567]).sqlid )
GameRace.create(
        :name => "轩辕族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 645]).sqlid )
GameRace.create(
        :name => "女娲族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 645]).sqlid )
GameRace.create(
        :name => "蚩尤族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 645]).sqlid )
GameRace.create(
        :name => "神农族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 645]).sqlid )
GameRace.create(
        :name => "天玑族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 645]).sqlid )
GameProfession.create(
        :name => "御剑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 645]).sqlid )
GameProfession.create(
        :name => "道玄",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 645]).sqlid )
GameProfession.create(
        :name => "狂刃",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 645]).sqlid )
GameProfession.create(
        :name => "天羽",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 645]).sqlid )
GameProfession.create(
        :name => "猛将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 347]).sqlid )
GameProfession.create(
        :name => "豪杰",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 347]).sqlid )
GameProfession.create(
        :name => "军师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 347]).sqlid )
GameProfession.create(
        :name => "方士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 347]).sqlid )
GameProfession.create(
        :name => "弹道专家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 721]).sqlid )
GameProfession.create(
        :name => "据点技师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 721]).sqlid )
GameProfession.create(
        :name => "幻影刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 721]).sqlid )
GameProfession.create(
        :name => "猛将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 347]).sqlid )
GameProfession.create(
        :name => "豪杰",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 347]).sqlid )
GameProfession.create(
        :name => "军师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 347]).sqlid )
GameProfession.create(
        :name => "方士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 347]).sqlid )
GameRace.create(
        :name => "艾米帝国",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 687]).sqlid )
GameRace.create(
        :name => "神圣教廷",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 687]).sqlid )
GameRace.create(
        :name => "休斯帝国",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 687]).sqlid )
GameProfession.create(
        :name => "大剑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 687]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 687]).sqlid )
GameProfession.create(
        :name => "兽人战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 687]).sqlid )
GameProfession.create(
        :name => "魔剑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 687]).sqlid )
GameProfession.create(
        :name => "邪魔",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 687]).sqlid )
GameProfession.create(
        :name => "牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 687]).sqlid )
GameProfession.create(
        :name => "剑仙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 453]).sqlid )
GameProfession.create(
        :name => "月神",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 453]).sqlid )
GameProfession.create(
        :name => "日神",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 453]).sqlid )
GameProfession.create(
        :name => "珠仙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 453]).sqlid )
GameProfession.create(
        :name => "灵者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 453]).sqlid )
GameProfession.create(
        :name => "九黎",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 493]).sqlid )
GameProfession.create(
        :name => "烈山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 493]).sqlid )
GameProfession.create(
        :name => "帝鸿",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 493]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 710]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 710]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 710]).sqlid )
GameProfession.create(
        :name => "风舞者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 332]).sqlid )
GameProfession.create(
        :name => "狂战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 332]).sqlid )
GameProfession.create(
        :name => "神传道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 332]).sqlid )
GameProfession.create(
        :name => "邪灵术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 332]).sqlid )
GameProfession.create(
        :name => "邢天",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 432]).sqlid )
GameProfession.create(
        :name => "太白",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 432]).sqlid )
GameProfession.create(
        :name => "菩提",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 432]).sqlid )
GameProfession.create(
        :name => "后羿",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 432]).sqlid )
GameProfession.create(
        :name => "狂斗士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 430]).sqlid )
GameProfession.create(
        :name => "守卫者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 430]).sqlid )
GameProfession.create(
        :name => "元素制裁者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 430]).sqlid )
GameProfession.create(
        :name => "风暴术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 430]).sqlid )
GameProfession.create(
        :name => "祭祀",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 430]).sqlid )
GameProfession.create(
        :name => "狂野",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 740]).sqlid )
GameProfession.create(
        :name => "勇气",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 740]).sqlid )
GameProfession.create(
        :name => "太阳",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 740]).sqlid )
GameProfession.create(
        :name => "月亮",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 740]).sqlid )
GameProfession.create(
        :name => "火焰",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 740]).sqlid )
GameProfession.create(
        :name => "海洋",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 740]).sqlid )
GameProfession.create(
        :name => "生命",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 740]).sqlid )
GameProfession.create(
        :name => "幽冥",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 740]).sqlid )
GameProfession.create(
        :name => "Maria",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 393]).sqlid )
GameProfession.create(
        :name => "Tom",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 393]).sqlid )
GameProfession.create(
        :name => "Tina",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 393]).sqlid )
GameProfession.create(
        :name => "Chris",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 393]).sqlid )
GameProfession.create(
        :name => "Vivian",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 393]).sqlid )
GameProfession.create(
        :name => "Jerry",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 393]).sqlid )
GameProfession.create(
        :name => "勇士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 501]).sqlid )
GameProfession.create(
        :name => "药师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 501]).sqlid )
GameProfession.create(
        :name => "咒师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 501]).sqlid )
GameProfession.create(
        :name => "羽箭",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 501]).sqlid )
GameProfession.create(
        :name => "武修",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 349]).sqlid )
GameProfession.create(
        :name => "禅修",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 349]).sqlid )
GameProfession.create(
        :name => "灵修",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 349]).sqlid )
GameRace.create(
        :name => "轩辕",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameRace.create(
        :name => "九黎",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameRace.create(
        :name => "蓬莱",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "剑客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "相士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "医生",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "巫人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "武师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "仙使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 375]).sqlid )
GameProfession.create(
        :name => "修罗",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 470]).sqlid )
GameProfession.create(
        :name => "矮人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 470]).sqlid )
GameProfession.create(
        :name => "精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 470]).sqlid )
GameProfession.create(
        :name => "ÄŠÌì",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 654]).sqlid )
GameProfession.create(
        :name => "ŽÌ¿Í",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 654]).sqlid )
GameProfession.create(
        :name => "¹í¹È",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 654]).sqlid )
GameProfession.create(
        :name => "Óùôá",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 654]).sqlid )
GameProfession.create(
        :name => "ÑýŒ§",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 654]).sqlid )
GameProfession.create(
        :name => "斗士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 512]).sqlid )
GameProfession.create(
        :name => "闪灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 512]).sqlid )
GameProfession.create(
        :name => "剑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 512]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 512]).sqlid )
GameProfession.create(
        :name => "机师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 512]).sqlid )
GameProfession.create(
        :name => "祭司",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 512]).sqlid )
GameRace.create(
        :name => "天门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 706]).sqlid )
GameRace.create(
        :name => "蜀山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 706]).sqlid )
GameRace.create(
        :name => "昆仑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 706]).sqlid )
GameProfession.create(
        :name => "玄真",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 706]).sqlid )
GameProfession.create(
        :name => "月隐",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 706]).sqlid )
GameProfession.create(
        :name => "仙道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 706]).sqlid )
GameProfession.create(
        :name => "仙灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 706]).sqlid )
GameProfession.create(
        :name => "铁羽",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 706]).sqlid )
GameProfession.create(
        :name => "虎卫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 706]).sqlid )
GameProfession.create(
        :name => "人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 702]).sqlid )
GameProfession.create(
        :name => "半精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 702]).sqlid )
GameProfession.create(
        :name => "龙族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 702]).sqlid )
GameProfession.create(
        :name => "精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 702]).sqlid )
GameProfession.create(
        :name => "郸族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 702]).sqlid )
GameProfession.create(
        :name => "黑精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 702]).sqlid )
GameRace.create(
        :name => "神机营",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameRace.create(
        :name => "昆仑山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameRace.create(
        :name => "逍遥观",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameRace.create(
        :name => "万妖宫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "甲士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "刀客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "侠客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "方士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "医师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "魅者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "异人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "法术",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 355]).sqlid )
GameProfession.create(
        :name => "仙术",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 355]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 355]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 355]).sqlid )
GameProfession.create(
        :name => "召唤",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 355]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 490]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 490]).sqlid )
GameProfession.create(
        :name => "遊俠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 490]).sqlid )
GameProfession.create(
        :name => "術士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 490]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 490]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 431]).sqlid )
GameProfession.create(
        :name => "力士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 431]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 431]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 431]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 431]).sqlid )
GameProfession.create(
        :name => "火",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 413]).sqlid )
GameProfession.create(
        :name => "水",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 413]).sqlid )
GameProfession.create(
        :name => "风",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 413]).sqlid )
GameProfession.create(
        :name => "地",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 413]).sqlid )
GameProfession.create(
        :name => "雷",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 413]).sqlid )
GameRace.create(
        :name => "人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameRace.create(
        :name => "光精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameRace.create(
        :name => "兽人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameRace.create(
        :name => "暗精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "强兽人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "暗杀者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "祭司",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 708]).sqlid )
GameProfession.create(
        :name => "神传道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 522]).sqlid )
GameProfession.create(
        :name => "狂战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 522]).sqlid )
GameProfession.create(
        :name => "风舞者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 522]).sqlid )
GameProfession.create(
        :name => "邪灵术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 522]).sqlid )
GameProfession.create(
        :name => "飞车党",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 326]).sqlid )
GameProfession.create(
        :name => "机械专家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 326]).sqlid )
GameProfession.create(
        :name => "神射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 326]).sqlid )
GameProfession.create(
        :name => "霸王",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 556]).sqlid )
GameProfession.create(
        :name => "飞羽",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 556]).sqlid )
GameProfession.create(
        :name => "剑侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 556]).sqlid )
GameProfession.create(
        :name => "红颜",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 556]).sqlid )
GameProfession.create(
        :name => "奇门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 556]).sqlid )
GameProfession.create(
        :name => "圣武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "圣骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "火影猎人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "幻影弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "幽灵法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "圣洁牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "暗骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "灵魂猎人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "斗士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "召唤师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 563]).sqlid )
GameProfession.create(
        :name => "魔灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 563]).sqlid )
GameProfession.create(
        :name => "鬼族",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 563]).sqlid )
GameProfession.create(
        :name => "一剑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 664]).sqlid )
GameProfession.create(
        :name => "秀雅",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 664]).sqlid )
GameProfession.create(
        :name => "指路",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 664]).sqlid )
GameProfession.create(
        :name => "云婷",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 664]).sqlid )
GameProfession.create(
        :name => "南宫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 664]).sqlid )
GameProfession.create(
        :name => "娇红",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 664]).sqlid )
GameProfession.create(
        :name => "悟神",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 664]).sqlid )
GameProfession.create(
        :name => "拇指",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 664]).sqlid )
GameRace.create(
        :name => "人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameRace.create(
        :name => "精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameRace.create(
        :name => "希尔芙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameRace.create(
        :name => "潘塔",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameRace.create(
        :name => "克雷娅",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameProfession.create(
        :name => "召唤",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameProfession.create(
        :name => "武者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 514]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 424]).sqlid )
GameProfession.create(
        :name => "乐师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 424]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 424]).sqlid )
GameProfession.create(
        :name => "潜行者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 424]).sqlid )
GameProfession.create(
        :name => "幻灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 424]).sqlid )
GameProfession.create(
        :name => "强弓射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 424]).sqlid )
GameProfession.create(
        :name => "武术师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 441]).sqlid )
GameProfession.create(
        :name => "奇术师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 441]).sqlid )
GameProfession.create(
        :name => "诡术师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 441]).sqlid )
GameProfession.create(
        :name => "越野车",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "直升机",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "坦克",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "战斗机",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "战争机器",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "飞艇",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "霸王龙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "翼龙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "女性机体",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 370]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 370]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 370]).sqlid )
GameProfession.create(
        :name => "狂骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 616]).sqlid )
GameProfession.create(
        :name => "魔法精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 616]).sqlid )
GameProfession.create(
        :name => "德鲁依",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 616]).sqlid )
GameProfession.create(
        :name => "猎手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 616]).sqlid )
GameProfession.create(
        :name => "五毒",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "丐帮",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "少林",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "峨嵋",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "翠烟",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "杨门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "武当",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "唐门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "昆仑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "明教",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 634]).sqlid )
GameProfession.create(
        :name => "行者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 494]).sqlid )
GameProfession.create(
        :name => "音乐家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 494]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 494]).sqlid )
GameProfession.create(
        :name => "控能者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 494]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 623]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 623]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 623]).sqlid )
GameRace.create(
        :name => "正人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 656]).sqlid )
GameRace.create(
        :name => "神仙族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 656]).sqlid )
GameRace.create(
        :name => "邪妖族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 656]).sqlid )
GameProfession.create(
        :name => "地玄守护",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 656]).sqlid )
GameProfession.create(
        :name => "破金战将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 656]).sqlid )
GameProfession.create(
        :name => "雾忍刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 656]).sqlid )
GameProfession.create(
        :name => "天火翎侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 656]).sqlid )
GameProfession.create(
        :name => "紫雷法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 656]).sqlid )
GameProfession.create(
        :name => "灵蛊道尊",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 656]).sqlid )
GameProfession.create(
        :name => "弓箭部",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 548]).sqlid )
GameProfession.create(
        :name => "气功部",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 548]).sqlid )
GameProfession.create(
        :name => "格斗部",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 548]).sqlid )
GameProfession.create(
        :name => "终极部",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 548]).sqlid )
GameProfession.create(
        :name => "战将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 438]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 438]).sqlid )
GameProfession.create(
        :name => "谋士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 438]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 438]).sqlid )
GameProfession.create(
        :name => "书生",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 438]).sqlid )
GameProfession.create(
        :name => "天道盟",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 625]).sqlid )
GameProfession.create(
        :name => "逍遥派",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 625]).sqlid )
GameProfession.create(
        :name => "九重天",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 625]).sqlid )
GameProfession.create(
        :name => "星华宫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 625]).sqlid )
GameProfession.create(
        :name => "剑侍",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 658]).sqlid )
GameProfession.create(
        :name => "豪杰",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 658]).sqlid )
GameProfession.create(
        :name => "阴阳士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 658]).sqlid )
GameProfession.create(
        :name => "仙术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 658]).sqlid )
GameProfession.create(
        :name => "玄真派",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 488]).sqlid )
GameProfession.create(
        :name => "七星会",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 488]).sqlid )
GameProfession.create(
        :name => "莲华宗",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 488]).sqlid )
GameProfession.create(
        :name => "虎啸门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 488]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 511]).sqlid )
GameProfession.create(
        :name => "黑暗牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 511]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 511]).sqlid )
GameProfession.create(
        :name => "魔战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 511]).sqlid )
GameProfession.create(
        :name => "圣骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 511]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 511]).sqlid )
GameProfession.create(
        :name => "狂战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 511]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 511]).sqlid )
GameRace.create(
        :name => "阿克雷提亚族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 532]).sqlid )
GameRace.create(
        :name => "贝尔托联邦",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 532]).sqlid )
GameRace.create(
        :name => "克拉联盟",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 532]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 532]).sqlid )
GameProfession.create(
        :name => "猎杀者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 532]).sqlid )
GameProfession.create(
        :name => "技师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 532]).sqlid )
GameProfession.create(
        :name => "神灵使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 532]).sqlid )
GameProfession.create(
        :name => "工程师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 532]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 361]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 361]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 361]).sqlid )
GameProfession.create(
        :name => "审判神使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 399]).sqlid )
GameProfession.create(
        :name => "守护神使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 399]).sqlid )
GameProfession.create(
        :name => "惩戒神使",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 399]).sqlid )
GameProfession.create(
        :name => "净化神使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 399]).sqlid )
GameProfession.create(
        :name => "秩序神使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 399]).sqlid )
GameProfession.create(
        :name => "虔诚神使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 399]).sqlid )
GameProfession.create(
        :name => "唐门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 551]).sqlid )
GameProfession.create(
        :name => "极乐谷",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 551]).sqlid )
GameProfession.create(
        :name => "少林",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 551]).sqlid )
GameProfession.create(
        :name => "武当",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 551]).sqlid )
GameProfession.create(
        :name => "君子堂",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 551]).sqlid )
GameProfession.create(
        :name => "峨嵋",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 551]).sqlid )
GameProfession.create(
        :name => "丐帮",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 551]).sqlid )
GameProfession.create(
        :name => "锦衣卫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 551]).sqlid )
GameProfession.create(
        :name => "猛将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 385]).sqlid )
GameProfession.create(
        :name => "鬼谋",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 385]).sqlid )
GameProfession.create(
        :name => "豪杰",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 385]).sqlid )
GameProfession.create(
        :name => "医者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 385]).sqlid )
GameProfession.create(
        :name => "捕客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 655]).sqlid )
GameProfession.create(
        :name => "潜客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 655]).sqlid )
GameProfession.create(
        :name => "袭客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 655]).sqlid )
GameProfession.create(
        :name => "易客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 655]).sqlid )
GameProfession.create(
        :name => "侣客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 655]).sqlid )
GameProfession.create(
        :name => "护客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 655]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 406]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 406]).sqlid )
GameProfession.create(
        :name => "火枪手",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 406]).sqlid )
GameProfession.create(
        :name => "骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 703]).sqlid )
GameProfession.create(
        :name => "魔使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 703]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 703]).sqlid )
GameProfession.create(
        :name => "牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 703]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 703]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 703]).sqlid )
GameProfession.create(
        :name => "侠士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 557]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 557]).sqlid )
GameProfession.create(
        :name => "弓者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 557]).sqlid )
GameProfession.create(
        :name => "力士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 557]).sqlid )
GameProfession.create(
        :name => "巫者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 557]).sqlid )
GameProfession.create(
        :name => "弩者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 557]).sqlid )
GameProfession.create(
        :name => "狂战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 618]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 618]).sqlid )
GameProfession.create(
        :name => "巫术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 618]).sqlid )
GameProfession.create(
        :name => "咒术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 618]).sqlid )
GameProfession.create(
        :name => "辅祭",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 618]).sqlid )
GameProfession.create(
        :name => "贤者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 618]).sqlid )
GameProfession.create(
        :name => "双剑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 543]).sqlid )
GameProfession.create(
        :name => "巨剑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 543]).sqlid )
GameProfession.create(
        :name => "狙击手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 543]).sqlid )
GameProfession.create(
        :name => "航海士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 543]).sqlid )
GameProfession.create(
        :name => "圣职",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 543]).sqlid )
GameProfession.create(
        :name => "封印师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 543]).sqlid )
GameProfession.create(
        :name => "人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 397]).sqlid )
GameProfession.create(
        :name => "魔灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 397]).sqlid )
GameProfession.create(
        :name => "鬼族",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 397]).sqlid )
GameProfession.create(
        :name => "艾利克斯",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 339]).sqlid )
GameProfession.create(
        :name => "布莱克",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 339]).sqlid )
GameProfession.create(
        :name => "柯莉儿",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 339]).sqlid )
GameProfession.create(
        :name => "比比",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 339]).sqlid )
GameProfession.create(
        :name => "烈武",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 732]).sqlid )
GameProfession.create(
        :name => "疾影",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 732]).sqlid )
GameProfession.create(
        :name => "释剑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 732]).sqlid )
GameProfession.create(
        :name => "幻妖",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 732]).sqlid )
GameProfession.create(
        :name => "逸道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 732]).sqlid )
GameProfession.create(
        :name => "诡冥",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 732]).sqlid )
GameRace.create(
        :name => "人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 360]).sqlid )
GameRace.create(
        :name => "精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 360]).sqlid )
GameRace.create(
        :name => "星族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 360]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 360]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 360]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 360]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 384]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 384]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 384]).sqlid )
GameProfession.create(
        :name => "牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 384]).sqlid )
GameProfession.create(
        :name => "修罗",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 597]).sqlid )
GameProfession.create(
        :name => "金刚",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 597]).sqlid )
GameProfession.create(
        :name => "武圣",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 597]).sqlid )
GameProfession.create(
        :name => "箭神",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 597]).sqlid )
GameProfession.create(
        :name => "巫仙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 597]).sqlid )
GameProfession.create(
        :name => "医仙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 597]).sqlid )
GameProfession.create(
        :name => "咒师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 597]).sqlid )
GameProfession.create(
        :name => "天师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 597]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 330]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 330]).sqlid )
GameProfession.create(
        :name => "猎人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 330]).sqlid )
GameProfession.create(
        :name => "牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 330]).sqlid )
GameRace.create(
        :name => "昆仑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameRace.create(
        :name => "楼兰",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameRace.create(
        :name => "莱茵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameRace.create(
        :name => "敦煌",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameProfession.create(
        :name => "萨满",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameProfession.create(
        :name => "先知",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameProfession.create(
        :name => "剑侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameProfession.create(
        :name => "火枪手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameProfession.create(
        :name => "骑射",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 566]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 705]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 705]).sqlid )
GameProfession.create(
        :name => "祭司",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 705]).sqlid )
GameProfession.create(
        :name => "伏魔行者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 524]).sqlid )
GameProfession.create(
        :name => "南斗天师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 524]).sqlid )
GameProfession.create(
        :name => "九尾",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 524]).sqlid )
GameProfession.create(
        :name => "太仙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 524]).sqlid )
GameProfession.create(
        :name => "乱佛",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 524]).sqlid )
GameProfession.create(
        :name => "镇山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 524]).sqlid )
GameProfession.create(
        :name => "索命",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 524]).sqlid )
GameProfession.create(
        :name => "恋尘",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 524]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 503]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 503]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 503]).sqlid )
GameProfession.create(
        :name => "少林",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 540]).sqlid )
GameProfession.create(
        :name => "武当",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 540]).sqlid )
GameProfession.create(
        :name => "峨嵋",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 540]).sqlid )
GameProfession.create(
        :name => "华山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 540]).sqlid )
GameProfession.create(
        :name => "昆仑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 540]).sqlid )
GameProfession.create(
        :name => "百花",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 540]).sqlid )
GameProfession.create(
        :name => "蓬莱",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 540]).sqlid )
GameProfession.create(
        :name => "终南",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 540]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 668]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 668]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 668]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 668]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 668]).sqlid )
GameProfession.create(
        :name => "剑客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 564]).sqlid )
GameProfession.create(
        :name => "刀客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 564]).sqlid )
GameProfession.create(
        :name => "火神",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 564]).sqlid )
GameProfession.create(
        :name => "水君",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 564]).sqlid )
GameProfession.create(
        :name => "医师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 564]).sqlid )
GameProfession.create(
        :name => "药师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 564]).sqlid )
GameProfession.create(
        :name => "花郎",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 564]).sqlid )
GameProfession.create(
        :name => "武魂",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 564]).sqlid )
GameRace.create(
        :name => "唐国",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 624]).sqlid )
GameRace.create(
        :name => "西国",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 624]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 624]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 624]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 624]).sqlid )
GameProfession.create(
        :name => "侠客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 426]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 426]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 426]).sqlid )
GameProfession.create(
        :name => "祭祀",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 426]).sqlid )
GameProfession.create(
        :name => "将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 416]).sqlid )
GameProfession.create(
        :name => "侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 416]).sqlid )
GameProfession.create(
        :name => "道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 416]).sqlid )
GameProfession.create(
        :name => "医",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 416]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 734]).sqlid )
GameProfession.create(
        :name => "骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 734]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 734]).sqlid )
GameProfession.create(
        :name => "谋士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 734]).sqlid )
GameProfession.create(
        :name => "阵法",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 734]).sqlid )
GameProfession.create(
        :name => "圣灵法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 408]).sqlid )
GameProfession.create(
        :name => "圣战牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 408]).sqlid )
GameProfession.create(
        :name => "幽冥巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 408]).sqlid )
GameProfession.create(
        :name => "暗影祭司",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 408]).sqlid )
GameProfession.create(
        :name => "圣堂武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 408]).sqlid )
GameProfession.create(
        :name => "圣殿骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 408]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 408]).sqlid )
GameProfession.create(
        :name => "神箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 408]).sqlid )
GameRace.create(
        :name => "仙界",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 445]).sqlid )
GameRace.create(
        :name => "魔界",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 445]).sqlid )
GameProfession.create(
        :name => "修罗",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 445]).sqlid )
GameProfession.create(
        :name => "魔童",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 445]).sqlid )
GameProfession.create(
        :name => "天音",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 445]).sqlid )
GameProfession.create(
        :name => "星君",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 445]).sqlid )
GameProfession.create(
        :name => "昭悦",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 445]).sqlid )
GameRace.create(
        :name => "联邦",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 681]).sqlid )
GameRace.create(
        :name => "亚瑟",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 681]).sqlid )
GameProfession.create(
        :name => "自然人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 681]).sqlid )
GameProfession.create(
        :name => "强化人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 681]).sqlid )
GameProfession.create(
        :name => "新人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 681]).sqlid )
GameProfession.create(
        :name => "冒险家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 402]).sqlid )
GameProfession.create(
        :name => "隐猎手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 402]).sqlid )
GameProfession.create(
        :name => "精灵师",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 402]).sqlid )
GameProfession.create(
        :name => "天行者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 402]).sqlid )
GameProfession.create(
        :name => "魔术师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 402]).sqlid )
GameProfession.create(
        :name => "艺术家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 402]).sqlid )
GameProfession.create(
        :name => "异能者",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 402]).sqlid )
GameProfession.create(
        :name => "医学家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 402]).sqlid )
GameProfession.create(
        :name => "音乐家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 402]).sqlid )
GameRace.create(
        :name => "秦",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameRace.create(
        :name => "赵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameRace.create(
        :name => "楚",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameRace.create(
        :name => "燕",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameRace.create(
        :name => "魏",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameRace.create(
        :name => "齐",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameRace.create(
        :name => "韩",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameProfession.create(
        :name => "骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameProfession.create(
        :name => "谋士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameProfession.create(
        :name => "阵法",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 715]).sqlid )
GameProfession.create(
        :name => "侠客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 356]).sqlid )
GameProfession.create(
        :name => "五行",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 356]).sqlid )
GameProfession.create(
        :name => "符咒",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 356]).sqlid )
GameProfession.create(
        :name => "剑仙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 356]).sqlid )
GameProfession.create(
        :name => "风水",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 356]).sqlid )
GameProfession.create(
        :name => "锦衣",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 356]).sqlid )
GameProfession.create(
        :name => "风水师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 341]).sqlid )
GameProfession.create(
        :name => "冒险家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 341]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 341]).sqlid )
GameProfession.create(
        :name => "赤阳",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 558]).sqlid )
GameProfession.create(
        :name => "清虚",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 558]).sqlid )
GameProfession.create(
        :name => "蓝央",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 558]).sqlid )
GameProfession.create(
        :name => "血魔",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 558]).sqlid )
GameProfession.create(
        :name => "阴月",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 558]).sqlid )
GameProfession.create(
        :name => "炎魔",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 558]).sqlid )
GameProfession.create(
        :name => "射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "甲士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "刀客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "侠客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "方士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "医师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "魅者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "异人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 342]).sqlid )
GameProfession.create(
        :name => "真武剑门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 651]).sqlid )
GameProfession.create(
        :name => "天霸刀门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 651]).sqlid )
GameProfession.create(
        :name => "魔尊血门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 651]).sqlid )
GameProfession.create(
        :name => "皮克精",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 642]).sqlid )
GameProfession.create(
        :name => "半兽人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 642]).sqlid )
GameProfession.create(
        :name => "永夜者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 642]).sqlid )
GameProfession.create(
        :name => "魔裔族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 642]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 595]).sqlid )
GameProfession.create(
        :name => "盗贼",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 595]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 595]).sqlid )
GameProfession.create(
        :name => "服伺",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 595]).sqlid )
GameProfession.create(
        :name => "黑魔导",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 595]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 595]).sqlid )
GameProfession.create(
        :name => "暴君",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 595]).sqlid )
GameProfession.create(
        :name => "闪灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 595]).sqlid )
GameProfession.create(
        :name => "金刚",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 627]).sqlid )
GameProfession.create(
        :name => "东岛",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 627]).sqlid )
GameProfession.create(
        :name => "西城",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 627]).sqlid )
GameRace.create(
        :name => "江波",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 338]).sqlid )
GameRace.create(
        :name => "维克",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 338]).sqlid )
GameRace.create(
        :name => "盘古",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 338]).sqlid )
GameProfession.create(
        :name => "重装武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 338]).sqlid )
GameProfession.create(
        :name => "机动射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 338]).sqlid )
GameProfession.create(
        :name => "磁暴步兵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 338]).sqlid )
GameProfession.create(
        :name => "牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "贤者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "祭司",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "元素师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "魔导师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "箭神",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "剑圣",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "战神",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 547]).sqlid )
GameProfession.create(
        :name => "冒险家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 647]).sqlid )
GameProfession.create(
        :name => "剑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 647]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 647]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 647]).sqlid )
GameProfession.create(
        :name => "猛将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 390]).sqlid )
GameProfession.create(
        :name => "修罗",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 390]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 390]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 390]).sqlid )
GameRace.create(
        :name => "古都",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 722]).sqlid )
GameRace.create(
        :name => "漠北",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 722]).sqlid )
GameRace.create(
        :name => "盘龙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 722]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 722]).sqlid )
GameProfession.create(
        :name => "医生",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 722]).sqlid )
GameProfession.create(
        :name => "艺人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 722]).sqlid )
GameProfession.create(
        :name => "混混",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 722]).sqlid )
GameProfession.create(
        :name => "黑客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 722]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 691]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 691]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 691]).sqlid )
GameProfession.create(
        :name => "武当",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 368]).sqlid )
GameProfession.create(
        :name => "明教",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 368]).sqlid )
GameProfession.create(
        :name => "唐门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 368]).sqlid )
GameProfession.create(
        :name => "少林",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 368]).sqlid )
GameProfession.create(
        :name => "峨眉",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 368]).sqlid )
GameProfession.create(
        :name => "飘渺崖",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 380]).sqlid )
GameProfession.create(
        :name => "万邪墓",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 380]).sqlid )
GameProfession.create(
        :name => "青云峰",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 380]).sqlid )
GameProfession.create(
        :name => "战皇殿",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 380]).sqlid )
GameProfession.create(
        :name => "狂魔谷",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 380]).sqlid )
GameProfession.create(
        :name => "祭祀",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 525]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 525]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 525]).sqlid )
GameProfession.create(
        :name => "侠客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 525]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 472]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 472]).sqlid )
GameProfession.create(
        :name => "魔武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 472]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 725]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 725]).sqlid )
GameProfession.create(
        :name => "骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 725]).sqlid )
GameProfession.create(
        :name => "驱魔师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 725]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 725]).sqlid )
GameProfession.create(
        :name => "杰克",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 382]).sqlid )
GameProfession.create(
        :name => "玲珑",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 382]).sqlid )
GameProfession.create(
        :name => "村正",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 382]).sqlid )
GameProfession.create(
        :name => "美子",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 382]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 582]).sqlid )
GameProfession.create(
        :name => "盗贼",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 582]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 582]).sqlid )
GameProfession.create(
        :name => "服伺",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 582]).sqlid )
GameProfession.create(
        :name => "黑魔导",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 582]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 582]).sqlid )
GameProfession.create(
        :name => "暴君",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 582]).sqlid )
GameProfession.create(
        :name => "闪灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 582]).sqlid )
GameProfession.create(
        :name => "金",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 528]).sqlid )
GameProfession.create(
        :name => "木",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 528]).sqlid )
GameProfession.create(
        :name => "水",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 528]).sqlid )
GameProfession.create(
        :name => "火",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 528]).sqlid )
GameProfession.create(
        :name => "土",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 528]).sqlid )
GameRace.create(
        :name => "人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameRace.create(
        :name => "兽族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameProfession.create(
        :name => "盗贼",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameProfession.create(
        :name => "审判官",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameProfession.create(
        :name => "骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameProfession.create(
        :name => "神射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 346]).sqlid )
GameProfession.create(
        :name => "少林派",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 735]).sqlid )
GameProfession.create(
        :name => "武当派",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 735]).sqlid )
GameProfession.create(
        :name => "峨嵋派",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 735]).sqlid )
GameProfession.create(
        :name => "唐门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 735]).sqlid )
GameProfession.create(
        :name => "魔教",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 735]).sqlid )
GameProfession.create(
        :name => "寒冰",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 450]).sqlid )
GameProfession.create(
        :name => "蜀山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 450]).sqlid )
GameProfession.create(
        :name => "少林",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 450]).sqlid )
GameProfession.create(
        :name => "天煞",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 450]).sqlid )
GameProfession.create(
        :name => "百花",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 450]).sqlid )
GameProfession.create(
        :name => "剑客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 389]).sqlid )
GameProfession.create(
        :name => "药师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 389]).sqlid )
GameProfession.create(
        :name => "仙道",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 389]).sqlid )
GameProfession.create(
        :name => "谋士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 389]).sqlid )
GameProfession.create(
        :name => "圣武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 603]).sqlid )
GameProfession.create(
        :name => "影舞者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 603]).sqlid )
GameProfession.create(
        :name => "神射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 603]).sqlid )
GameProfession.create(
        :name => "魔导师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 603]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 376]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 376]).sqlid )
GameProfession.create(
        :name => "暗巫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 376]).sqlid )
GameProfession.create(
        :name => "幻师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 376]).sqlid )
GameProfession.create(
        :name => "华安",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 530]).sqlid )
GameProfession.create(
        :name => "达文西",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 530]).sqlid )
GameProfession.create(
        :name => "聋伍",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 530]).sqlid )
GameProfession.create(
        :name => "股沟男",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 530]).sqlid )
GameProfession.create(
        :name => "茹花",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 530]).sqlid )
GameProfession.create(
        :name => "暴牙珍",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 530]).sqlid )
GameProfession.create(
        :name => "食榴姐",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 530]).sqlid )
GameProfession.create(
        :name => "长江八号",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 530]).sqlid )
GameProfession.create(
        :name => "忍者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 452]).sqlid )
GameProfession.create(
        :name => "阴阳师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 452]).sqlid )
GameProfession.create(
        :name => "巫女",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 452]).sqlid )
GameProfession.create(
        :name => "僧侣",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 452]).sqlid )
GameProfession.create(
        :name => "侍",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 452]).sqlid )
GameProfession.create(
        :name => "倾奇者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 452]).sqlid )
GameProfession.create(
        :name => "药师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 452]).sqlid )
GameProfession.create(
        :name => "锻冶匠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 452]).sqlid )
GameProfession.create(
        :name => "飞天武者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "御剑圣者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "无双影者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "冰火行者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "圣光使者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 417]).sqlid )
GameProfession.create(
        :name => "谋士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 417]).sqlid )
GameProfession.create(
        :name => "骑士",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 417]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 417]).sqlid )
GameRace.create(
        :name => "曹操",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 345]).sqlid )
GameRace.create(
        :name => "刘备",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 345]).sqlid )
GameRace.create(
        :name => "孙坚",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 345]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 345]).sqlid )
GameProfession.create(
        :name => "侠士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 345]).sqlid )
GameProfession.create(
        :name => "策士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 345]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 345]).sqlid )
GameRace.create(
        :name => "人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 529]).sqlid )
GameRace.create(
        :name => "精灵族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 529]).sqlid )
GameRace.create(
        :name => "魔族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 529]).sqlid )
GameProfession.create(
        :name => "盗贼",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 529]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 529]).sqlid )
GameProfession.create(
        :name => "牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 529]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 529]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 388]).sqlid )
GameProfession.create(
        :name => "枪侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 388]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 388]).sqlid )
GameProfession.create(
        :name => "天师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 388]).sqlid )
GameProfession.create(
        :name => "琴师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 388]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 500]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 500]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 500]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 500]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 466]).sqlid )
GameProfession.create(
        :name => "骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 466]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 466]).sqlid )
GameProfession.create(
        :name => "谋士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 466]).sqlid )
GameProfession.create(
        :name => "花果山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 730]).sqlid )
GameProfession.create(
        :name => "地府",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 730]).sqlid )
GameProfession.create(
        :name => "清宫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 730]).sqlid )
GameProfession.create(
        :name => "牛魔洞",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 730]).sqlid )
GameProfession.create(
        :name => "广寒宫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 730]).sqlid )
GameProfession.create(
        :name => "盘丝洞",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 730]).sqlid )
GameProfession.create(
        :name => "凌霄殿",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 730]).sqlid )
GameProfession.create(
        :name => "龙宫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 730]).sqlid )
GameProfession.create(
        :name => "金蝉寺",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 730]).sqlid )
GameProfession.create(
        :name => "神传道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 588]).sqlid )
GameProfession.create(
        :name => "狂战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 588]).sqlid )
GameProfession.create(
        :name => "风舞者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 588]).sqlid )
GameProfession.create(
        :name => "邪灵术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 588]).sqlid )
GameRace.create(
        :name => "圣门学院",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameRace.create(
        :name => "玄严学院",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameRace.create(
        :name => "凤凰学院",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "剑道部",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "弓箭部",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "气功部",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "格斗部",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "终极部",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "蛮族战神",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "风舞者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "冠军武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "精英守卫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "冰霜大师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "火焰大师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "灵能术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "死灵法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "格斗大师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "隐舞者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "黑暗使者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "神使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "暴风射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "暗影游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "恶魔猎手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "暗影猎手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 596]).sqlid )
GameProfession.create(
        :name => "天道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 372]).sqlid )
GameProfession.create(
        :name => "人道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 372]).sqlid )
GameProfession.create(
        :name => "鬼道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 372]).sqlid )
GameProfession.create(
        :name => "阿修罗道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 372]).sqlid )
GameProfession.create(
        :name => "旁道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 372]).sqlid )
GameProfession.create(
        :name => "魔道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 372]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 499]).sqlid )
GameProfession.create(
        :name => "黑暗牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 499]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 499]).sqlid )
GameProfession.create(
        :name => "魔战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 499]).sqlid )
GameProfession.create(
        :name => "圣骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 499]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 499]).sqlid )
GameProfession.create(
        :name => "狂战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 499]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 499]).sqlid )
GameProfession.create(
        :name => "武者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 649]).sqlid )
GameProfession.create(
        :name => "灵者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 649]).sqlid )
GameProfession.create(
        :name => "夜行者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 649]).sqlid )
GameProfession.create(
        :name => "侠士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 419]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 419]).sqlid )
GameProfession.create(
        :name => "隐士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 419]).sqlid )
GameRace.create(
        :name => "天界",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 506]).sqlid )
GameRace.create(
        :name => "人界",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 506]).sqlid )
GameRace.create(
        :name => "魔界",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 506]).sqlid )
GameProfession.create(
        :name => "剑修",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 506]).sqlid )
GameProfession.create(
        :name => "术修",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 506]).sqlid )
GameProfession.create(
        :name => "丹修",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 506]).sqlid )
GameProfession.create(
        :name => "巫修",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 506]).sqlid )
GameProfession.create(
        :name => "道人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 587]).sqlid )
GameProfession.create(
        :name => "剑侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 587]).sqlid )
GameProfession.create(
        :name => "僧侣",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 587]).sqlid )
GameProfession.create(
        :name => "术者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 587]).sqlid )
GameProfession.create(
        :name => "勇士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 587]).sqlid )
GameProfession.create(
        :name => "人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "神族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "虫族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 409]).sqlid )
GameProfession.create(
        :name => "甲士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 660]).sqlid )
GameProfession.create(
        :name => "方士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 660]).sqlid )
GameProfession.create(
        :name => "药师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 660]).sqlid )
GameProfession.create(
        :name => "猎手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 660]).sqlid )
GameProfession.create(
        :name => "碎铁战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "符文祭师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "工程师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "撕裂者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "战斗祭司",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "烈焰巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "巫师猎人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "焰阳骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "剑术大师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "大魔导士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "暗影战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "白狮勇士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "黑兽人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "萨满",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "史奎格牧者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "砍霸",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "神选战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "混沌术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "邪神修士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "掠夺者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "血祭精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "骸隐使者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "女术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "黑暗卫士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 538]).sqlid )
GameProfession.create(
        :name => "雷",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 462]).sqlid )
GameProfession.create(
        :name => "火",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 462]).sqlid )
GameProfession.create(
        :name => "风",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 462]).sqlid )
GameProfession.create(
        :name => "水",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 462]).sqlid )
GameProfession.create(
        :name => "地",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 462]).sqlid )
GameRace.create(
        :name => "自由国度",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 653]).sqlid )
GameRace.create(
        :name => "秩序圣殿",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 653]).sqlid )
GameRace.create(
        :name => "血色黎明",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 653]).sqlid )
GameProfession.create(
        :name => "翼刃",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 653]).sqlid )
GameProfession.create(
        :name => "迅灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 653]).sqlid )
GameProfession.create(
        :name => "晶耀",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 653]).sqlid )
GameProfession.create(
        :name => "树语",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 653]).sqlid )
GameProfession.create(
        :name => "炽辉",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 653]).sqlid )
GameProfession.create(
        :name => "初心者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "剑客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "剑侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "武师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "武狂",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "道尊",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "医师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "医仙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 611]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 373]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 373]).sqlid )
GameProfession.create(
        :name => "剑客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 373]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 373]).sqlid )
GameProfession.create(
        :name => "药师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 373]).sqlid )
GameProfession.create(
        :name => "虎贲",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 521]).sqlid )
GameProfession.create(
        :name => "极天",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 521]).sqlid )
GameProfession.create(
        :name => "罗刹",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 521]).sqlid )
GameProfession.create(
        :name => "行者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 521]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 572]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 572]).sqlid )
GameProfession.create(
        :name => "天师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 572]).sqlid )
GameProfession.create(
        :name => "剑客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 572]).sqlid )
GameProfession.create(
        :name => "祭师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 572]).sqlid )
GameRace.create(
        :name => "天人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 491]).sqlid )
GameRace.create(
        :name => "龙族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 491]).sqlid )
GameProfession.create(
        :name => " 战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 491]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 491]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 491]).sqlid )
GameRace.create(
        :name => "庆",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 723]).sqlid )
GameRace.create(
        :name => "瑞",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 723]).sqlid )
GameRace.create(
        :name => "宣",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 723]).sqlid )
GameRace.create(
        :name => "盛",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 723]).sqlid )
GameProfession.create(
        :name => "将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 723]).sqlid )
GameProfession.create(
        :name => "侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 723]).sqlid )
GameProfession.create(
        :name => "道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 723]).sqlid )
GameProfession.create(
        :name => "药",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 723]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 559]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 559]).sqlid )
GameProfession.create(
        :name => "咒师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 559]).sqlid )
GameProfession.create(
        :name => "狙击手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 559]).sqlid )
GameProfession.create(
        :name => "斥候",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 559]).sqlid )
GameProfession.create(
        :name => "战士型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "突击战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "广击战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "枪手型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "锐利射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "魔弹射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "法师型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "破坏忌咒法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "魔崩忌咒法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "辅助型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "附魔回复",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "忌咒回复",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "工匠型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "刀匠/枪匠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "融合师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 363]).sqlid )
GameProfession.create(
        :name => "痞子妹",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 340]).sqlid )
GameProfession.create(
        :name => "工头",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 340]).sqlid )
GameProfession.create(
        :name => "囡囡",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 340]).sqlid )
GameProfession.create(
        :name => "栗子",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 340]).sqlid )
GameProfession.create(
        :name => "小蜜桃",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 340]).sqlid )
GameProfession.create(
        :name => "丫肥",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 340]).sqlid )
GameProfession.create(
        :name => "海盗船长",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 340]).sqlid )
GameProfession.create(
        :name => "圣诞老人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 340]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 612]).sqlid )
GameProfession.create(
        :name => "方士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 612]).sqlid )
GameProfession.create(
        :name => "射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 612]).sqlid )
GameProfession.create(
        :name => "墨者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 612]).sqlid )
GameProfession.create(
        :name => "明威",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 571]).sqlid )
GameProfession.create(
        :name => "破军",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 571]).sqlid )
GameProfession.create(
        :name => "羽林",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 571]).sqlid )
GameProfession.create(
        :name => "传道士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "魔教徒",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "魔战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "黑暗牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "剑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "圣骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "狂战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameProfession.create(
        :name => "神射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 468]).sqlid )
GameRace.create(
        :name => "楚国",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 713]).sqlid )
GameRace.create(
        :name => "晋国",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 713]).sqlid )
GameRace.create(
        :name => "罪恶之城",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 713]).sqlid )
GameProfession.create(
        :name => "东方武者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 713]).sqlid )
GameProfession.create(
        :name => "修道者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 713]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 713]).sqlid )
GameProfession.create(
        :name => "西方武者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 713]).sqlid )
GameProfession.create(
        :name => "隐藏职业",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 713]).sqlid )
GameProfession.create(
        :name => "人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 607]).sqlid )
GameProfession.create(
        :name => "西西族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 607]).sqlid )
GameProfession.create(
        :name => "神秘种族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 607]).sqlid )
GameProfession.create(
        :name => "剑宗",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 444]).sqlid )
GameProfession.create(
        :name => "戟门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 444]).sqlid )
GameProfession.create(
        :name => "诡流",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 444]).sqlid )
GameProfession.create(
        :name => "幻道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 444]).sqlid )
GameProfession.create(
        :name => "武圣",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 510]).sqlid )
GameProfession.create(
        :name => "天师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 510]).sqlid )
GameProfession.create(
        :name => "幽冥",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 510]).sqlid )
GameProfession.create(
        :name => "剑仙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 510]).sqlid )
GameRace.create(
        :name => "人族女性",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameRace.create(
        :name => "人族男性",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameRace.create(
        :name => "魔族女性",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameRace.create(
        :name => "魔族男性",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameRace.create(
        :name => "仙族女性",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameRace.create(
        :name => "仙族男性",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "御林军",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "三星洞",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "化生寺",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "胭脂村",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "天庭",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "水晶宫",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "五庄观",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "普陀山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "幽冥界",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "兽神山",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "狮驼洞",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "盘丝岭",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 328]).sqlid )
GameProfession.create(
        :name => "勇气",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 324]).sqlid )
GameProfession.create(
        :name => "爱心",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 324]).sqlid )
GameProfession.create(
        :name => "调皮",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 324]).sqlid )
GameProfession.create(
        :name => "战士型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "突击战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "广击战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "枪手型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "锐利射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "魔弹射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "法师型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "破坏忌咒法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "魔崩忌咒法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "辅助型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "附魔回复",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "忌咒回复",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "工匠型",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "刀匠/枪匠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "融合师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 410]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 667]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 667]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 667]).sqlid )
GameProfession.create(
        :name => "幻弓",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 667]).sqlid )
GameProfession.create(
        :name => "药师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 667]).sqlid )
GameProfession.create(
        :name => "金",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 555]).sqlid )
GameProfession.create(
        :name => "木",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 555]).sqlid )
GameProfession.create(
        :name => "水",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 555]).sqlid )
GameProfession.create(
        :name => "火",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 555]).sqlid )
GameProfession.create(
        :name => "土",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 555]).sqlid )
GameProfession.create(
        :name => "飞龙山庄",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 562]).sqlid )
GameProfession.create(
        :name => "药王谷",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 562]).sqlid )
GameProfession.create(
        :name => "明教",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 562]).sqlid )
GameProfession.create(
        :name => "三杀门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 562]).sqlid )
GameProfession.create(
        :name => "阴阳界",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 562]).sqlid )
GameProfession.create(
        :name => "鬼域",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 562]).sqlid )
GameProfession.create(
        :name => "天龙寺",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 562]).sqlid )
GameProfession.create(
        :name => "天师道",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 562]).sqlid )
GameProfession.create(
        :name => "雷音寺",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 562]).sqlid )
GameProfession.create(
        :name => "神剑门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 320]).sqlid )
GameProfession.create(
        :name => "逍遥派",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 320]).sqlid )
GameProfession.create(
        :name => "梦魇圣教",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 320]).sqlid )
GameProfession.create(
        :name => "云梦门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 320]).sqlid )
GameRace.create(
        :name => "魏",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 577]).sqlid )
GameRace.create(
        :name => "蜀",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 577]).sqlid )
GameRace.create(
        :name => "吴",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 577]).sqlid )
GameProfession.create(
        :name => "巨门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 577]).sqlid )
GameProfession.create(
        :name => "破军",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 577]).sqlid )
GameProfession.create(
        :name => "天机",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 577]).sqlid )
GameProfession.create(
        :name => "天同",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 577]).sqlid )
GameProfession.create(
        :name => "太阴",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 577]).sqlid )
GameProfession.create(
        :name => "沈美玲",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 650]).sqlid )
GameProfession.create(
        :name => "古月",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 650]).sqlid )
GameProfession.create(
        :name => "美香子",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 650]).sqlid )
GameProfession.create(
        :name => "剑魂",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 650]).sqlid )
GameProfession.create(
        :name => "金美熙",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 650]).sqlid )
GameProfession.create(
        :name => "宫本智",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 650]).sqlid )
GameProfession.create(
        :name => "神剑门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 690]).sqlid )
GameProfession.create(
        :name => "逍遥派",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 690]).sqlid )
GameProfession.create(
        :name => "梦魇圣教",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 690]).sqlid )
GameProfession.create(
        :name => "云梦门",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 690]).sqlid )
GameProfession.create(
        :name => "铁匠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "机械师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "练金术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "木偶使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "探险家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "考古学家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "贸易商",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "赌徒",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "魔导士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "贤者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "精灵使",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "吟游诗人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "神官",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "巫师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "暗术师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "死灵使者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "剑客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "赏金猎人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "圣骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "暗黑骑士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "刺客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "特工",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "猎人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "神枪手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 533]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 671]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 671]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 671]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 362]).sqlid )
GameProfession.create(
        :name => "剑客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 362]).sqlid )
GameProfession.create(
        :name => "射手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 362]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 362]).sqlid )
GameProfession.create(
        :name => "武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 383]).sqlid )
GameProfession.create(
        :name => "甲士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 383]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 383]).sqlid )
GameProfession.create(
        :name => "医师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 383]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 608]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 608]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 608]).sqlid )
GameProfession.create(
        :name => "格斗家",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 333]).sqlid )
GameProfession.create(
        :name => "魔法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 333]).sqlid )
GameProfession.create(
        :name => "剑武士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 333]).sqlid )
GameProfession.create(
        :name => "枪械师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 333]).sqlid )
GameProfession.create(
        :name => "战狂",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 579]).sqlid )
GameProfession.create(
        :name => "仙灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 579]).sqlid )
GameProfession.create(
        :name => "心舞",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 579]).sqlid )
GameProfession.create(
        :name => "术尊",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 579]).sqlid )
GameRace.create(
        :name => "人类",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 638]).sqlid )
GameRace.create(
        :name => "矮人",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 638]).sqlid )
GameRace.create(
        :name => "亡灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 638]).sqlid )
GameRace.create(
        :name => "精灵",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 638]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 638]).sqlid )
GameProfession.create(
        :name => "牧师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 638]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 638]).sqlid )
GameProfession.create(
        :name => "游侠",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 638]).sqlid )
GameRace.create(
        :name => "基因族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 610]).sqlid )
GameRace.create(
        :name => "天人族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 610]).sqlid )
GameRace.create(
        :name => "龙族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 610]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 610]).sqlid )
GameProfession.create(
        :name => "枪手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 610]).sqlid )
GameProfession.create(
        :name => "异能者",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 610]).sqlid )
GameProfession.create(
        :name => "弓手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 610]).sqlid )
GameProfession.create(
        :name => "术士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 610]).sqlid )
GameProfession.create(
        :name => "猎手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 610]).sqlid )
GameRace.create(
        :name => "青丘",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 335]).sqlid )
GameProfession.create(
        :name => "战将",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 335]).sqlid )
GameProfession.create(
        :name => "秀法",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 335]).sqlid )
GameProfession.create(
        :name => "兽师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 335]).sqlid )
GameProfession.create(
        :name => "侠客",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 335]).sqlid )
GameProfession.create(
        :name => "巫祝",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 335]).sqlid )
GameProfession.create(
        :name => "法师",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 628]).sqlid )
GameProfession.create(
        :name => "弓箭手",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 628]).sqlid )
GameProfession.create(
        :name => "战士",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 628]).sqlid )
GameProfession.create(
        :name => "妖族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 322]).sqlid )
GameProfession.create(
        :name => "魔族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 322]).sqlid )
GameProfession.create(
        :name => "鬼族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 322]).sqlid )
GameProfession.create(
        :name => "兽族",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 322]).sqlid )
GameProfession.create(
        :name => "人族",
        :game_id => Gameswithhole.find(:first, :conditions =>['txtid = ?', 322]).sqlid )
GameProfession.create(
        :name => "精怪",
        :game_id =>  Gameswithhole.find(:first, :conditions =>['txtid = ?', 322]).sqlid )
  end

  def self.down
		GameProfession.delete_all("game_id > 319")
		GameRace.delete_all("game_id > 319")
  end
end
