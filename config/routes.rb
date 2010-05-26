ActionController::Routing::Routes.draw do |map|

  map.resources :users, :collection => {:search => :get}

	map.resources :guest_books, :controller => 'guestbooks'

  map.resources :game_details, :controller => 'games'

  map.resources :area_details, :controller => 'game_areas'

  map.resources :regions, :controller => 'regions'

  map.resources :cities, :controller => 'cities'

  map.resources :districts, :controller => 'districts'

  map.resources :sessions

  map.resources :help, :collection => {:about_us => :get, :app_info => :get, :contact_info => :get, :privacy_info => :get}

  map.root :controller => 'user/home', :action => 'show'

  map.signup '/signup', :controller => 'users', :action => 'new'

  map.login '/login', :controller => 'sessions', :action => 'new'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'

  map.activation_mail_sent '/activation_mail_sent', :controller => 'users', :action => 'activation_mail_sent'

  map.resend_activation_mail '/resend_activation_mail', :controller => 'users', :action => 'resend_activation_mail'

  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'

  map.reset_password '/reset_password/:password_reset_code', :controller => 'passwords', :action => 'edit'

  map.invite '/invite', :controller => 'register', :action => 'invite'

  map.namespace :admin do |admin|
		
		admin.resources	:tasks

    admin.resources :news do |news|

      news.resources :pictures, :controller => 'news_pictures', :collection => {:update_multiple => :put, :edit_multiple => :get}

    end
  
  	admin.resources :guestbooks, :only => [ :index, :show , :edit, :update, :destroy]

    admin.resources :users, :member => {:enable => :put, :disable => :put, :activate => :put}, :collection => {:search => :get}

    admin.resources :blogs, :member => {:verify => :put, :unverify => :put }
    
    admin.resources :videos, :member => {:verify => :put, :unverify => :put }
    
    admin.resources :statuses, :member => {:verify => :put, :unverify => :put }
    
    admin.resources :comments, :member => {:verify => :put, :unverify => :put }
    
    admin.resources :events, :member => {:verify => :put, :unverify => :put }
    
    admin.resources :guilds, :member => {:verify => :put, :unverify => :put }
    
    admin.resources :polls, :member => {:verify => :put, :unverify => :put }
    
    admin.resources :albums, :member => {:verify => :put, :unverify => :put }
 
    admin.resources :photos, :member => {:verify => :put, :unverify => :put }

    admin.resources :topics, :member => {:verify => :put, :unverify => :put }

    admin.resources :posts, :member => {:verify => :put, :unverify => :put}

    admin.resources :applications

    admin.resources :signup_invitations
  
  end

  map.namespace :user, :name_prefix => '', :path_prefix => ''  do |users|

		users.resources :rss_feeds
		
		users.resources :tasks
		
    users.resources :applications

    users.resources :links

    users.resources :sharings

    users.resources :shares, :collection => {:hot => :get, :recent => :get, :friends => :get}

    users.resources :notices, :collection => {:first_ten => :get}, :member => {:read => :put}

    users.resources :pokes, :collection => {:destroy_all => :delete}

    users.resources :characters, :collection => {:friend_players => :get}

    users.resources :visitor_records

    users.resources :messages, :collection => {:read => :put}

    users.resources :requests, :collection => {:destroy_all => :delete}

    users.resources :invitations, :collection => {:destroy_all => :delete}

    users.resources :notifications, :collection => {:destroy_all => :delete, :first_five => :get}

    users.resources :profiles, :member => {:more_feeds => :get} do |profiles|

      profiles.resources :tags, :controller => 'profiles/tags'

      profiles.resources :viewings, :controller => 'profiles/viewings'

    end

    users.resources :skins, :controller => 'profiles/skins'

    users.resources :mails, :collection => {:read_multiple => :put, :unread_multiple => :put, :destroy_multiple => :delete}, :member => {:reply => :post}

    users.resources :friend_suggestions

    users.resources :friend_impressions, :controller => 'friends/impressions'

    users.resources :friends, :collection => {:search => :get, :other => :get, :common => :get} 

    users.resources :friend_requests, :controller => 'friends/requests', :member => {:accept => :put, :decline => :delete}, :collection => {:create_multiple => :post}

    users.resources :feed_deliveries

    users.resource :home, :controller => 'home', :member => {:more_feeds => :get, :feeds => :get}

    users.resource :privacy_setting, :controller => 'privacy_setting'

    users.resource :password_setting, :controller => 'password_setting'

    users.resource :application_setting, :controller => 'application_setting'

    users.resource :mail_setting, :controller => 'mail_setting'

    users.resources :blogs, :collection => [:hot, :recent, :relative, :friends]

    users.resources :blog_images, :controller => 'blogs/images'

    users.resources :drafts

    users.resources :videos, :collection => [:hot, :recent, :relative, :friends]

    users.resources :statuses, :collection => [:friends]

    users.friend_table_for_photo_tags '/friend_table_for_photo_tags', :controller => 'photo_tags', :action => 'friends'

    users.auto_complete_for_photo_tags '/auto_complete_for_photo_tags', :controller => 'photo_tags', :action => 'auto_complete_for_friends'

    users.resources :photo_tags

    users.resources :comments

    users.resources :wall_messages

    users.resources :digs

    users.friend_table_for_friend_tags '/friend_table_for_friend_tags', :controller => 'friend_tags', :action => 'friend_table'

    users.auto_complete_for_friend_tags '/auto_complete_for_friend_tags', :controller => 'friend_tags', :action => 'auto_complete_for_friend_tags'

    users.resources :friend_tags

    users.resources :personal_albums, :controller => 'albums', 
                    :collection => {:select => :get, :recent => :get, :friends => :get}, 
                    :member => {:confirm_destroy => :get}

    users.resources :personal_photos, :controller => 'photos',
                    :collection => {:hot => :get, :relative => :get, :edit_multiple => :get, :update_multiple => :put, :record_upload => :post}

    users.resources :avatar_albums, :controller => 'avatars/albums'

    users.resources :avatars, :controller => 'avatars/photos'

    users.resources :event_albums, :controller => 'events/albums'

    users.resources :event_photos, :controller => 'events/photos', :collection => {:edit_multiple => :get, :update_multiple => :put, :record_upload => :post}

    users.resources :events, :collection => [:hot, :recent, :participated, :upcoming, :friends] do |events|

      events.resources :participations, :controller => 'events/participations', :collection => {:search => :get}

      events.resources :invitations, :controller => 'events/invitations', :collection => {:search => :get}, :member => {:accept => :put, :decline => :delete}
  
      events.resources :requests, :controller => 'events/requests', :member => {:accept => :put, :decline => :delete}

      events.resource :summary, :controller => 'events/summary', :member => {:next => :post, :prev => :post, :save => :post}

    end

    users.resources :guild_albums, :controller => 'guilds/albums'

    users.resources :guild_photos, :controller => 'guilds/photos', :collection => {:edit_multiple => :get, :update_multiple => :put, :record_upload => :post}

    users.resources :guilds, :member => {:more_feeds => :get, :edit_rules => :get},
                    :collection => {:hot => :get, :recent => :get , :participated => :get, :friends => :get} do |guilds|

      guilds.resources :friends

      guilds.resources :memberships, :controller => 'guilds/memberships', :collection => {:search => :get}

      guilds.resources :invitations, :controller => 'guilds/invitations', :collection => {:search => :get}, :member => {:accept => :put, :decline => :delete}

      guilds.resources :requests, :controller => 'guilds/requests', :member => {:accept => :put, :decline => :delete}

      guilds.resources :events, :controller => 'guilds/events', :collection => {:search => :get}

      guilds.resources :bosses, :controller => 'guilds/bosses', :collection => {:create_or_update => :post}
    
      guilds.resources :rules, :controller => 'guilds/rules', :collection => {:create_or_update => :post}

      guilds.resources :gears, :controller => 'guilds/gears', :collection => {:create_or_update => :post}

    end

    users.resources :polls, :collection => [:hot, :recent, :participated, :friends] do |polls|

      polls.resources :answers, :controller => 'polls/answers'

      polls.resources :invitations, :controller => 'polls/invitations', :collection => {:search => :get, :create_multiple => :post}

      polls.resources :votes, :controller => 'polls/votes'

    end

    users.resources :games, :collection => {:sexy => :get, :hot => :get, :interested => :get, :beta => :get, :friends => :get}, :member => {:more_feeds => :get} do |games|

      games.resources :blogs, :controller => 'games/blogs'
      
			games.resources :comrades, :controller => 'games/comrades', :collection => {:search => :any, :character_search => :any}

			games.resources :players, :controller => 'games/players', :collection => {:search => :any, :character_search => :any}

      games.resources :guilds, :controller => 'games/guilds'

      games.resources :events, :controller => 'games/events'

      games.resources :albums, :controller => 'games/albums'

      games.resources :tags, :controller => 'games/tags'

      games.resources :attentions, :controller => 'games/attentions'

    end

    users.resources :forums do |forums|
  
      forums.resources :topics, :collection => {:top => :get}, :member => {:toggle => :put} do |topics|
    
        topics.resources :posts
    
      end

    end

    users.resources :ratings

    users.resources :signup_invitations, :collection => {:create_multiple => :post}#, :controller => 'temp_signup_invitations'

    users.auto_complete_for_game_tags '/auto_complete_for_game_tags', :controller => 'tags', :action => 'auto_complete_for_game_tags' 

    users.resources :game_suggestions, :collection => {:game_tags => :get}
 
    users.search_characters '/search_characters', :controller => 'search', :action => 'character'

    users.search_users '/search_users', :controller => 'search', :action => 'user'

    users.resources :news

    users.resources :reports

    users.resources :guestbooks

    users.resources :contacts, :controller => 'email_contacts', :collection => {:sina => :get, :netease => :get, :hotmail => :get, :yahoo => :get, :gmail => :get, :msn => :get}
  end

  map.connect ':subdomain', :controller => 'user/profiles', :action => 'show'
	map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
