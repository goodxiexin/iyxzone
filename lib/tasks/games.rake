namespace :games do 

  desc "更新游戏的角色计数器"
  task :update_last_week_characters_count => :environment do 
    Game.update_all("last_week_characters_count = characters_count")
  end

  desc "更新游戏的关注计数器"
  task :update_last_week_attentions_count => :environment do
    Game.update_all("last_week_attentions_count = attentions_count")
  end

	# 适用对象 1， 新游戏 2， 老游戏加新服务器或者区
	# Warning:　不适用于更改已有的错误信息，或者服务区/器有本质改变的情况，这种情况应该在新增的时候杜绝
	# 方法:　新增游戏时，如果是内测游戏，服务器/区将带上内测的标识，这样以后就不用删减这些服务器/区
	#				 公测的游戏在服务器上应该不会有本质的改变，所以可以按照正常统计（如果有就去日做设定的家伙）
	# 文件格式:　（有服务区）游戏区:　服务器1,　服务器2, 服务器3   （没有服务区） 服务器1,　服务器2,　服务器3
	#　				: and , 都是英文半角的。但是有一定的自动纠错功能（只要误差是全角跟半角之间）
	desc "根据新的文件更新相关游戏"
	task :update_new_games_data => :environment do
		basedir = "./newgameinfo/"
		files = Dir.glob(basedir + "*.txt")	
		game_file = File.new( Date.today.to_s + "_game_update",  File::WRONLY|File::APPEND|File::CREAT)
		files.each do |filename|
			game_name = filename[basedir.length,filename.length].chomp(".txt")
			game = Game.find_by_name(game_name)
			# if game exist
			if game
				game_file.puts "game_id = Game.find(:first, :conditions => [\"name = ?\",\"#{game_name}\"]).id"
			else
				game_file.puts "this_game = Game.create(
				:name => \"#{game_name}\",
				:official_web => \"\",
				:sale_date => \"\",
				:company => \"\",
				:agent => \"\",
				:description => \"\")"
				game_file.puts "this_game.tag_list = \"\""
				game_file.puts "this_game.save"
				game_file.puts "game_id = this_game.id"
			end
			file = File.new(filename,"r")
			while (line = file.gets)
				lineInfo = line.strip
				# 全角换成半角
				if lineInfo.include?("：")
					lineInfo[lineInfo.index("：")] = ":"
				end
				while lineInfo.include?("，")
					lineInfo[lineInfo.index("，")] = ","
				end
				# this game has Area
				if lineInfo.include?(":")
					game_info_array = lineInfo.split(":")
					game_area = game_info_array[0]
					if (game and !game.areas.match("name"=>game_area).empty?)
						game_file.puts "this_area = GameArea.find(:first, :conditions => [\"name = ? and game_id = ?\",\"#{game_area}\",game_id])"
					else
						game_file.puts "this_area = GameArea.create( :name => '#{game_area}', :game_id => game_id)"
					end
					game_servers = game_info_array[1].split(",")
					game_servers.each do |gs|
						gs_name = gs.strip
						game_file.puts "this_area.servers.create( :name => '#{gs_name}', :game_id => game_id)"
					end
				else
					game_servers = lineInfo.split(",")
					game_servers.each do |gs|
						gs_name = gs.strip
						game_file.puts "GameServer.create( :name => '#{gs_name}', :game_id => game_id)"
					end
				end
			end
			file.close
		end
		game_file.close
	end

  desc "显示不干净的数据"
  task :show_dirty_data => :environment do
    games = Game.all.map(&:name) - Game.all.map(&:name).uniq

    ret = [] 
    GameArea.all.select do |a|
      dups = []
      a.servers.group_by(&:name).each do |name, servers|
        dups << name if servers.count > 1
      end
      if !dups.blank?
        ret << [a, dups]
      end
    end
    puts "server重复的有#{ret.count}个"
    if !ret.blank?
      ret.each do |r|
        puts "ID: #{r[0].id}, game: #{r[0].game.name}, area: #{r[0].name}, duplicated_servers: #{r[1].join(',')}"
      end
    end

    ret = [] 
    Game.all.select do |g|
      if !g.no_areas
        dups = []
        g.areas.group_by(&:name).each do |name, areas|
          dups << name if areas.count > 1
        end
        if !dups.blank?
          ret << [g, dups]
        end
      end
    end
    puts "area重复的有#{ret.count}个"
    if !ret.blank?
      ret.each do |r|
        puts "ID: #{r[0].id}, game: #{r[0].name}, duplicated_areas: #{r[1].join(',')}"
      end
    end

    ret = [] 
    Game.all.select do |g|
      if !g.no_races
        dups = []
        g.races.group_by(&:name).each do |name, races|
          dups << name if races.count > 1
        end
        if !dups.blank?
          ret << [g, dups]
        end
      end
    end
    puts "race重复的有#{ret.count}个"
    if !ret.blank?
      ret.each do |r|
        puts "ID: #{r[0].id}, game: #{r[0].name}, duplicated_races: #{r[1].join(',')}"
      end
    end

    ret = [] 
    Game.all.select do |g|
      if !g.no_professions
        dups = []
        g.professions.group_by(&:name).each do |name, professions|
          dups << name if professions.count > 1
        end
        if !dups.blank?
          ret << [g, dups]
        end
      end
    end
    puts "profession重复的有#{ret.count}个"
    if !ret.blank?
      ret.each do |r|
        puts "ID: #{r[0].id}, game: #{r[0].name}, duplicated_professions: #{r[1].join(',')}"
      end
    end

  end

  desc "对不干净的数据进行修正"
  task :correct_dirty_data => :environment do
    Game.all.each do |g|
      # 修正no_servers
      if g.servers.count == 0 and !g.no_servers
        g.no_servers = true
      elsif g.servers.count != 0 and g.no_servers
        g.no_servers = false
      end

      # 修正no_areas
      if g.areas.count == 0 and !g.no_areas
        g.no_areas = true
      elsif g.areas.count != 0 and g.no_areas
        g.no_areas = false
      end

      # 修正no_races
      if g.races.count == 0 and !g.no_races
        g.no_races = true
      elsif g.races.count != 0 and g.no_races
        g.no_races = false
      end

      # 修正no_professions
      if g.professions.count == 0 and !g.no_professions
        g.no_professions = true
      elsif g.professions.count != 0 and g.no_professions
        g.no_professions = false
      end

      # 修正server输入2遍的
      # 不太好检查，很多server名字都一样
      # 修正area 输入2遍的
      # 修正race 输入2遍的
      # 修正profession输入2遍的
    end
  end

end
