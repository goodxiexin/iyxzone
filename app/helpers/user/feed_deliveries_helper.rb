module User::FeedDeliveriesHelper

  def feed_delivery_deleteable_by_current_user delivery
    recipient = delivery.recipient
    type = recipient.class.name.underscore
    if type == 'user'
      true
    elsif type == 'guild'
      current_user == recipient.president
    elsif type == 'profile'
      current_user == recipient.user
    end
  end

end
