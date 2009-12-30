require 'digest/sha1'

class User < ActiveRecord::Base

  acts_as_pinyin :login => "pinyin"

	searcher_column :pinyin

	include FriendSuggestor

	has_many :friend_suggestions

	has_many :comrade_suggestions

  has_one :profile, :dependent => :destroy

	# mails
	has_many :out_mails, :class_name => 'Mail', :foreign_key => 'sender_id', 
					 :conditions => { :delete_by_sender => false }, :order => 'created_at DESC'

  has_many :in_mails, :class_name => 'Mail', :foreign_key => 'recipient_id', 
					 :conditions => { :delete_by_recipient => false }, :order => 'created_at DESC'  

  def sent_mails
    mails = self.out_mails.group_by { |mail| mail.parent_id }
    mails.map do |parent_id, mail_array|
      mail_array.max {|a,b| a.created_at <=> b.created_at}
    end.sort {|a,b| b.created_at <=> a.created_at}
  end

  def recv_mails
    mails = self.in_mails.group_by { |mail| mail.parent_id }
    mails.map do |parent_id, mail_array|
      mail_array.max {|a,b| a.created_at <=> b.created_at}
    end.sort {|a,b| b.created_at <=> a.created_at }
  end

  def unread_recv_mails
    mails = self.in_mails.group_by { |mail| mail.parent_id }
    mails = mails.map do |parent_id, mail_array|
      mail_array.max {|a,b| a.created_at <=> b.created_at}
    end.sort {|a,b| b.created_at <=> a.created_at }
    mails.find_all {|m| !m.read_by_recipient}
  end

  def interested_in_game? game
		!game_attentions.find_by_game_id(game.id).nil?
  end

  has_many :game_attentions

	has_many :interested_games, :through => :game_attentions, :source => :game

	# notifications
	has_many :notifications, :order => 'created_at DESC'

	has_many :notices, :order => 'created_at DESC' # comment, tag notices

	# pokes
	has_many :poke_deliveries, :foreign_key => 'recipient_id', :order => 'created_at DESC'

	# status
  has_many :statuses, :foreign_key => 'poster_id', :order => 'created_at DESC', :dependent => :destroy

	has_one :latest_status, :foreign_key => 'poster_id', :class_name => 'Status', :order => 'created_at DESC'

  # friend
	has_many :all_friendships, :class_name => 'Friendship'

  has_many :friendships, :dependent => :destroy, :conditions => {:status => 1}

	has_many :friends, :through => :friendships, :source => 'friend', :order => 'pinyin ASC'

  def has_friend? user
		friendships.find_by_friend_id(user.id) 
  end

  def wait_for? user
		all_friendships.find_by_friend_id_and_status(user.id, 0) 
  end

	def common_friends_with user
		friends & user.friends
	end

  # profile
  has_one :profile, :dependent => :destroy

  # settings
	has_setting :application_setting

	has_setting :privacy_setting

	has_setting :mail_setting

  # game
  has_many :characters, :class_name => 'GameCharacter', :dependent => :destroy

  has_many :currently_playing_game_characters, :class_name => 'GameCharacter', :conditions => { :playing => true }, :order => 'created_at DESC' 

  has_many :games, :through => :characters, :uniq => true

	has_many :servers, :through => :characters, :uniq => true

	def interested_in_game? game
    !game_attentions.find_by_game_id(game.id).nil?
  end

	def has_same_game_with user
		!(user.games & games).blank?
	end

  # album
  belongs_to :avatar

  has_one :avatar_album, :foreign_key => 'owner_id'

  # 为了保证avatar album一定在最后一个，我们不在这里加上avatar album
  has_many :albums, :class_name => 'PersonalAlbum', :foreign_key => 'owner_id', :order => 'uploaded_at DESC'

  has_many :active_albums, :class_name => 'Album', :foreign_key => 'owner_id', :order => 'uploaded_at DESC', :conditions => "uploaded_at IS NOT NULL AND (type = 'AvatarAlbum' OR type = 'PersonalAlbum')"

  # blogs
  has_many :blogs, :conditions => {:draft => false}, :order => 'created_at DESC', :dependent => :destroy, :foreign_key => :poster_id

  has_many :drafts, :class_name => 'Blog', :conditions => {:draft => true}, :order => 'created_at DESC', :dependent => :destroy, :foreign_key => :poster_id

  # videos
  has_many :videos, :order => 'created_at DESC', :dependent => :destroy, :foreign_key => :poster_id

  # events
  has_many :participations, :foreign_key => 'participant_id', :conditions => {:status => [3,4,5]} 

  has_many :events, :foreign_key => 'poster_id', :order => 'created_at DESC', :conditions => ["events.start_time >= ?", Time.now.to_s(:db)]

	with_options :order =>  'created_at DESC', :through => :participations, :source => :event do |user|

		user.has_many :all_events

    # 不包括我发起的，这样的都在events里
		user.has_many :upcoming_events, :conditions => ['events.poster_id != #{id} AND events.start_time >= ?', Time.now.to_s(:db)]

		user.has_many :participated_events, :conditions => ["events.start_time < ?", Time.now.to_s(:db)]

	end

	def common_events_with user
		events & user.events
	end

  # sharings
  has_many :sharings, :foreign_key => 'poster_id', :order => 'created_at DESC'

  with_options :class_name => 'Sharing', :foreign_key => 'poster_id', :order => 'created_at DESC' do |user|

    user.has_many :blog_sharings, :conditions => {:shareable_type => 'Blog'}

    user.has_many :video_sharings, :conditions => {:shareable_type => 'Video'}

    user.has_many :link_sharings, :conditions => {:shareable_type => 'Link'}

    user.has_many :photo_sharings, :conditions => {:shareable_type => 'Photo'}

    user.has_many :album_sharings, :conditions => {:shareable_type => 'Album'}

  end

  # polls
  has_many :votes, :foreign_key => 'voter_id'

  has_many :polls, :foreign_key => 'poster_id', :order => 'created_at DESC'

  has_many :participated_polls, :through => :votes, :uniq => true, :source => 'poll', :order => 'created_at DESC', :conditions => 'poster_id != #{id}'

	# guilds
	has_many :memberships

	with_options :through => :memberships, :source => :guild, :order => 'guilds.created_at DESC' do |user|

		user.has_many :guilds, :conditions => "memberships.status = 3"

		user.has_many :participated_guilds, :conditions => "memberships.status = 4 or memberships.status = 5"

		user.has_many :all_guilds, :conditions => "memberships.status IN (3,4,5)"

	end

	def common_guilds_with user
        all_guilds & user.all_guilds
	end

	# invitation and requests
	has_many :event_requests, :through => :events, :source => :requests

	has_many :event_invitations, :class_name => 'Participation', :foreign_key => 'participant_id', :conditions => {:status => 0}

	has_many :poll_invitations 

	has_many :guild_requests, :class_name => 'Membership', :foreign_key => 'president_id', :conditions => {:status => [1,2]}

	has_many :guild_invitations, :class_name => 'Membership',:conditions => {:status => 0}

	has_many :friend_requests, :class_name => 'Friendship', :foreign_key => 'friend_id', :conditions => {:status => 0}

	# tags
	has_many :friend_tags, :foreign_key => 'tagged_user_id'

	has_many :relative_blogs, :through => :friend_tags, :source => 'blog', :conditions => "privilege != 4"

	has_many :relative_videos, :through => :friend_tags, :source => 'video', :conditions => "privilege != 4"

	has_many :photo_tags, :foreign_key => 'tagged_user_id'

	has_many :relative_photos, :through => :photo_tags, :source => 'photo', :conditions => "privilege != 4"

	# feeds
	has_many :feed_deliveries, :as => 'recipient', :order => 'created_at DESC'

	with_options :class_name => 'FeedDelivery', :as => 'recipient', :order => 'created_at DESC' do |user|
	
		user.has_many :status_feed_deliveries, :conditions => {:item_type => 'Status'}

		user.has_many :blog_feed_deliveries, :conditions => {:item_type => 'Blog'}

		user.has_many :video_feed_deliveries, :conditions => {:item_type => 'Video'}

		user.has_many :personal_album_feed_deliveries, :conditions => {:item_type => 'PersonalAlbum'}

		user.has_many :all_album_related_feed_deliveries, :conditions => {:item_type => ['EventAlbum', 'GuildAlbum', 'PersonalAlbum', 'Avatar']}

		user.has_many :poll_feed_deliveries, :conditions => {:item_type => 'Poll'}

		user.has_many :vote_feed_deliveries, :conditions => {:item_type => 'Vote'}

		user.has_many :all_poll_related_feed_deliveries, :conditions => {:item_type => ['Poll', 'Vote']}

		user.has_many :event_feed_deliveries, :conditions => {:item_type => 'Event'}

    user.has_many :participation_feed_deliveries, :conditions => {:item_type => 'Participation'} 

		user.has_many :all_event_related_feed_deliveries, :conditions => {:item_type => ['Event', 'Participation']}

		user.has_many :guild_feed_deliveries, :conditions => {:item_type => 'Guild'}
	
		user.has_many :membership_feed_deliveries, :conditions => {:item_type => 'Membership'}

		user.has_many :all_guild_related_feed_deliveries, :conditions => {:item_type => ['Guild', 'Membership']}	

    user.has_many :sharing_feed_deliveries, :conditions => {:item_type => 'Sharing'}

	end

	with_options :order => 'created_at DESC', :source => 'feed_item' do |user|
	
		user.has_many :status_feed_items, :through => :status_feed_deliveries

		user.has_many :blog_feed_items, :through => :blog_feed_deliveries

		user.has_many :video_feed_items, :through => :video_feed_deliveries

		user.has_many :event_feed_items, :through => :event_feed_deliveries

		user.has_many :participation_feed_items, :through => :participation_feed_deliveries

		user.has_many :all_event_related_feed_items, :through => :all_event_related_feed_deliveries

		user.has_many :guild_feed_items, :through => :guild_feed_deliveries

		user.has_many :membership_feed_items, :through => :membership_feed_deliveries

		user.has_many :all_guild_related_feed_items, :through => :all_guild_related_feed_deliveries

		user.has_many :poll_feed_items, :through => :poll_feed_deliveries

		user.has_many :vote_feed_items, :through => :vote_feed_deliveries

		user.has_many :all_poll_related_feed_items, :through => :all_poll_related_feed_deliveries

		user.has_many :all_album_related_feed_items, :through => :all_album_related_feed_deliveries

		user.has_many :personal_album_feed_items, :through => :personal_album_feed_deliveries

    user.has_many :sharing_feed_items, :through => :sharing_feed_deliveries

  end

  # role
  has_many :role_users, :dependent => :destroy

  has_many :roles, :through => :role_users

  def has_roles? names
    required_roles = names.uniq.map {|name| Role.find_by_name(name)}
    required_roles && roles == required_roles
  end

  def add_role name
    role = Role.find_by_name(name)
    role_users.create(:role_id => role.id) unless role.nil?
  end

  include UserAuthentication 

end
