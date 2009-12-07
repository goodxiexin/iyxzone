class StatusFeedObserver < ActiveRecord::Observer

	observe :status

  def after_create(status)
		status.deliver_feeds :recipients => status.poster.friends
	end

end
