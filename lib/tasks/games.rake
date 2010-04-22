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
