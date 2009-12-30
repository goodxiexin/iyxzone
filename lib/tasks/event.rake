namespace :event do
 
  task :send_approaching_notification => :environment do 
    events = Event.find(:all, :conditions => ["start_time <= ?", 2.days.from_now.beginning_of_day.to_s(:db)])
    events.each do |event|
      event.participants.each do |user|
        EventMailer.deliver_approaching_notification(event, user)
      end
    end
  end

	task :clean_expired_invitation_requests => :environment do
		events = Event.find(:all, :conditions => ["end_time <= ?", Time.now.to_s(:db)])
		events.each do |event|
			events.invitations.each do |invitation|
				invitation.destroy
			end
			events.requests.each do |request|
				request.destroy
			end
		end
	end

end
