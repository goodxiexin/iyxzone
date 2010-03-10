namespace :event do

  task :send_long_time_no_seen => :environment do 
    users = User.find(:all, :conditions => ["last_seen_at <= ?", 1.week.ago.to_s(:db)])
    users.each do |user|
      UserMailer.deliver_long_time_no_seen user
    end
  end

end
