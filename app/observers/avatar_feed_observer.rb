class AvatarFeedObserver < ActiveRecord::Observer

	observe :avatar

	def after_create avatar
		return if avatar.album.blank? # thumbnail.. 
    return if !avatar.album.poster.application_setting.emit_photo_feed 
		recipients = avatar.album.poster.friends.find_all {|f| f.application_setting.recv_photo_feed }
		avatar.deliver_feeds :recipients => recipients
	end

end
