require 'pty'
require 'expect'

def exec_as user_name, &block
  `su #{user_name}`
  yield
  `exit`
end

namespace :utils do

  desc "处理日志"
  task :tail_log => :environment do
    `mv #{RAILS_ROOT}/log/production.log /tmp/log/#{Time.now.strftime("%Y-%m-%d")}.log`
    `touch #{RAILS_ROOT}/log/production.log`
  end

  desc "重启所有rails需要的程序"
  task :restart => :environment do
    exec_as "root" do
      # restart mysql
      puts `service mysqld restart`
      # restart httpd
      puts `service httpd restart`
      # restart postfix
      puts `service postfix restart`
      # restart impad
      puts `service cyrus-imapd restart`
      # synchronize time
      puts `ntpdate 0.centos.pool.ntp.org`
      # start memcached
      puts `memcached -m 256 -u deployer`
    end
    exec_as "deployer" do
      # juggernaut
      puts `juggernaut -c juggernaut.yml -P tmp/pids/juggernaut.yml -l log/juggernaut.log -d`
    end
  end

end
