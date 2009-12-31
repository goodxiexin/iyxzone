# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.gem "adzap-ar_mailer", :lib => 'action_mailer/ar_mailer', :source => 'http://gems.github.com'

  config.gem "calendar_date_select"

	# reset sweeper path to app/sweepers
	config.load_paths += %W(#{RAILS_ROOT}/app/sweepers)

	# save cached objects to /public/cache
	config.action_controller.page_cache_directory = RAILS_ROOT + "/cache/pages"

	#config.cache_store = :mem_cache_store	

	# reset observer path to app/observers 
	config.load_paths += %W(#{RAILS_ROOT}/app/observers)

  config.active_record.observers = :user_observer, 
		:comment_observer, :tag_observer,
		:profile_feed_observer,
		:character_feed_observer,
		:blog_observer, :blog_feed_observer,
		:video_feed_observer,
		:status_feed_observer,
		:friendship_observer, :friendship_feed_observer,
		:event_observer, :event_feed_observer, :participation_observer, :participation_feed_observer, # event
		:poll_observer, :poll_feed_observer, :vote_counter_observer, :vote_feed_observer, :poll_invitation_observer, # poll
		:guild_observer, :guild_feed_observer, :membership_feed_observer, :membership_observer,
		:post_counter_observer,
		:cover_observer, :avatar_feed_observer, :personal_album_observer,
    :sharing_feed_observer

	# reset mailer path to app/mailers
	config.load_paths += %W(#{RAILS_ROOT}/app/mailers)

  config.time_zone = 'UTC'

end
