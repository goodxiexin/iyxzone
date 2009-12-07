class ApplicationSetting < ActiveRecord::Base

	acts_as_setting :bits => 1, 
									:defaults => %w[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1],	
									:keys => %w[emit_blog_feed recv_blog_feed emit_video_feed recv_video_feed emit_photo_feed recv_photo_feed emit_poll_feed recv_poll_feed emit_event_feed recv_event_feed emit_guild_feed recv_guild_feed]

end
