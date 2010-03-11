namespace :feeds do

  desc "删除过期的新鲜事（1个月前）"
	task :delete_expired_deliveries => :environment do
		feed_deliveries = FeedDelivery.find(:all, :conditions => ["created_at <= ?", 1.month.ago.to_s(:db)])
		FeedDelivery.destroy(feed_deliveries.map(&:id))
	end

end 
