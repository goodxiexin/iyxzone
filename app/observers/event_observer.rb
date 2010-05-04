#
# 如果活动的时间地点发生了变化，发通知
#
require 'app/mailer/event_mailer'

class EventObserver < ActiveRecord::Observer

  def before_create event
    # verify
    if event.sensitive?
      event.verified = 0
    else
      event.verified = 1
    end

    # inherit some attributes from character or guild
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
    if event.poster.application_setting.emit_event_feed == 1
      event.deliver_feeds
    end
  end

  def before_update event
    # verify 
    if event.sensitive_columns_changed? and event.sensitive?
      event.verified = 0
    end
  end
  
  def after_update event
    # verify
    if event.verified_changed?
      # 因为event用的不是计数器，所以这里没啥可干的
      return
    end

    # if time changes, deliver some notifications
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
    if event.verified != 2
      (event.participants - [event.poster]).each do |p|
        p.notifications.create(:category => Notification::EventCancel, :data => "活动 #{event.title} 取消了")
        EventMailer.deliver_event_cancel event, p if p.mail_setting.cancel_event == 1
      end
    end

    # destroy all participations
    Participation.delete_all(:event_id => event.id)
  end

end
