namespace :games do 

  desc "更新游戏的角色计数器"
  task :update_last_week_characters_count => :environment do 
    Game.update_all("last_week_characters_count = characters_count")
  end

  desc "更新游戏的关注计数器"
  task :update_last_week_attentions_count => :environment do
    Game.update_all("last_week_attentions_count = attentions_count")
  end

  desc "显示不干净的数据"
  task :show_dirty_data => :environment do
    games = Game.all.select {|g| ((g.servers.count != 0) and g.no_servers) or ((g.servers.count == 0) and !g.no_servers)}
    puts "no_servers标志位不对的有#{games.count}个"
    if !games.blank?
      games.each do |g|
        puts "ID: #{g.id}, name: #{g.name}, no_servers: #{g.no_servers}, servers.count: #{g.servers.count}"
      end
    end

    games = Game.all.select {|g| ((g.areas.count != 0) and g.no_areas) or ((g.areas.count == 0) and !g.no_areas)}
    puts "no_areas标志位不对的有#{games.count}个"
    if !games.blank?
      games.each do |g|
        puts "ID: #{g.id}, name: #{g.name}, no_areas: #{g.no_areas}, areas.count: #{g.areas.count}"
      end
    end

    games = Game.all.select {|g| ((g.races.count != 0) and g.no_races) or ((g.races.count == 0) and !g.no_races)}
    puts "no_races标志位不对的有#{games.count}个"
    if !games.blank?
      games.each do |g|
        puts "ID: #{g.id}, name: #{g.name}, no_races: #{g.no_races}, races.count: #{g.races.count}"
      end
    end

    games = Game.all.select {|g| ((g.professions.count != 0) and g.no_professions) or ((g.professions.count == 0) and !g.no_professions)}
    puts "no_professions标志位不对的有#{games.count}个"
    if !games.blank?
      games.each do |g|
        puts "ID: #{g.id}, name: #{g.name}, no_professions: #{g.no_professions}, professions.count: #{g.professions.count}"
      end
    end

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
