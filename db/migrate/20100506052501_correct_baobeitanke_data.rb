class CorrectBaobeitankeData < ActiveRecord::Migration
  def self.up
		aGame = Game.find(:first, :conditions => ["name = ?","宝贝坦克"])
		aGame.races.clear
		aGame.races_count = 0
		aGame.professions.clear
		aGame.professions_count = 0
		aGame.save

		aGame = Game.find(:first, :conditions => ["name = ?","梦想世界"])
		GameProfession.create(
        :name => "剑",
        :game_id => aGame.id)
		GameProfession.create(
        :name => "笔",
        :game_id => aGame.id)
		GameProfession.create(
        :name => "拳",
        :game_id => aGame.id)
		GameProfession.create(
        :name => "刀",
        :game_id => aGame.id)
		GameProfession.create(
        :name => "枪",
        :game_id => aGame.id)
		GameProfession.create(
        :name => "佛家",
        :game_id => aGame.id)
		GameProfession.create(
        :name => "道家",
        :game_id => aGame.id)
		GameProfession.create(
        :name => "儒家",
        :game_id => aGame.id)
		GameProfession.create(
        :name => "阴阳",
        :game_id => aGame.id)
		GameProfession.create(
        :name => "巫术",
        :game_id => aGame.id)
		anArea = GameArea.create(:name => '电信区', :game_id => aGame.id)
		anArea.servers.create(:name => '笑傲江湖', :game_id => aGame.id)
		anArea.servers.create(:name => '花好月圆', :game_id => aGame.id)
		anArea.servers.create(:name => '星光灿烂', :game_id => aGame.id)
		anArea = GameArea.create(:name => '网通区', :game_id => aGame.id)
		anArea.servers.create(:name => '花好月圆', :game_id => aGame.id)
		anArea.servers.create(:name => '皇朝霸业', :game_id => aGame.id)
		anArea = GameArea.create(:name => '江苏专区', :game_id => aGame.id)
		anArea.servers.create(:name => '姑苏细雨', :game_id => aGame.id)
		anArea.servers.create(:name => '瘦西湖', :game_id => aGame.id)
		anArea.servers.create(:name => '凤凰岛', :game_id => aGame.id)
		anArea.servers.create(:name => '缥缈峰', :game_id => aGame.id)
		anArea.servers.create(:name => '狮子林', :game_id => aGame.id)
		anArea = GameArea.create(:name => '电信华南区', :game_id => aGame.id)
		anArea.servers.create(:name => '天下无双', :game_id => aGame.id)
		anArea.servers.create(:name => '梦里水乡', :game_id => aGame.id)
		anArea.servers.create(:name => '武夷山', :game_id => aGame.id)
		anArea.servers.create(:name => '光辉岁月', :game_id => aGame.id)
		anArea.servers.create(:name => '鼓浪屿', :game_id => aGame.id)
		anArea = GameArea.create(:name => '电信华东区', :game_id => aGame.id)
		anArea.servers.create(:name => '东方之珠', :game_id => aGame.id)
		anArea.servers.create(:name => '锦绣河山', :game_id => aGame.id)
		anArea.servers.create(:name => '上海滩', :game_id => aGame.id)
		anArea = GameArea.create(:name => '网通华北区', :game_id => aGame.id)
		anArea.servers.create(:name => '碧血丹心', :game_id => aGame.id)
		anArea.servers.create(:name => '王府井', :game_id => aGame.id)
		anArea.servers.create(:name => '避暑山庄', :game_id => aGame.id)
		anArea = GameArea.create(:name => '浙江专区', :game_id => aGame.id)
		anArea.servers.create(:name => '桃花岛', :game_id => aGame.id)
		anArea.servers.create(:name => '钱塘涌潮', :game_id => aGame.id)
		anArea.servers.create(:name => '三潭印月', :game_id => aGame.id)
		anArea.servers.create(:name => '千岛湖', :game_id => aGame.id)
		anArea.servers.create(:name => '灵隐寺', :game_id => aGame.id)
		anArea.servers.create(:name => '天一阁', :game_id => aGame.id)
		anArea.servers.create(:name => '西子湖', :game_id => aGame.id)
		anArea.servers.create(:name => '神仙居', :game_id => aGame.id)
		anArea.servers.create(:name => '六合塔', :game_id => aGame.id)
		anArea.servers.create(:name => '普陀山', :game_id => aGame.id)
		anArea = GameArea.create(:name => '电信华中区', :game_id => aGame.id)
		anArea.servers.create(:name => '黄鹤楼', :game_id => aGame.id)
		anArea.servers.create(:name => '吉祥如意', :game_id => aGame.id)
		anArea.servers.create(:name => '国色天香', :game_id => aGame.id)
		anArea.servers.create(:name => '武当山', :game_id => aGame.id)
		anArea.servers.create(:name => '神农架', :game_id => aGame.id)
		anArea.servers.create(:name => '晴川阁', :game_id => aGame.id)
		anArea.servers.create(:name => '东坡赤壁', :game_id => aGame.id)
		anArea = GameArea.create(:name => '山东专区', :game_id => aGame.id)
		anArea.servers.create(:name => '泰山封禅', :game_id => aGame.id)
		anArea.servers.create(:name => '趵突泉', :game_id => aGame.id)
		anArea.servers.create(:name => '日月争辉', :game_id => aGame.id)
		anArea.servers.create(:name => '大明湖', :game_id => aGame.id)
		anArea.servers.create(:name => '千佛山', :game_id => aGame.id)
		anArea.servers.create(:name => '红叶谷', :game_id => aGame.id)
		anArea.servers.create(:name => '万寿宫', :game_id => aGame.id)
		anArea.servers.create(:name => '南天门', :game_id => aGame.id)
		anArea.servers.create(:name => '蓬莱仙境', :game_id => aGame.id)
		anArea.servers.create(:name => '彩虹谷', :game_id => aGame.id)
		anArea.servers.create(:name => '水泊梁山', :game_id => aGame.id)
		anArea = GameArea.create(:name => '广东专区', :game_id => aGame.id)
		anArea.servers.create(:name => '白云山', :game_id => aGame.id)
		anArea.servers.create(:name => '欢乐谷', :game_id => aGame.id)
		anArea.servers.create(:name => '情满珠江', :game_id => aGame.id)
		anArea.servers.create(:name => '状元坊', :game_id => aGame.id)
		anArea.servers.create(:name => '世界之窗', :game_id => aGame.id)
		anArea.servers.create(:name => '七星岩', :game_id => aGame.id)
		anArea.servers.create(:name => '如意岛', :game_id => aGame.id)
		anArea.servers.create(:name => '丹霞山', :game_id => aGame.id)
		anArea.servers.create(:name => '东湖春晓', :game_id => aGame.id)
		anArea.servers.create(:name => '宝墨园', :game_id => aGame.id)
		anArea.servers.create(:name => '越秀山', :game_id => aGame.id)
		anArea.servers.create(:name => '碧水湾', :game_id => aGame.id)
		anArea.servers.create(:name => '南澳岛', :game_id => aGame.id)
		anArea.servers.create(:name => '十香园', :game_id => aGame.id)
		anArea = GameArea.create(:name => '河南专区', :game_id => aGame.id)
		anArea.servers.create(:name => '洛阳牡丹', :game_id => aGame.id)
		anArea = GameArea.create(:name => '网通东北区', :game_id => aGame.id)
		anArea.servers.create(:name => '葫芦岛', :game_id => aGame.id)
		anArea.servers.create(:name => '红海滩', :game_id => aGame.id)
		anArea.servers.create(:name => '棋盘山', :game_id => aGame.id)
		anArea.servers.create(:name => '鸭绿江', :game_id => aGame.id)
		anArea = GameArea.create(:name => '双线区', :game_id => aGame.id)
		anArea.servers.create(:name => '龙腾四海', :game_id => aGame.id)
		anArea.servers.create(:name => '花样年华', :game_id => aGame.id)
  end

  def self.down
  end
end
