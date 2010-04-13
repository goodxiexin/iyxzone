class FeedDeliveryObserver < ActiveRecord::Observer

  def before_create delivery
    delivery.expired_at = 1.week.from_now 
  end

end
