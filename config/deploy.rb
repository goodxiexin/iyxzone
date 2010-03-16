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
after "deploy:update_code", "deploy:update_database_config"

after "deploy:symlink", "assets:symlink"

namespace :deploy do

  task :start, :roles => :app do
  end

  task :stop, :roles => :app do
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "regenerate periodical tasks configuration"
  task :update_crontab, :roles => :app do
    run "cd #{release_path} && whenever --update-crontab"
  end

  desc "change owner to deployer"
  task :chown_deployer, :roles => :app do
    run "cd /home/deployer && chown -R deployer:deployer 17gaming"
  end
 
  desc "update database configuration"
  task :update_database_config, :roles => :app do
    database_config = <<-CMD
      production:
        adapter: mysql
        encoding: utf8
        reconnect: false
        database: one_seven_gaming_production
        pool: 5
        username: root
        password: 20041065
        socket: /var/lib/mysql/mysql.sock
    CMD
    put database_config, "#{release_path}/config/database.yml"
  end
 
end

namespace :assets do

  ASSETS = %w(photos)

  desc "preserve resources across deployment"
  task :symlink, :roles => :app do
    ASSETS.each do |name|
      run "mkdir -p #{shared_path}/#{name} && rm -rf #{release_path}/public/#{name} && ln -nfs #{shared_path}/#{name} #{release_path}/public/#{name}"
    end
  end

end

namespace :web do

  desc "temporarily shutdown our website"
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

  desc "enable our website"
  task :enable, :roles => :web do
    run "rm #{shared_path}/system/maintenance.html"
  end

end
