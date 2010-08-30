require 'ferret'
require 'digest/sha1'

class User < ActiveRecord::Base

  has_index :query_step => 20000,
            :select_fields => [:id, :login, :created_at],
            :writer => {:max_buffer_memory => 32, :max_buffered_docs => 20000},
            :field_infos => {
              :id => {:store => :yes, :index => :no, :term_vector => :no}, 
              :login => {:store => :yes, :index => :yes, :term_vector => :yes},
              :created_at => {:store => :yes, :index => :untokenized, :term_vector => :no} 
            }

  # required by has_index
  def to_doc
    doc = Ferret::Document.new
    
    doc[:id] = id
    doc[:login] = login
    doc[:created_at] = created_at

    doc
  end

  has_many :mini_topics

  has_many :mini_topic_attentions

  def interested_in_topic? name
    !mini_topic_attentions.find_by_topic_name(name).blank?
  end

  belongs_to :skilled_game, :class_name => "Game"

  has_many :mini_images, :foreign_key => 'poster_id', :order => 'created_at DESC'

  has_many :mini_blogs, :foreign_key => 'poster_id', :order => 'created_at DESC', :dependent => :destroy, :conditions => {:deleted => false}

  has_many :fanships, :foreign_key => :idol_id, :dependent => :destroy

  has_many :fans, :through => :fanships, :source => :fan

  has_many :idolships, :foreign_key => :fan_id, :class_name => 'Fanship', :dependent => :destroy

  has_many :idols, :through => :idolships, :source => :idol

  def idol_ids
    idolships.map(&:idol_id)
  end

  def fan_ids
    fanships.map(&:fan_id)
  end

  def has_fan? fan
    fanships.map(&:fan_id).include?(fan.is_a?(Integer) ? fan : fan.id)
  end

  def has_idol? idol
    idolships.map(&:idol_id).include?(idol.is_a?(Integer) ? idol : idol.id)
  end

  has_one :rss_feed

  has_many :user_tasks
  
  has_one :subdomain

  acts_as_random 

  acts_as_pinyin :login => "pinyin"

	searcher_column :pinyin, :login

	has_many :friend_suggestions, :dependent => :destroy

	has_many :comrade_suggestions, :dependent => :destroy

  # 方便删除
  has_many :friend_friend_suggestions, :foreign_key => 'suggested_friend_id', :class_name => 'FriendSuggestion', :dependent => :destroy

  # 方便删除
  has_many :friend_comrade_suggestions, :foreign_key => 'comrade_id', :class_name => 'ComradeSuggestion', :dependent => :destroy

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

  def has_game? game
    game_id = game.is_a?(Integer) ? game : game.id
    !characters.find_by_game_id(game_id).blank?
  end

	# notifications
	has_many :notifications, :order => 'created_at DESC', :dependent => :destroy

	has_many :notices, :order => 'created_at DESC', :dependent => :destroy # comment, tag notices

  def recv_notice? producer
    notices.map(&:producer).include? producer
  end

  validates_associated :rss_feed

  # this method is only used for test
  def recv_notice? producer
    !notices.select {|n| n.producer == producer}.blank?
  end

	# pokes
	has_many :poke_deliveries, :foreign_key => 'recipient_id', :order => 'created_at DESC'

  def is_pokeable_by? user
    privacy_setting.poke? user.relationship_with(self)
  end

  # friend
	has_many :all_friendships, :class_name => 'Friendship', :dependent => :destroy

    # 定义这个完全是为了删除方便
  has_many :friend_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id', :dependent => :destroy

  has_many :friendships, :conditions => {:status => Friendship::Friend}

	has_many :friends, :through => :friendships, :source => 'friend', :order => 'pinyin ASC'

  def friend_ids
    friendships.map(&:friend_id)
  end

  # 那些你请求加为好友的人
  def request_friend_ids
    all_friendships.match(:status => Friendship::Request, :user_id => id).map(&:friend_id) 
  end

  # 那些请求加你好友的人
  def requested_friend_ids
    all_friendships.match(:status => Friendship::Request, :friend_id => id).map(&:user_id)
  end

  def has_friend? user
    user_id = (user.is_a? Integer)? user : user.id
		!friendships.find_by_friend_id(user_id).blank? 
  end

  def wait_for? user
		all_friendships.find_by_friend_id_and_status(user.id, Friendship::Request) 
  end

	def common_friends_with user
    if self == user
      friends
    else
		  friends & user.friends
    end
	end

  # settings
	has_setting :application_setting

	has_setting :privacy_setting

	has_setting :mail_setting

  # game
  has_many :characters, :class_name => 'GameCharacter', :dependent => :destroy

  def has_character? character
    characters.include? character
  end

  has_many :currently_playing_game_characters, :class_name => 'GameCharacter', :conditions => { :playing => true }, :order => 'created_at DESC' 

  has_many :games, :through => :characters, :uniq => true

	has_many :servers, :through => :characters, :uniq => true

  def game_ids
    characters.map(&:game_id).uniq
  end

  def interested_games
    games = []
    mini_topic_attentions.each do |a|
      g = Game.find_by_name a.topic_name
      games << g if !g.blank?
    end
    games
  end

  def interested_in_game? game
    !mini_topic_attentions.find_by_topic_name(game.name).blank?
  end

	def has_same_game_with? user
		!(user.characters.map(&:game_id) & characters.map(&:game_id)).blank?
	end

  # album
  belongs_to :avatar

  has_one :avatar_album, :foreign_key => 'owner_id', :dependent => :destroy

  has_many :albums, :class_name => 'PersonalAlbum', :foreign_key => 'owner_id', :order => 'created_at DESC', :dependent => :destroy

  # 活跃的相册，就是有上传过东西的相册
  has_many :active_albums, :class_name => 'Album', :foreign_key => 'owner_id', :order => 'uploaded_at DESC', :conditions => "photos_count != 0 AND (type = 'AvatarAlbum' OR type = 'PersonalAlbum')"

  def albums_count relationship='owner'
    # dont forget avatar album which is not accessible to none-friend
    avatar_album_count = self.avatar_album.rejected? ? 0 : 1
    if relationship == 'owner'
      avatar_album_count + albums_count1 + albums_count2 + albums_count3 + albums_count4
    elsif relationship == 'friend'
      avatar_album_count + albums_count1 + albums_count2 + albums_count3
    elsif relationship == 'same_game'
      avatar_album_count + albums_count1 + albums_count2
    elsif relationship == 'stranger'
      avatar_album_count + albums_count1
    end
  end

  def all_albums
    (all_events.map(&:album) + all_guilds.map(&:album) + albums.to_a + avatar_album.to_a).uniq
  end

  # blogs
  with_options :order => 'created_at DESC', :dependent => :destroy, :foreign_key => :poster_id do |user|
    
    user.has_many :blogs, :conditions => {:draft => false}

    user.has_many :drafts, :class_name => 'Blog', :conditions => {:draft => true}

    user.has_many :blogs_and_drafts, :class_name => 'Blog'
  
  end

  def blogs_count relationship='owner'
    case relationship
    when 'owner'
      blogs_count1 + blogs_count2 + blogs_count3 + blogs_count4
    when 'friend'
      blogs_count1 + blogs_count2 + blogs_count3
    when 'same_game'
      blogs_count1 + blogs_count2
    when 'stranger'
      blogs_count1    
    end
  end

  # videos
  has_many :videos, :order => 'created_at DESC', :dependent => :destroy, :foreign_key => :poster_id

  def videos_count relationship='owner'
    case relationship
    when 'owner'
      videos_count1 + videos_count2 + videos_count3 + videos_count4
    when 'friend'
      videos_count1 + videos_count2 + videos_count3
    when 'same_game'
      videos_count1 + videos_count2
    when 'stranger'
      videos_count1    
    end  
  end

  # events
  has_many :participations, :foreign_key => 'participant_id', :dependent => :destroy, :conditions => {:status => [Participation::Confirmed, Participation::Maybe]}

  has_many :events, :foreign_key => 'poster_id', :order => 'created_at DESC'

	with_options :through => :participations, :source => :event, :uniq => true do |user|

		user.has_many :all_events, :order => 'created_at DESC'

		user.has_many :upcoming_events, :conditions => ['events.poster_id != #{id} AND events.end_time > ?', Time.now.to_s(:db)], :order => 'start_time ASC'

		user.has_many :participated_events, :conditions => ["events.end_time <= ?", Time.now.to_s(:db)], :order => 'end_time DESC'

	end
	
  def common_events_with user
		events & user.events
	end

  # comments, digs
  has_many :comments, :foreign_key => 'poster_id', :dependent => :destroy

  has_many :digs, :foreign_key => 'poster_id', :dependent => :destroy

  # polls
  has_many :votes, :foreign_key => 'voter_id', :dependent => :destroy

  has_many :polls, :foreign_key => 'poster_id', :order => 'created_at DESC', :dependent => :destroy

  has_many :participated_polls, :through => :votes, :uniq => true, :source => 'poll', :order => 'created_at DESC', :conditions => 'poster_id != #{id}'

	# guilds
	has_many :memberships, :dependent => :destroy, :conditions => {:status => [Membership::President, Membership::Veteran, Membership::Member]}

  has_many :guilds, :foreign_key => 'president_id', :dependent => :destroy, :order => "created_at DESC"

	with_options :through => :memberships, :source => :guild, :order => 'guilds.created_at DESC', :uniq => true do |user|

    user.has_many :all_guilds

    user.has_many :privileged_guilds, :conditions => "memberships.status IN (#{Membership::President},#{Membership::Veteran})"

		user.has_many :participated_guilds, :conditions => "memberships.status IN (#{Membership::Veteran}, #{Membership::Member})"

	end

  def guild_ids
    memberships.map(&:guild_id).uniq
  end
	
  def common_guilds_with user
    all_guilds & user.all_guilds
	end

	# invitation and requests
	has_many :event_requests, :through => :events, :source => :requests, :order => "created_at DESC"

	has_many :event_invitations, :class_name => 'Participation', :foreign_key => 'participant_id', :conditions => {:status => Participation::Invitation}, :order => 'created_at DESC'

	has_many :poll_invitations, :order => 'created_at DESC'

	has_many :guild_requests, :through => :guilds, :source => :requests, :order => "created_at DESC"

	has_many :guild_invitations, :class_name => 'Membership',:conditions => {:status => Membership::Invitation}, :order => "created_at DESC"

	has_many :friend_requests, :class_name => 'Friendship', :foreign_key => 'friend_id', :conditions => {:status => Friendship::Request}, :order => "created_at DESC"

  def invitations_count
    guild_invitations_count + event_invitations_count + poll_invitations_count
  end

  def requests_count
    friend_requests_count + guild_requests_count + event_requests_count
  end

	# tags
	has_many :friend_tags, :foreign_key => 'tagged_user_id', :dependent => :destroy

	has_many :relative_blogs, :through => :friend_tags, :source => 'blog', :conditions => "draft != 1"

	has_many :relative_videos, :through => :friend_tags, :source => 'video'

	has_many :photo_tags, :foreign_key => 'tagged_user_id', :dependent => :destroy

	has_many :relative_photos, :through => :photo_tags, :source => 'photo'

  def relative_photo_infos
    infos = []
    photo_tags.all(:include => [:photo, {:poster => :profile}]).group_by(&:photo_id).map do |photo_id, tags|
      photo = Photo.nonblocked.find(photo_id)
      if !photo.blank? and !photo.is_owner_privilege?
        infos << {:photo => photo, :posters => tags.map(&:poster).uniq}
      end
    end
    infos
  end

  acts_as_feed_recipient :delete_conditions => lambda {|requestor, user| requestor == user},
                         :categories => {
                            :blog => 'Blog', 
                            :video => 'Video', 
                            :personal_album => 'PersonalAlbum',
                            :avatar => 'Avatar',
                            :event_album => 'EventAlbum',
                            :guild_album => 'GuildAlbum',
                            :all_album_related => ['EventAlbum', 'GuildAlbum', 'PersonalAlbum', 'Avatar'],
                            :poll => 'Poll',
                            :vote => 'Vote',
                            :all_poll_related => ['Poll', 'Vote'],
                            :event => 'Event',
                            :participation => 'Participation',
                            :all_event_related => ['Event', 'Participation'],
                            :guild => 'Guild',
                            :membership => 'Membership',
                            :all_guild_related => ['Guild', 'Membership'],
                            :profile => 'Profile',
                            :friendship => 'Friendship'}  

  # role
  has_many :role_users, :dependent => :destroy

  has_many :roles, :through => :role_users

  def has_roles? names
    required_roles = names.uniq.map {|name| Role.find_by_name(name)}
    required_roles && roles == required_roles
  end

  def is_admin?
    has_roles? ['admin']
  end

  def add_role name
    role = Role.find_by_name(name)
    role_users.create(:role_id => role.id) unless role.nil?
  end

  def relationship_with user
    if self == user
      'owner'
    elsif has_friend?(user) or user.wait_for?(self) or user.has_fan?(self) or self.has_fan?(user)
      'friend'
    elsif has_same_game_with? user
      'same_game'
    else
      'stranger'
    end
  end

  # messages
  has_many :messages, :foreign_key => 'recipient_id', :dependent => :destroy

  has_many :unread_messages, :class_name => 'Message', :foreign_key => 'recipient_id', :conditions => {:read => 0}

  def messages_with friend
    Message.all(:conditions => "(recipient_id = #{id} AND poster_id = #{friend.id}) OR (recipient_id = #{friend.id} AND poster_id = #{id})", :order => 'created_at DESC')
  end
  
  # invitation
  has_many :signup_invitations, :class_name => 'SignupInvitation', :foreign_key => 'sender_id', :dependent => :destroy

  include UserAuthentication 

  include FriendSuggestor

  named_scope :hot, :conditions => ["created_at > ?", 1.weeks.ago.to_s(:db)], :order => "friends_count DESC, created_at DESC"

end
