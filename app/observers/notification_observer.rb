class NotificationObserver < ActiveRecord::Observer

  def after_create notification
    user = notification.user
    
    user.raw_increment :notifications_count
    user.raw_increment :unread_notifications_count unless notification.read

    # send data to push server
    # 实际上这段代码我感觉很不好，不应该放这，毕竟这是和view有关的
    Juggernaut.send_to_client "Iyxzone.startBlinkTitle('新通知');$('navnotice').update('通知<em class=\"notice-bubble\"><strong>#{user.unread_notifications_count}</strong></em>'); $('notifications_dropdown_list').update(''); $('notifications_dropdown').hide(); Sound.play('/music/test.wav');", user.id
  end
 
  def after_update notification
    if !notification.read_was and notification.read
      notification.user.raw_decrement :unread_notifications_count
    end 
  end
 
  def after_destroy notification
    notification.user.raw_decrement :notifications_count
    notification.user.raw_decrement :unread_notifications_count unless notification.read
  end

end
