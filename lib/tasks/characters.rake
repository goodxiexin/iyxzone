namespace :characters do

  task :main_index => :environment do
    GameCharacter.build_main_index
    `chown deployer:deployer #{GameCharacter.index_dir} -R`
  end

  task :delta_index => :environment do
    GameCharacter.build_delta_index 
    `chown deployer:deployer #{GameCharacter.index_dir} -R`
  end

end
