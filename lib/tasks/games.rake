namespace :games do 

  desc "更新游戏的角色计数器"
  task :update_last_week_characters_count => :environment do 
    Game.update_all("last_week_characters_count = characters_count")
  end

  desc "更新游戏的关注计数器"
  task :update_last_week_attentions_count => :environment do
    Game.update_all("last_week_attentions_count = attentions_count")
  end

end
