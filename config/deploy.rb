#
# 说明：
# 网站代码所在的目录是/home/deployer，deployer用户不是root权限，这是出于安全考虑
# 但是配置很多地方需要root权限，因此，配置的时候我们用root权限，配置好了后，我们改回deployer权限
#
set :application, "17gaming"
set :domain,      "root@17gaming.com"
set :repository,  "git://github.com/gaoxh04/iyxzone.git"
set :use_sudo,    false
set :deploy_to,   "/home/deployer/#{application}"
set :scm,         "git"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

after "deploy:update_code", "deploy:chown_deployer"
after "deploy:update_code", "deploy:update_crontab"
after "deploy:symlink", "deploy:symlink_photos"

namespace :deploy do

  task :start, :roles => :app do
  end

  task :stop, :roles => :app do
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :update_crontab, :roles => :app do
    run "cd #{release_path} && whenever --update-crontab"
  end

  task :chown_deployer, :roles => :app do
    run "cd /home/deployer && chown -R deployer:deployer 17gaming"
  end

  task :symlink_photos, :roles => :app do
    run "rm -rf #{release_path}/public/photos"
    run "ln -nfs #{shared_path}/index #{release_path}/public/photos"
  end
  
end

namespace :web do

  task :disable, :roles => :web do
    require 'erb'
    on_rollback { run "rm #{shared_path}/system/maintenance.html" }
    reson = ENV['REASON']
    deadline = ENV['UNTIL']
    template = File.read("app/views/maintenance.html.erb" )
    page = ERB.new(template).result(binding)
    put page, "#{shared_path}/system/maintenance.html", :mode => 0644
    run "chown deployer:deployer #{shared_path}/system/maintenance.html"
  end

  task :enable, :roles => :web do
    run "rm #{shared_path}/system/maintenance.html"
  end

end
