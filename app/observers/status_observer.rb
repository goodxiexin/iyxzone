class StatusObserver < ActiveRecord::Observer

  def before_create status
    status.verified = status.sensitive? ? 0 : 1
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
    if status.recently_verified_from_unverified
      status.poster.raw_increment :statuses_count
      status.deliver_feeds  
    elsif status.recently_unverified
      status.poster.raw_decrement :statuses_count
      status.destroy_feeds
    end
  end

  def after_destroy status
    if status.verified != 2
      status.poster.raw_decrement :statuses_count
    end
  end

end
