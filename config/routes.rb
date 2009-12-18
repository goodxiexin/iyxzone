ActionController::Routing::Routes.draw do |map|
  map.resources :users, :collection => {:search => :get}

  map.resources :sessions

  map.root :controller => 'sessions', :action => 'new' 

  map.signup '/signup', :controller => 'users', :action => 'new'

  map.login '/login', :controller => 'sessions', :action => 'new'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'

  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'

  map.reset_password '/reset_password/:password_reset_code', :controller => 'passwords', :action => 'edit'

	map.upload_image '/upload_images', :controller => 'blog/images', :action => 'upload'

	map.auto_complete_for_mail_recipients '/auto_complete_for_mail_recipients', :controller => 'mails', :action => 'auto_complete_for_mail_recipients'
 
  map.home '/home', :controller => 'home', :action => 'show'

  map.resources :profiles, :controller => 'profile/profiles', :member => {:more_feeds => :get} do |profiles|
	
		profiles.resources :comments, :controller => 'profile/comments'

		profiles.resources :tags, :controller => 'profile/tags'

	end

  map.cities '/cities', :controller => 'chinese_region', :action => 'cities'

  map.districts '/districts', :controller => 'chinese_region', :action => 'districts'

  #
  # search
  #
  map.search_users '/search/users', :controller => 'search', :action => 'user'

  map.search_characters '/search/characters', :controller => 'search', :action => 'character'

  map.search_comrades 'search/comrades', :controller => 'search', :action => 'comrade'

	#
	# setting
	#
	map.resource :privacy_setting, :controller => 'setting/privacy_setting'

  map.resource :mail_setting, :controller => 'setting/mail_setting'

  map.resource :application_setting, :controller => 'setting/application_setting'

  map.resource :password_setting, :controller => 'setting/password_setting'


  #
  # visitor records
  #
  map.resources :visitor_records

  #
  # games
  #
  map.resources :games, :controller => 'game/games', :member => {:game_details => :get, :area_details => :get},
								:collection => {:hot => :get, :beta => :get, :friend => :get, :sex => :get} do |games|

		games.resources :blogs, :controller => 'game/blogs'

		games.resources :albums, :controller => 'game/albums'

		games.resources :events, :controller => 'game/events'

		games.resources :guilds, :controller => 'game/guilds'

		games.resources :comments, :controller => 'game/comments'

		games.resources :tags, :controller => 'game/tags'

	end

	#
	# characters
	#
	map.resources :characters

	#
	# game attentions
	#
	map.resources :game_attentions

  #
  # game suggestions
  #
  map.resources :game_suggestions, :collection => {:game_tags => :get} 

  #
  # statuses
  #
  map.resources :statuses, :controller => 'status/statuses' do |statuses|
  
    statuses.resources :comments, :controller => 'status/comments'

  end

	map.resources :status_feeds, :controller => 'status/feeds'
 
  #
  # blogs
  #
  map.resources :blogs, :controller => 'blog/blogs', :collection => {:hot => :get, :recent => :get, :relative => :get} do |blogs|
    
    blogs.resources :comments, :controller => 'blog/comments'

    blogs.resources :digs, :controller => 'blog/digs'

    blogs.resources :tags, :controller => 'blog/tags'
  
  end

  map.resources :blog_feeds, :controller => 'blog/feeds'

  map.resources :drafts, :controller => 'blog/drafts'

  #
  # videos
  #
  map.resources :videos, :controller => 'video/videos', :collection => {:hot => :get, :recent => :get, :relative => :get} do |blogs|

    blogs.resources :comments, :controller => 'video/comments'

    blogs.resources :digs, :controller => 'video/digs'

    blogs.resources :tags, :controller => 'video/tags'

  end

	map.resources :video_feeds, :controller => 'video/feeds'

  #
  # avatar album
  #
  map.resources :avatar_albums, :controller => 'avatar_album/albums' do |albums|
 
    albums.resources :comments, :controller => 'avatar_album/album_comments'
 
  end

  map.resources :avatars, :controller => 'avatar_album/photos', :member => {:set => :post} do |avatars|

    avatars.resources :comments, :controller => 'avatar_album/photo_comments'

    avatars.resources :tags, :controller => 'avatar_album/tags'

    avatars.resources :digs, :controller => 'avatar_album/digs'

  end

  #
  # personal album
  #
  map.resources :personal_albums, :controller => 'personal_album/albums', :member => {:confirm_destroy => :get}, 
                :collection => {:hot => :get, :recent => :get, :select => :get} do |albums|
  
    albums.resources :comments, :controller => 'personal_album/album_comments'

  end

  map.resources :personal_photos, :controller => 'personal_album/photos', :member => {:cover => :post},
                :collection => {:hot => :get, :update_multiple => :put, :edit_multiple => :get, :create_multiple => :post, :relative => :get} do |photos|

    photos.resources :comments, :controller => 'personal_album/photo_comments'

    photos.resources :tags, :controller => 'personal_album/tags'

    photos.resources :digs, :controller => 'personal_album/digs'

  end

	map.resources :personal_album_feeds, :controller => 'personal_album/feeds'

  #
  # event
  #
  map.resources :events, :controller => 'event/events', 
                :collection => {:hot => :get, :recent => :get, :upcoming => :get, :participated => :get, :search => :get} do |events|
    
    events.resources :participations, :controller => 'event/participations'

    events.resources :comments, :controller => 'event/comments'

    events.resources :invitations, :controller => 'event/invitations', :member => {:accept => :put, :decline => :put},
                     :collection => {:create_multiple => :post, :search => :get}

    events.resources :requests, :controller => 'event/requests', :member => {:accept => :put, :decline => :delete}

  end
               
  map.resources :event_albums, :controller => 'event_album/albums' do |albums|

    albums.resources :comments, :controller => 'event_album/album_comments'
 
  end

  map.resources :event_photos, :controller => 'event_album/photos', 
                :collection => {:create_multiple => :post, :update_multiple => :put, :edit_multiple => :get} do |photos|

    photos.resources :comments, :controller => 'event_album/photo_comments'

    photos.resources :digs, :controller => 'event_album/digs'

    photos.resources :tags, :controller => 'event_album/tags'

  end

	map.resources :event_feeds, :controller => 'event/feeds'

  #
  # polls
  #
  map.resources :polls, :controller => 'poll/polls', :collection => {:hot => :get, :recent => :get, :participated => :get} do |polls|

    polls.resources :invitations, :controller => 'poll/invitations', :collection => {:search => :get, :create_multiple => :post}

    polls.resources :answers, :controller => 'poll/answers'

    polls.resources :votes, :controller => 'poll/votes'

    polls.resources :comments, :controller => 'poll/comments'

  end

	map.resources :poll_feeds, :controller => 'poll/feeds'

  #
  # guild
  #
  map.resources :guilds, :controller => 'guild/guilds', :member => {:more_feeds => :get},
								:collection => {:hot => :get, :recent => :get, :participated => :get, :search => :get} do |guilds|

    guilds.resources :memberships, :controller => 'guild/memberships', :collection => {:search => :get}

    guilds.resources :comments, :controller => 'guild/comments'

    guilds.resources :friends, :controller => 'guild/friends'

    guilds.resources :requests, :controller => 'guild/requests', :member => {:accept => :put, :decline => :delete}

    guilds.resources :invitations, :controller => 'guild/invitations', :collection => {:create_multiple => :post, :search => :get},
                     :member => {:accept => :put, :decline => :delete}

    guilds.resources :events, :controller => 'guild/events', :collection => {:search => :get}
  
	end

  map.resources :guild_albums, :controller => 'guild_album/albums' do |albums|

		albums.resources :comments, :controller => 'guild_album/album_comments'

	end

  map.resources :guild_photos, :controller => 'guild_album/photos',
                :collection => {:create_multiple => :post, :update_multiple => :put, :edit_multiple => :get},
                :member => {:cover => :post} do |photos|

    photos.resources :comments, :controller => 'guild_album/photo_comments'

    photos.resources :tags, :controller => 'guild_album/tags'

    photos.resources :digs, :controller => 'guild_album/digs'
  
	end
               
  map.resources :guild_feeds, :controller => 'guild/feeds' 

	#
	# forum
	#
	map.resources :forums, :controller => 'forum/forums' do |forums|
	
	  forums.resources :topics, :controller => 'forum/topics', :member => {:toggle => :put} do |posts|
  
	    posts.resources :posts, :controller => 'forum/posts'
	
	  end
  
	end

  #
  # friends
  #
  map.resources :friends, :controller => 'friend/friends', :collection => {:search => :get, :other => :get, :common => :get} 

  map.resources :friend_requests, :controller => 'friend/requests', :member => {:accept => :put, :decline => :delete}

	map.resources :friend_impressions, :controller => 'friend/impressions'

	map.resources :friend_suggestions, :controller => 'friend/suggestions', :collection => {:all_index => :get}

	#
	# requests and invitations
	#
	map.resources :requests

	map.resources :invitations

	map.resources :notifications, :collection => {:first_five => :get, :destroy_all => :delete}

	map.resources :notices, :collection => {:first_ten => :get}, :member => {:read => :put}

	map.resources :mails, :member => {:reply => :post}, :collection => {:auto_complete_for_mail_recipients => :get, :read_multiple => :put, :unread_multiple => :put, :destroy_multiple => :delete}

	map.resources :pokes, :collection => {:destroy_all => :delete}

	#
	# feeds
	#
	map.resources :feed_deliveries
  
	map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
