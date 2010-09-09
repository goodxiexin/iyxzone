namespace :characters do

  task :main_index => :environment do
    GameCharacter.build_main_index
    `chown deployer:deployer #{File.join(RAILS_ROOT, GameCharacter.index_dir)}`
  end

  task :delta_index => :environment do
    GameCharacter.build_delta_index 
    `chown deployer:deployer #{File.join(RAILS_ROOT, GameCharacter.index_dir)}`
  end

end
