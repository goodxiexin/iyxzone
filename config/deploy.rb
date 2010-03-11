set :application, "17gaming"
set :domain,      "deployer@17gaming.com"
set :repository,  "http://github.com/gaoxh04/iyxzone.git"
set :use_sudo,    false
set :deploy_to,   "/home/deployer/#{application}"
set :scm,         "git"

role :app, domain
role :web, domain
role :db,  domain, :primary => true


after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do

  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
  
end
