class SharingFeedObserver < ActiveRecord::Observer

  observe :sharing

  def after_create sharing
    recipients = [].concat sharing.poster.guilds
    recipients.concat sharing.poster.friends.find_all {|f| f.application_setting.recv_sharing_feed}
    sharing.deliver_feeds :recipients => recipients
  end

end
