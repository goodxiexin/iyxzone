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


after "deploy:update_code", "deploy:update_crontab"
after "deploy:update_code", "deploy:update_database_config"
after "deploy:update_code", "deploy:update_mail_config"
after "deploy:update_code", "deploy:update_juggernaut_config"
after "deploy:update_code", "deploy:add_timestamps_to_css"
after "deploy:update_code", "deploy:pack_js"

after "deploy:symlink", "assets:symlink"
after "deploy:symlink", "deploy:chown_deployer"

namespace :deploy do

  desc "start application"
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "stop application"
  task :stop, :roles => :app do
    # NOTHING TO DO
  end

  desc "restart application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "regenerate periodical tasks configuration"
  task :update_crontab, :roles => :app do
    run "cd #{release_path} && whenever -w"
  end

  desc "change owner to deployer"
  task :chown_deployer, :roles => :app do
    run "cd /home/deployer && chown -R deployer:deployer 17gaming"
  end

  desc "add timestamps to css images, so that cache can be invalidated"
  task :add_timestamps_to_css, :roles => :app do
    # TODO
  end

  desc "build all js"
  task :pack_js, :roles => :app do
    run "cd #{current_release} && rake asset:packager:build_all"
  end
 
  desc "update database configuration"
  task :update_database_config, :roles => :app do
    database_config = <<-CMD
development:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: one_seven_gaming_development
  pool: 5
  username: root
  password: 20041065
  socket: /var/lib/mysql/mysql.sock
production:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: one_seven_gaming_production
  pool: 5
  username: root
  password: 20041065
  socket: /var/lib/mysql/mysql.sock
test:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: one_seven_gaming_test
  pool: 5
  username: root
  password: 20041065
  socket: /var/lib/mysql/mysql.sock
    CMD
    put database_config, "#{release_path}/config/database.yml"
  end

  desc "update mail configuration"
  task :update_mail_config, :roles => :app do
    mail_config = <<-CMD
ActionMailer::Base.default_content_type = 'text/html'
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com", 
  :port => 587, 
  :enable_starttls_auto => true,
  :domain => "17gaming.com", 
  :authentication => :plain,
  :user_name => "daye@17gaming.com", 
  :password => "20041065"
}
ActionMailer::Base.delivery_method = :activerecord
    CMD
    put mail_config, "#{release_path}/config/initializers/mail.rb"
  end
   
  desc "update juggernaut configuration"
  task :update_juggernaut_config, :roles => :app do
    juggernaut_config = <<-CMD
:subscription_url:  http://localhost/juggernaut/subscription
:allowed_ips:
  - 127.0.0.1
:logout_url: http://localhost/juggernaut/logout
:port: 5001
    CMD
    put juggernaut_config, "#{release_path}/juggernaut.yml"
    juggernaut_hosts_config = <<-CMD
:hosts:
  - :port: 5001
    :host: 127.0.0.1
    :public_host: 112.65.248.180
    :environment: :production
    CMD
    put juggernaut_hosts_config, "#{release_path}/config/juggernaut_hosts.yml"
  end

end

namespace :assets do

  ASSETS = %w(photos game_details area_details regions cities blog_images news_pictures)

  desc "preserve resources across deployment"
  task :symlink, :roles => :app do
    ASSETS.each do |name|
      run "mkdir -p #{shared_path}/#{name} && rm -rf #{release_path}/public/#{name} && ln -nfs #{shared_path}/#{name} #{release_path}/public/#{name}"
    end
    deploy.chown_deployer
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
