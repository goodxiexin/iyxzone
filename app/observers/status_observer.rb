class StatusObserver < ActiveRecord::Observer

  def before_create status
    if status.sensitive?
      status.verified = 0
    else
      status.verified = 1
    end
  end

  def after_create status
    # change counter
    status.poster.raw_increment :statuses_count

    # deliver feeds
		status.deliver_feeds
	end

  def before_update status
    if status.sensitive_columns_changed? and status.sensitive?
      status.verified = 0
    end  
  end

  def after_update status
    if status.verified_was == 2 and status.verified == 1
      status.poster.raw_increment :statuses_count
    end
    if (status.verified_was == 0 or status.verified_was == 1) and status.verified == 2
      status.poster.raw_decrement :statuses_count
    end
  end

  def after_destroy status
    if status.verified != 2
      status.poster.raw_decrement :statuses_count
    end
  end

end
