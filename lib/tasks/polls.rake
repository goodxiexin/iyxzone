namespace :polls do

  desc "截至日期到了，发送投票结果"
  task :send_result => :environment do
    polls = Poll.find(:all, :conditions => ["no_deadline = 0 AND deadline <= ?", Time.now.to_s(:db)])
    polls.each do |poll|
      poll.subscribers.each do |user|
        poll.notifications.create(:user_id => user.id) 
        PollMailer.deliver_result poll, user if user.mail_setting.poll_expire == 1
      end
    end
  end

  desc "截至日期到了，不做任何事情，投票邀请仍然可接受"
	task :clean_expired_invitations => :environment do 
	  # nothing to do right now
  end

end
