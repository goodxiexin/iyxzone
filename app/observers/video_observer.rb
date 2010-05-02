class VideoObserver < ActiveRecord::Observer

	def after_create video
    # first increment user's count
    video.poster.raw_increment "videos_count#{video.privilege}"
    
    # emit feed if necessary
		return if video.poster.application_setting.emit_video_feed == 0
		return if video.is_owner_privilege?
		recipients = [video.poster.profile, video.game]
		recipients.concat video.poster.guilds
		recipients.concat video.poster.friends.find_all{|f| f.application_setting.recv_video_feed == 1}
		video.deliver_feeds :recipients => recipients
	end

  def after_update video
    # change counter if necessary
    if video.privilege_changed?
      video.poster.raw_increment "videos_count#{video.privilege}"
      video.poster.raw_decrement "videos_count#{video.privilege_was}"
    end

    # issue feeds if necessary
    if video.privilege != 4 and video.privilege_was == 4
      if video.poster.application_setting.emit_video_feed == 1
        recipients = [video.poster.profile]
        recipients.concat video.poster.guilds
        recipients.concat video.poster.friends.find_all{|f| f.application_setting.recv_video_feed == 1}
        video.deliver_feeds :recipients => recipients
      end
=begin
      video.tags.each do |tag|
        tag.notices.create(:user_id => tag.tagged_user_id)
        TagMailer.deliver_video_tag tag if tag.tagged_user.mail_setting.tag_me_in_video == 1
      end
=end
    end

    # destroy feeds if necessary
    if video.privilege == 4 and video.privilege_was != 4
      video.destroy_feeds
    end
  end

  def after_destroy video
    video.poster.raw_decrement "videos_count#{video.privilege}"
  end

end
