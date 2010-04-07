class SharingObserver < ActiveRecord::Observer

  def before_created sharing
    # duplicate shareable type for performance reason
    sharing.shareable_type = sharing.share.shareable_type  
  end

  def after_create sharing
    share = sharing.share
    poster = sharing.poster

    # increment counter
    share.raw_increment :sharings_count
    poster.raw_increment :sharings_count

    # issue feeds if necessary
    return if poster.application_setting.emit_sharing_feed == 0
    recipients = [poster.profile].concat poster.guilds
    recipients.concat poster.friends.find_all {|f| f.application_setting.recv_sharing_feed == 1}
    sharing.deliver_feeds :recipients => recipients, :data => {:type => share.shareable_type}
  end

  # update verified column
  def before_update sharing 
    if sharing.title_changed?
      sharing.verified = 0
    end
  end
  
  def after_destroy sharing
    sharing.share.raw_decrement :sharings_count
		sharing.poster.raw_decrement :sharings_count
  end

end
