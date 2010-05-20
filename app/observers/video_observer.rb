class VideoObserver < ActiveRecord::Observer

  def before_create video
    video.auto_verify
  end

	def after_create video
    # first increment user's count
    video.poster.raw_increment "videos_count#{video.privilege}"
    
    # emit feed if necessary
    if video.poster.application_setting.emit_video_feed? and !video.is_owner_privilege?
		  video.deliver_feeds
    end
	end

  def before_update video
    video.auto_verify
  end

  def after_update video
    # change counter if verified changes
    if video.recently_rejected
      video.poster.raw_decrement "videos_count#{video.privilege}"
      video.destroy_feeds
    elsif video.recently_recovered
      video.poster.raw_increment "videos_count#{video.privilege}"
      video.deliver_feeds
    end

    # change counter if necessary
    if video.privilege_changed?
      video.poster.raw_increment "videos_count#{video.privilege}"
      video.poster.raw_decrement "videos_count#{video.privilege_was}"
    end

    # issue feeds if necessary
    if !video.is_owner_privilege? and video.was_owner_privilege?
      if video.poster.application_setting.emit_video_feed?
        video.deliver_feeds
      end
    end

    # destroy feeds if necessary
    if video.is_owner_privilege? and !video.was_owner_privilege?
      video.destroy_feeds
    end
  end

  def after_destroy video
    if !video.rejected?
      video.poster.raw_decrement "videos_count#{video.privilege}"
    end
  end

end
