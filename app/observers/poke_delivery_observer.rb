require 'app/mailer/poke_mailer'

class PokeDeliveryObserver < ActiveRecord::Observer

  def after_create delivery
    delivery.recipient.raw_increment :poke_deliveries_count

    # deliver email if necessary
    PokeMailer.deliver_poke delivery if delivery.recipient.mail_setting.poke_me == 1
  end

  def after_destroy delivery
    delivery.recipient.raw_decrement :poke_deliveries_count
  end

end
