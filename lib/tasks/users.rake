namespace :users do

  desc "提示那些很久没上线的人"
  task :send_long_time_no_seen => :environment do 
    users = User.find(:all, :conditions => ["last_seen_at <= ?", 1.week.ago.to_s(:db)])
    puts "send mail to #{users.map(&:id).join(',')}"
    users.each do |user|
      UserMailer.deliver_long_time_no_seen user
    end
  end

end
