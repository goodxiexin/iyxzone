namespace :events do
 
  desc "在活动要开始的前一天，发送提示邮件"
  task :send_approaching_notification => :environment do 
    events = Event.find(:all, :conditions => ["start_time <= ?", 1.days.from_now.beginning_of_day.to_s(:db)])
    events.each do |event|
      event.participants.each do |user|
        EventMailer.deliver_approaching_notification event, user
      end
    end
  end

  desc "过期活动的garbage collection, 不过由于目前允许过期活动仍然能够接受邀请，所以没啥可作的"
	task :clean_expired_events => :environment do
    # nothing to do right now 
	end

end
