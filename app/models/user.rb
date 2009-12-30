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

  has_many :albums, :class_name => 'PersonalAlbum', :foreign_key => 'owner_id', :order => 'uploaded_at DESC'

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

		user.has_many :upcoming_events, :conditions => ["events.start_time >= ?", Time.now.to_s(:db)]

		user.has_many :participated_events, :conditions => ["events.start_time < ?", Time.now.to_s(:db)]

	end

	def common_events_with user
		events & user.events
	end

  # polls
  has_many :votes, :foreign_key => 'voter_id'

  has_many :polls, :foreign_key => 'poster_id', :order => 'created_at DESC'

  has_many :participated_polls, :through => :votes, :uniq => true, :source => 'poll', :order => 'created_at DESC', :conditions => 'poster_id != #{id}'

	# guilds
	has_many :memberships

	with_options :through => :memberships, :source => :guild, :order => 'guilds.created_at DESC' do |user|

		user.has_many :all_guilds

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

	end

	acts_as_resource_feeds

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
	
	end

  attr_accessor :password, :password_confirmation

	attr_reader :enabled

  # callbacks
  before_save :encrypt_password
  before_create :make_activation_code

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :password, :password_confirmation, :gender

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save(false)
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end

  def has_role?(name)
    self.roles.find_by_name(name) ? true : false
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def recently_forgot_password?
    @forgotten_password
  end

  def recently_reset_password?
    @reset_password
  end

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = BetaInvitation.find_by_token(token)
  end

protected
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def set_invitation_limit
    self.invitation_limit = 5
  end   
 
end
