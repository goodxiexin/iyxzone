#
# 如果活动的时间地点发生了变化，发通知
#
require 'app/mailer/event_mailer'

class EventObserver < ActiveRecord::Observer

  def before_create event
    if event.is_guild_event?
      g = event.guild
      event.game_id = g.game_id
      event.game_server_id = g.game_server_id
      event.game_area_id = g.game_area_id
    else
      c = event.poster_character
      event.game_id = c.game_id
      event.game_server_id = c.server_id
      event.game_area_id = c.area_id
    end
  end

  def after_create event
    # create album
    event.create_album

    # create participation
    event.participations.create(:participant_id => event.poster_id, :character_id => event.character_id, :status => Participation::Confirmed)
 
    # issue feeds
    return if event.poster.application_setting.emit_event_feed == 0
    recipients = [event.poster.profile, event.game]
    recipients.concat event.poster.guilds
    recipients.concat event.poster.friends.find_all{|f| f.application_setting.recv_event_feed == 1}
    event.deliver_feeds :recipients => recipients
  end

  def before_update event 
    if event.title_changed? or event.description_changed? # only title or url changed must update column 'verified'
      event.verified = 0
    end
  end
  
  def after_update event
    if event.time_changed?
      event.participants.each do |participant|
        participant.notifications.create(:category => Notification::EventChange, :data => "活动 #{event_link event} 时间改变了")
        EventMailer.deliver_time_change event, participant if participant.mail_setting.change_event == 1
      end
    end
  end

  def before_destroy event
    # modify request count
    event.poster.raw_decrement :event_requests_count, event.requests_count
    
    # modify invitations count
    event.invitations.each do |invitation|
      invitation.participant.raw_decrement :event_invitations_count
    end
    
    # send notifications
    (event.participants - [event.poster]).each do |p|
      p.notifications.create(:category => Notification::EventCancel, :data => "活动 #{event.title} 取消了")
      EventMailer.deliver_event_cancel event, p if p.mail_setting.cancel_event == 1
    end

    # destroy all participations
    Participation.delete_all(:event_id => event.id)
  end

end
