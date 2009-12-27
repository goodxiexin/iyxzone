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

  map.regions '/regions', :controller => 'chinese_region', :action => 'regions'

  map.cities '/cities', :controller => 'chinese_region', :action => 'cities'

  map.districts '/districts', :controller => 'chinese_region', :action => 'districts'

  map.namespace :admin do |admin|
  
    admin.resources :users

  end

  map.namespace :user, :name_prefix => '', :path_prefix => ''  do |users|

    users.resources :sharings, :collection => {:hot => :get, :recent => :get, :friends => :get}

    users.resources :notices, :collection => {:first_ten => :get}

    users.resources :pokes, :collection => {:destroy_all => :delete}

    users.resources :characters

    users.resources :visitor_records

    users.resources :forums

    users.resources :requests, :collection => {:destroy_all => :delete}

    users.resources :invitations, :collection => {:destroy_all => :delete}

    users.resources :notifications, :collection => {:destroy_all => :delete, :first_five => :get}

    users.resources :profile_viewings

    users.resources :profiles, :member => {:more_feeds => :get} do |profiles|

      profiles.resources :tags, :controller => 'profiles/tags'

      profiles.resources :wall_messages, :controller => 'profiles/wall_messages'

    end

    # 这个貌似没什么用
    users.auto_complete_for_mail_recipients '/auto_complete_for_mail_recipients', :controller => 'mails', :action => 'auto_complete_for_recipients'

    users.resources :mails, :collection => {:read_multiple => :put, :unread_multiple => :put, :destroy_multiple => :delete}, :member => {:reply => :post}

    users.resources :friend_suggestions

    users.resources :friend_impressions, :controller => 'friends/impressions'

    users.resources :friends, :collection => {:search => :get, :other => :get, :common => :get} do |friends|

      friends.resources :requests, :controller => 'friends/requests', :member => {:accept => :put, :decline => :put}

    end

    users.resources :feed_deliveries

    users.resource :home, :controller => 'home', :member => {:more_feeds => :get}

    users.resource :privacy_setting, :controller => 'privacy_setting'

    users.resource :password_setting, :controller => 'password_setting'

    users.resource :application_setting, :controller => 'application_setting'

    users.resource :mail_setting, :controller => 'mail_setting'

    users.resources :blogs, :collection => [:hot, :recent, :relative, :friends]

    users.resources :drafts

    users.resources :videos, :collection => [:hot, :recent, :relative, :friends]

    users.resources :statuses, :collection => [:friends]

    users.friend_table_for_photo_tags '/friend_table_for_photo_tags', :controller => 'photo_tags', :action => 'friends'

    users.auto_complete_for_photo_tags '/auto_complete_for_photo_tags', :controller => 'photo_tags', :action => 'auto_complete_for_friends'

    users.resources :photo_tags

    users.resources :comments

    users.resources :digs

    users.friend_table_for_friend_tags '/friend_table_for_friend_tags', :controller => 'friend_tags', :action => 'friend_table'

    users.auto_complete_for_friend_tags '/auto_complete_for_friend_tags', :controller => 'friend_tags', :action => 'auto_complete_for_friend_tags'

    users.resources :friend_tags

    users.resources :personal_albums, :controller => 'albums', 
                    :collection => {:select => :get, :recent => :get, :friends => :get}, 
                    :member => {:confirm_destroy => :get}

    users.resources :personal_photos, :controller => 'photos',
                    :collection => {:hot => :get, :relative => :get, :edit_multiple => :get, :update_multiple => :put}

    users.resources :avatar_albums, :controller => 'avatars/albums'

    users.resources :avatars, :controller => 'avatars/photos', :member => {:set => :put}

    users.resources :event_albums, :controller => 'events/albums'

    users.resources :event_photos, :controller => 'events/photos', :collection => {:edit_multiple => :get, :update_multiple => :put}

    users.resources :events, :collection => [:hot, :recent, :participated, :upcoming, :friends] do |events|

      events.resources :participations, :controller => 'events/participations'

      events.resources :invitations, :controller => 'events/invitations', :collection => {:search => :get, :create_multiple => :post}
  
      events.resources :requests, :controller => 'events/requests', :member => {:accept => :put, :decline => :put}

      events.resources :wall_messages, :controller => 'events/wall_messages'

    end

    users.resources :guild_albums, :controller => 'guild/albums'

    users.resources :guild_photos, :controller => 'guild/photos', :collection => {:edit_multiple => :get, :update_multiple => :put}

    users.resources :guilds, :member => {:more_feeds => :get},
                    :collection => {:hot => :get, :recent => :get , :participated => :get, :friends => :get} do |guilds|

      guilds.resources :friends

      guilds.resources :memberships, :controller => 'guilds/memberships', :collection => {:search => :get}

      guilds.resources :invitations, :controller => 'guilds/invitations', :collection => {:search => :get, :create_multiple => :post}, :member => {:accept => :put, :decline => :delete}

      guilds.resources :requests, :controller => 'guilds/requests', :member => {:accept => :put, :decline => :delete}

      guilds.resources :events, :controller => 'guilds/events', :collection => {:search => :get}

      guilds.resources :wall_messages, :controller => 'guilds/wall_messages'

    end

    users.resources :polls, :collection => [:hot, :recent, :participated, :friends] do |polls|

      polls.resources :answers, :controller => 'polls/answers'

      polls.resources :invitations, :controller => 'polls/invitations', :collection => {:search => :get, :create_multiple => :post}

      polls.resources :votes, :controller => 'polls/votes'

    end

    users.resources :game_attentions

    users.resources :games, :collection => {:sex => :get, :hot => :get, :friends => :get}, :member => {:game_details => :get, :area_details => :get} do |games|

      games.resources :blogs, :controller => 'games/blogs'

      games.resources :guilds, :controller => 'games/guilds'

      games.resources :events, :controller => 'games/events'

      games.resources :albums, :controller => 'games/albums'

      games.resources :tags, :controller => 'games/tags'

      games.resources :wall_messages, :controller => 'games/wall_messages'
 
    end

    users.resources :forums do |forums|
  
      forums.resources :topics, :member => {:toggle => :put} do |posts|
  
        posts.resources :posts
  
      end
  
    end

    users.resources :game_suggestions, :collection => {:game_tags => :get}
 
    users.search_characters '/search_characters', :controller => 'search', :action => 'character'

    users.search_users '/search_users', :controller => 'search', :action => 'user'

  end
 
	map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
