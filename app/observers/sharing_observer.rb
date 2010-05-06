class SharingObserver < ActiveRecord::Observer

  def before_create sharing
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
    if poster.application_setting.emit_sharing_feed == 1
      sharing.deliver_feeds :data => {:type => share.shareable_type}
    end
  end

  # update verified column
  def before_update sharing 
    if sharing.title_changed?
      sharing.verified = 0
    end
  end

  def after_destroy sharing
    sharing.poster.raw_decrement :sharings_count
    sharing.share.raw_decrement :sharings_count
  end
  
end
