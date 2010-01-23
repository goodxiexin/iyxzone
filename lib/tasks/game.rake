namespace :game do 

  task :update_last_week_characters_count => :environment do 
    Game.update_all("last_week_characters_count = characters_count")
  end

end
