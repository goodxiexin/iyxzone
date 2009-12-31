#
# 如果活动的时间地点发生了变化，发通知
#
require 'app/mailer/event_mailer'

class EventObserver < ActiveRecord::Observer

  def time_changed?(event)
    event.start_time_changed? or event.end_time_changed?
  end

  def place_changed?(event)
    event.game_id_changed? or event.game_server_id_changed? or event.game_area_id_changed?
  end

  def after_create(event)
    event.create_album(:title => "#{event.title}活动的相册", :privilege => 1, :game_id => event.game_id, :poster_id => event.poster_id)
    event.participations.create(:participant_id => event.poster_id, :status => Participation::Confirmed)
  end

  def after_update(event)
    poster = event.poster
    if time_changed?(event)
      event.participants.each do |p|
				p.notifications.create(:data => "#{profile_link poster}改变了活动#{event_link event}的时间")
				EventMailer.deliver_time_change(event, p) if p != poster and p.mail_setting.change_time_of_event
      end
    end
    if place_changed?(event)
      event.participants.each do |p|
				p.notifications.create(:data => "#{profile_link poster}改变了活动#{event_link event}的地点")
        EventMailer.deliver_time_change(event, p) if p != poster and p.mail_setting.change_place_of_event
			end
    end
  end

  def after_destroy(event)
    event.participants.each do |p|
			p.notifications.create(:data => "#{profile_link poster}取消了活动#{event_link event}")
      EventMailer.deliver_event_cancel(event, p) if p != poster and p.mail_setting.cancel_event
    end
  end

end
