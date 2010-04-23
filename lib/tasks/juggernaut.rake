namespace :juggernaut do

  desc "提醒要维护了"
  task :send_maintainence_notification => :environment do
    Juggernaut.send_to_all "alert('网站即将进入维护,带来不便请多包涵')"
  end

  desc "删除所有在线用户"
  task :delete_all_online_records => :environment do
    OnlineUser.destroy_all
  end

end
