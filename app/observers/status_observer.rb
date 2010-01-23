class StatusObserver < ActiveRecord::Observer

  def after_create status
    status.poster.raw_increment :statuses_count
		status.deliver_feeds :recipients => status.poster.friends
	end

  def after_destroy status
    status.poster.raw_decrement :statuses_count
  end

end
