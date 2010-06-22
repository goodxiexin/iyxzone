require 'app/mailer/event_mailer'

class EventObserver < ActiveRecord::Observer

  def before_create event
    # verify
    event.auto_verify

    # inherit some attributes from character or guild
    character = event.poster_character
    event.poster_id = character.user_id
    event.game_id = character.game_id
    event.game_server_id = character.server_id
    event.game_area_id = character.area_id
  end

  def after_create event
    # create album
    event.create_album

    # create participation
    event.participations.create(:participant_id => event.poster_id, :character_id => event.character_id, :status => Participation::Confirmed)
 
    # issue feeds
    if event.poster.application_setting.emit_event_feed?
      event.deliver_feeds
    end
  end

  def before_update event
    event.auto_verify
  end
  
  def after_update event
    # verify
    if event.recently_recovered?
      event.album.verify # 会在album的observer把所有图片都verify
    elsif event.recently_rejected?
      event.destroy_feeds # participation的feed就不删了，反正他们本来就没评论
      event.album.unverify # 会在album的observer里把所有图片都unverify
    end

    # if time changes, deliver some notifications
    if event.start_time_changed? || event.end_time_changed?
      event.participants.each do |participant|
        participant.notifications.create(:category => Notification::EventChange, :data => "活动 #{event_link event} 时间改变了")
        EventMailer.deliver_time_change event, participant if participant.mail_setting.change_event?
      end
    end
  end

  def before_destroy event
    # modify request count
    event.poster.raw_decrement :event_requests_count, event.requests_count
    
    # modify invitations count
    # TODO: 用一句sql解决，但如果是这样，必须要知道event有几个character
    event.invitations.each do |invitation| 
      invitation.participant.raw_decrement :event_invitations_count
    end

    # send notifications
    if !event.rejected?
      (event.participants - [event.poster]).each do |p|
        p.notifications.create(:category => Notification::EventCancel, :data => "活动 #{event.title} 取消了")
        EventMailer.deliver_event_cancel event, p if p.mail_setting.cancel_event?
      end
    end

    # destroy all participations
    event.participations.each { |p| p.destroy_feeds }
    Participation.delete_all(:event_id => event.id)
  end

end
