module Event::EventsHelper

  def msg status
    case
      when status == 3 then info = '肯定去'
      when status == 4 then info = '可能去'
      when status == 5 then info = '去他娘的'
    end
    info
  end

  def show_event_status participation, event
    if participation.blank?
      return "<span id='event_status_#{event.id}'>没有参加</span><span id='reply_event_#{event.id}'>(#{link_to '请求加入', new_event_request_url(event), :rel => 'facebox'})</span>"
    elsif participation.status == 0
      "<span id='event_status_#{event.id}'>受邀请</span><span id='reply_event_#{event.id}'>(#{link_to '回复', edit_event_invitation_url(event, participation, :show => 0), :rel => 'facebox'})</span>"
    elsif participation.status == 1 or participation.status == 2
      "<span id='event_status_#{event.id}'>等待回复</span><span id='reply_#{event.id}'></span>"
    else
      "<span id='event_status_#{event.id}'>#{msg participation.status}</span><span id='reply_event_#{event.id}'>(#{link_to '更改', edit_event_participation_url(event, participation, :show => 0), :rel => 'facebox'})</span>"
    end
  end

end
