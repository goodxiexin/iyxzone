class PokeDeliveryObserver < ActiveRecord::Observer

  def after_create delivery
    delivery.recipient.raw_increment :poke_deliveries_count
  end

  def after_destroy delivery
    delivery.recipient.raw_decrement :poke_deliveries_count
  end

end
