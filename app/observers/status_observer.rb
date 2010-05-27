class StatusObserver < ActiveRecord::Observer

  def before_create status
    status.auto_verify
  end

  def after_create status
    # change counter
    status.poster.raw_increment :statuses_count

    # deliver feeds
		status.deliver_feeds
	end

  def before_update status
    status.auto_verify
  end

  def after_update status
    if status.recently_recovered?
      status.poster.raw_increment :statuses_count
      status.deliver_feeds  
    elsif status.recently_rejected?
      status.poster.raw_decrement :statuses_count
      status.destroy_feeds
    end
  end

  def after_destroy status
    if !status.rejected?
      status.poster.raw_decrement :statuses_count
    end
  end

end
