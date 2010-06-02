namespace :juggernaut do

  desc "删除所有在线记录"
  task :delete_all_online_records => :environment do
    OnlineUser.destroy_all
  end

end
