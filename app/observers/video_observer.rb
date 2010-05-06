class VideoObserver < ActiveRecord::Observer

  def before_create video
    if video.sensitive?
      video.verified = 0
    else
      video.verified = 1
    end
  end

	def after_create video
    # first increment user's count
    video.poster.raw_increment "videos_count#{video.privilege}"
    
    # emit feed if necessary
    if (video.poster.application_setting.emit_video_feed == 1) and !video.is_owner_privilege?
		  video.deliver_feeds
    end
	end

  def before_update video
    if video.sensitive_columns_changed? and video.sensitive?
      video.verified = 0
    end 
  end

  def after_update video
    # change counter if verified changes
    if video.verified_changed?
      if (video.verified_was == 0 or video.verified_was == 1) and video.verified == 2
        video.poster.raw_decrement "videos_count#{video.privilege}"
        video.destroy_feeds
      elsif video.verified_was == 2 and video.verified == 1
        video.poster.raw_increment "videos_count#{video.privilege}"
        video.deliver_feeds
      end
      return
    end

    # change counter if necessary
    if video.privilege_changed?
      video.poster.raw_increment "videos_count#{video.privilege}"
      video.poster.raw_decrement "videos_count#{video.privilege_was}"
    end

    # issue feeds if necessary
    if video.privilege != 4 and video.privilege_was == 4
      if video.poster.application_setting.emit_video_feed == 1
        video.deliver_feeds
      end
    end

    # destroy feeds if necessary
    if video.privilege == 4 and video.privilege_was != 4
      video.destroy_feeds
    end
  end

  def after_destroy video
    if video.verified != 2
      video.poster.raw_decrement "videos_count#{video.privilege}"
    end
  end

end
