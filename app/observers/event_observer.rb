#
# 如果活动的时间地点发生了变化，发通知
#
require 'app/mailer/event_mailer'

class EventObserver < ActiveRecord::Observer

  def time_changed? event
    event.start_time_changed? or event.end_time_changed?
  end

  def place_changed? event
    event.game_id_changed? or event.game_server_id_changed? or event.game_area_id_changed?
  end

  def after_create event
    # create album and participation
    event.create_album
    event.participations.create(:participant_id => event.poster_id, :status => Participation::Confirmed)
  
    # increment user's counter
    event.poster.raw_increment :events_count
  
    # issue feeds
    return unless event.poster.application_setting.emit_event_feed
    recipients = [event.poster.profile]
    recipients.concat event.poster.guilds
    recipients.concat event.poster.friends.find_all{|f| f.application_setting.recv_event_feed}
    event.deliver_feeds :recipients => recipients
  end

  def after_update event
    # notify participants if time or place changes
    poster = event.poster
    if time_changed? event and place_changed? event
      event.participants.each do |p|
				p.notifications.create(:data => "#{profile_link poster}改变了活动#{event_link event}的时间和地点")
				EventMailer.deliver_time_and_place_change(event, p) if p != poster and p.mail_setting.change_event
      end
    elsif time_changed? event
      event.participants.each do |p|
        p.notifications.create(:data => "#{profile_link poster}改变了活动#{event_link event}的时间")
        EventMailer.deliver_time_change(event, p) if p != poster and p.mail_setting.change_event
      end
    elsif place_changed? event
      event.participants.each do |p|
				p.notifications.create(:data => "#{profile_link poster}改变了活动#{event_link event}的地点")
        EventMailer.deliver_place_change(event, p) if p != poster and p.mail_setting.change_event
			end
    end
  end

  def after_destroy event
    event.poster.raw_decrement :events_count
  end

end
