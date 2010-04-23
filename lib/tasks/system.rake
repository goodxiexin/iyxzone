namespace :system do

  desc "提醒要维护了"
  task :send_maintainence_notification => :environment do
    Juggernaut.send_to_all "alert('网站即将进入维护,带来不便请多包涵')"
  end

end
