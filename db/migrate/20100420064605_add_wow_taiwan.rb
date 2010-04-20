class AddWowTaiwan < ActiveRecord::Migration
  def self.up
game741 = Game.create(
			:name => "魔兽世界（台服）",
			:official_web => "http://www.wowtaiwan.com.tw/",
			:sale_date => "2005-4-26",
			:company => "暴雪",
			:agent => "智凡迪",
			:description => "欧美大型角色扮演游戏")
Gameswithhole.create( :txtid => 741, :sqlid => game741.id, :gamename => game741.name )
			game741.tag_list = "史诗, 奇幻, 角色扮演, 时间收费, 即时战斗, 3D"
			game741.save
			aRecord = GameArea.create(:name => "台湾", :game_id => game741.id)
			aRecord.servers.create(:name => "火焰之樹", :game_id => game741.id)
			aRecord.servers.create(:name => "血之谷", :game_id => game741.id)
			aRecord.servers.create(:name => "亚雷戈斯", :game_id => game741.id)
			aRecord.servers.create(:name => "语风", :game_id => game741.id)
			aRecord.servers.create(:name => "奥妮克希亚", :game_id => game741.id)
			aRecord.servers.create(:name => "日落沼泽", :game_id => game741.id)
			aRecord.servers.create(:name => "地狱吼", :game_id => game741.id)
			aRecord.servers.create(:name => "暗影之月", :game_id => game741.id)
			aRecord.servers.create(:name => "尖石", :game_id => game741.id)
			aRecord.servers.create(:name => "狂热之刃", :game_id => game741.id)
			aRecord.servers.create(:name => "巴纳札尔", :game_id => game741.id)
			aRecord.servers.create(:name => "水晶之刺", :game_id => game741.id)
			aRecord.servers.create(:name => "天空之墙", :game_id => game741.id)
			aRecord.servers.create(:name => "寒冰皇冠", :game_id => game741.id)
			aRecord.servers.create(:name => "阿萨斯", :game_id => game741.id)
			aRecord.servers.create(:name => "众星之子", :game_id => game741.id)
			aRecord.servers.create(:name => "银翼要塞", :game_id => game741.id)
			aRecord.servers.create(:name => "诺姆瑞根", :game_id => game741.id)
			aRecord.servers.create(:name => "战歌", :game_id => game741.id)
			aRecord.servers.create(:name => "世界之树", :game_id => game741.id)
			aRecord.servers.create(:name => "雷鳞", :game_id => game741.id)
			aRecord.servers.create(:name => "巨龙之喉", :game_id => game741.id)
			aRecord.servers.create(:name => "冰霜之刺", :game_id => game741.id)
			aRecord.servers.create(:name => "鬼雾峰", :game_id => game741.id)
			aRecord.servers.create(:name => "屠魔山谷", :game_id => game741.id)
			aRecord.servers.create(:name => "米奈希尔", :game_id => game741.id)
			aRecord.servers.create(:name => "冰风岗哨", :game_id => game741.id)
			aRecord.servers.create(:name => "愤怒使者", :game_id => game741.id)
			aRecord.servers.create(:name => "圣光之愿", :game_id => game741.id)
			aRecord.servers.create(:name => "夜空之歌", :game_id => game741.id)
			aRecord.servers.create(:name => "暴风祭坛", :game_id => game741.id)
			aRecord.servers.create(:name => "撒尔萨里安", :game_id => game741.id)
			aRecord.servers.create(:name => "凛风峡湾", :game_id => game741.id)
			aRecord.servers.create(:name => "狂心", :game_id => game741.id)
			aRecord.servers.create(:name => "逺祖灘頭", :game_id => game741.id)
			aRecord.servers.create(:name => "奈辛瓦里", :game_id => game741.id)
			aRecord.servers.create(:name => "死亡之翼", :game_id => game741.id)
			aRecord.servers.create(:name => "黑龙军团", :game_id => game741.id)
			aRecord.servers.create(:name => "科爾蘇加德", :game_id => game741.id)
			aRecord.servers.create(:name => "惡魔之魂", :game_id => game741.id)
			aRecord.servers.create(:name => "提克迪奧斯", :game_id => game741.id)
    GameRace.create(
        :name => "德莱尼",
        :game_id => game741.id)
    GameRace.create(
        :name => "矮人",
        :game_id => game741.id)
    GameRace.create(
        :name => "侏儒",
        :game_id => game741.id)
    GameRace.create(
        :name => "人类",
        :game_id => game741.id)
    GameRace.create(
        :name => "暗夜精灵",
        :game_id => game741.id)
    GameRace.create(
        :name => "血精灵",
        :game_id => game741.id)
    GameRace.create(
        :name => "兽人",
        :game_id => game741.id)
    GameRace.create(
        :name => "牛头人",
        :game_id => game741.id)
    GameRace.create(
        :name => "巨魔",
        :game_id => game741.id)
    GameRace.create(
        :name => "亡灵",
        :game_id => game741.id)
    GameProfession.create(
        :name => "德鲁伊",
        :game_id => game741.id)
    GameProfession.create(
        :name => "猎人",
        :game_id => game741.id)
    GameProfession.create(
        :name => "法师",
        :game_id => game741.id)
    GameProfession.create(
        :name => "圣骑士",
        :game_id => game741.id)
    GameProfession.create(
        :name => "牧师",
        :game_id => game741.id)
    GameProfession.create(
        :name => "潜行者",
        :game_id => game741.id)
    GameProfession.create(
        :name => "萨满祭司",
        :game_id => game741.id)
    GameProfession.create(
        :name => "术士",
        :game_id => game741.id)
    GameProfession.create(
        :name => "战士",
        :game_id => game741.id)
  end

  def self.down
  end
end
