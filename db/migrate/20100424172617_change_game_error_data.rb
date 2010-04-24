class ChangeGameErrorData < ActiveRecord::Migration
# ths migration is only for Production server
  def self.up

		#ID: 32, game: 寻仙, duplicated_areas: 东北区
		anArea = GameArea.find(496)
		anArea.name = "广东区"
		anArea.save


		#ID: 294, game: 星尘传说, duplicated_professions: 刺客
		aProfession = GameProfession.find(1290)
		aProfession.destroy

		#ID: 147, game: 海盗王online, duplicated_professions: 航海士
		aProfession = GameProfession.find(723)
		aProfession.name = "剑士"
		aProfession.save

		#ID: 127, game: 风云, duplicated_areas: (5区)电信
		anArea = GameArea.find(1127)
		anArea.name = '(6区)电信'
		anArea.save

		#ID: 350, game: 龙的传人, duplicated_races: 人族
		aRace = GameRace.find(77)
		aRace.name = "妖族"
		aRace.save

		#ID: 846, game: 天龙八部, area: 网通专区, duplicated_servers: 百泉书院
		aServer = GameServer.find(4020)
		if aServer.characters.empty?
			aServer.destroy
		else
			puts "服务器删除有问题 Name: #{aServer.name}, ID: #{aServer.id}"
		end

		#ID: 1638, game: 机战, area: 第四十大区(重装战神电信2), duplicated_servers: 战神新六区电信
		aServer = GameServer.find(7090)
		if aServer.characters.empty?
			aServer.destroy
		else
			puts "服务器删除有问题 Name: #{aServer.name}, ID: #{aServer.id}"
		end

		#ID: 2313, game: 功夫小子, area: 99宿舍校园网专区, duplicated_servers: 99宿舍校园网专区
		aServer = GameServer.find(9751)
		if aServer.characters.empty?
			aServer.destroy
		else
			puts "服务器删除有问题 Name: #{aServer.name}, ID: #{aServer.id}"
		end

		#ID: 2310, game: 功夫小子, area: 一区（全国电信）, duplicated_servers: 一区（全国电信）
		aServer = GameServer.find(9748)
		if aServer.characters.empty?
			aServer.destroy
		else
			puts "服务器删除有问题 Name: #{aServer.name}, ID: #{aServer.id}"
		end

		#ID: 2337, game: 梦幻国度, area: 快乐女生, duplicated_servers: 小熊猫
		aServer = GameServer.find(9787)
		if aServer.characters.empty?
			aServer.destroy
		else
			puts "服务器删除有问题 Name: #{aServer.name}, ID: #{aServer.id}"
		end

		#ID: 2379, game: 精武世界, area: 电信 新手频道, duplicated_servers: 华东一区
		aServer = GameServer.find(9896)
		if aServer.characters.empty?
			aServer.destroy
		else
			puts "服务器删除有问题 Name: #{aServer.name}, ID: #{aServer.id}"
		end

		#ID: 2588, game: 梦幻龙族传说(台), area: 台湾, duplicated_servers: 红海星/火焰龙
		aServer = GameServer.find(10718)
		if aServer.characters.empty?
			aServer.destroy
		else
			puts "服务器删除有问题 Name: #{aServer.name}, ID: #{aServer.id}"
		end

		#ID: 63, game: 兽血沸腾, duplicated_areas: 电信一区,电信二区,电信三区,电信四区,电信五区,电信六区,电信七区,电信八区,电信九区,电信十区,电信十一区,电信十二区,电信十三区,网通一区,网通二区,网通三区,网通四区,网通五区,网通六区
		for i in (2644..2662)
			anArea = GameArea.find(i)
			if anArea.characters.empty?
				anArea.destroy
			else
				puts "区域删除有问题 Name: #{anArea.name}, ID: #{anArea.id}"
			end
		end

		#ID: 64, game: 英雄无敌online, duplicated_areas: 电信一区,电信二区,网通一区
		for i in (1220..1222)
			anArea = GameArea.find(i)
			if anArea.characters.empty?
				anArea.destroy
			else
				puts "区域删除有问题 Name: #{anArea.name}, ID: #{anArea.id}"
			end
		end

		#ID: 65, game: 霸王2, duplicated_areas: 电信,网通
		for i in (1496..1497)
			anArea = GameArea.find(i)
			if anArea.characters.empty?
				anArea.destroy
			else
				puts "区域删除有问题 Name: #{anArea.name}, ID: #{anArea.id}"
			end
		end

		#ID: 66, game: 洛奇, duplicated_areas: 电信,网通
		for i in (2039..2040)
			anArea = GameArea.find(i)
			if anArea.characters.empty?
				anArea.destroy
			else
				puts "区域删除有问题 Name: #{anArea.name}, ID: #{anArea.id}"
			end
		end
	
		#ID: 68, game: 大海战2, duplicated_areas: 网通区,电信区,华南区
		for i in (1483..1485)
			anArea = GameArea.find(i)
			if anArea.characters.empty?
				anArea.destroy
			else
				puts "区域删除有问题 Name: #{anArea.name}, ID: #{anArea.id}"
			end
		end
	
		#ID: 71, game: 预言online, duplicated_areas: （怀旧版）电信一区,（怀旧版）网通一区,（万人版）开天辟地,（万人版）王者归来,君临天下,（万人版）叱诧风云,（万人版）神话传奇,（万人版）英雄无敌,（万人版）兵临城下,（万人版）硝烟弥漫,（万人版）万马奔腾,（经典版）电信区,（经典版）网通区
		for i in (2081..2093)
			anArea = GameArea.find(i)
			if anArea.characters.empty?
				anArea.destroy
			else
				puts "区域删除有问题 Name: #{anArea.name}, ID: #{anArea.id}"
			end
		end
	
		#ID: 73, game: 新飞飞, duplicated_areas: 星梦奇缘,塔罗异界,混沌学院,南冕座,赤焰座,火云座,北冕座,北辰座,双鱼座
		for i in (2517..2525)
			anArea = GameArea.find(i)
			if anArea.characters.empty?
				anArea.destroy
			else
				puts "区域删除有问题 Name: #{anArea.name}, ID: #{anArea.id}"
			end
		end
	
		#ID: 87, game: 西游Q版, duplicated_areas: 电信一区,电信二区,网通一区,网通二区
		for i in (2240..2243)
			anArea = GameArea.find(i)
			if anArea.characters.empty?
				anArea.destroy
			else
				puts "区域删除有问题 Name: #{anArea.name}, ID: #{anArea.id}"
			end
		end
	
		#ID: 140, game: 烽火情缘, duplicated_areas: 电信
			anArea = GameArea.find(2492)
			if anArea.characters.empty?
				anArea.destroy
			else
				puts "区域删除有问题 Name: #{anArea.name}, ID: #{anArea.id}"
			end
	
		#ID: 28, game: 剑侠情缘网络版（收费版）, duplicated_professions: 武当,天王,峨嵋,天忍,唐门,翠烟,丐帮,昆仑,五毒,少林
		for i in (331..340)
			aProfession = GameProfession.find(i)
			if aProfession.characters.empty?
				aProfession.destroy
			else
				puts "职业删除有问题 Name: #{aProfession.name}, ID: #{aProfession.id}"
			end
		end
	
		#ID: 342, game: 倩女幽魂, duplicated_professions: 射手,甲士,刀客,侠客,方士,医师,魅者,异人
		for i in (2042..2049)
			aProfession = GameProfession.find(i)
			if aProfession.characters.empty?
				aProfession.destroy
			else
				puts "职业删除有问题 Name: #{aProfession.name}, ID: #{aProfession.id}"
			end
		end
	
		#ID: 347, game: 三国光速版, duplicated_professions: 猛将,豪杰,军师,方士
		for i in (1607..1610)
			aProfession = GameProfession.find(i)
			if aProfession.characters.empty?
				aProfession.destroy
			else
				puts "职业删除有问题 Name: #{aProfession.name}, ID: #{aProfession.id}"
			end
		end
	
  end

  def self.down
  end
end
