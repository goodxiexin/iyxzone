require 'digest/sha1'

class User < ActiveRecord::Base

  acts_as_attentionable

  has_many :mini_blogs, :foreign_key => :poster_id, :order => 'created_at DESC', :as => :poster, :dependent => :destroy

  def follows category=nil
    attentions = Attention.match(:follower_id => id)
    attentions.group_by(&:attentionable_type).map do |attentionable_type, attentions|
      cond = {:poster_id => attentions.map(&:attentionable_id)}.merge(category.nil? ? {} : {:category => category})
      MiniBlog.match(cond).all
    end.flatten.uniq.sort {|a, b| b.created_at <=> a.created_at }
  end

  has_many :fanships, :foreign_key => :idol_id, :dependent => :destroy

  has_many :fans, :through => :fanships, :source => :fan

  has_many :idolships, :foreign_key => :fan_id, :class_name => 'Fanship', :dependent => :destroy

  has_many :idols, :through => :idolships, :source => :idol

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

  def interested_in_game? game
		!game_attentions.find_by_game_id(game.id).nil?
  end

  def has_game? game
    game_id = game.is_a?(Integer) ? game : game.id
    !characters.find_by_game_id(game_id).blank?
  end

  has_many :game_attentions, :dependent => :destroy

	has_many :interested_games, :through => :game_attentions, :source => :game, :order => 'sale_date DESC'

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

	# status
  has_many :statuses, :foreign_key => 'poster_id', :order => 'created_at DESC', :dependent => :destroy

  # friend
	has_many :all_friendships, :class_name => 'Friendship', :dependent => :destroy

    # 定义这个完全是为了删除方便
  has_many :friend_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id', :dependent => :destroy

  has_many :friendships, :conditions => {:status => Friendship::Friend}

	has_many :friends, :through => :friendships, :source => 'friend', :order => 'pinyin ASC'

  def friend_ids
    friendships.map(&:friend_id)
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

	def interested_in_game? game
    !game_attentions.find_by_game_id(game.id).nil?
  end

	def has_same_game_with? user
		!(user.characters.map(&:game_id) & characters.map(&:game_id)).blank?
	end

  # album
  belongs_to :avatar

  has_one :avatar_album, :foreign_key => 'owner_id', :dependent => :destroy

  has_many :albums, :class_name => 'PersonalAlbum', :foreign_key => 'owner_id', :order => 'created_at DESC', :dependent => :destroy

  # 活跃的相册，就是有上传过东西的相册
  has_many :active_albums, :class_name => 'Album', :foreign_key => 'owner_id', :order => 'uploaded_at DESC', :conditions => "photos_count IS NOT NULL AND (type = 'AvatarAlbum' OR type = 'PersonalAlbum')"

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

  # sharings
  has_many :sharings, :foreign_key => 'poster_id', :order => 'created_at DESC', :dependent => :destroy

  # alias for sharings
  has_many :all_sharings, :foreign_key => 'poster_id', :order => 'created_at DESC', :class_name => 'Sharing'

  with_options :class_name => 'Sharing', :foreign_key => 'poster_id', :order => 'created_at DESC' do |user|
    
    user.has_many :blog_sharings, :conditions => {:shareable_type => 'Blog'}
  
    user.has_many :video_sharings, :conditions => {:shareable_type => 'Video'}

    user.has_many :link_sharings, :conditions => {:shareable_type => 'Link'}

    user.has_many :photo_sharings, :conditions => {:shareable_type => 'Photo'}

    user.has_many :album_sharings, :conditions => {:shareable_type => 'Album'}

    user.has_many :poll_sharings, :conditions => {:shareable_type => 'Poll'}

    user.has_many :game_sharings, :conditions => {:shareable_type => 'Game'}

    user.has_many :profile_sharings, :conditions => {:shareable_type => 'Profile'}

    user.has_many :topic_sharings, :conditions => {:shareable_type => 'Topic'}
 
    user.has_many :news_sharings, :conditions => {:shareable_type => 'News'}
 
  end

  has_many :shares, :through => :sharings, :order => 'created_at DESC'

  with_options :source => 'share', :order => 'created_at DESC' do |user|

    user.has_many :blog_shares, :through => 'blog_sharings'

    user.has_many :video_shares, :through => 'video_sharings'

    user.has_many :link_shares, :through => 'link_sharings'

    user.has_many :photo_shares, :through => 'photo_sharings'

    user.has_many :album_shares, :through => 'album_sharings'

    user.has_many :poll_shares, :through => 'poll_sharings'

    user.has_many :game_shares, :through => 'game_sharings'
  
    user.has_many :profile_shares, :through => 'profile_sharings'

    user.has_many :topic_shares, :through => 'topic_sharings'

    user.has_many :news_shares, :through => 'news_sharings'

  end

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

	# feeds
	#has_many :feed_deliveries, :as => 'recipient', :order => 'created_at DESC'
  acts_as_feed_recipient :delete_conditions => lambda {|requestor, user| requestor == user},
                         :categories => {
                            :status => 'Status', 
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
                            :sharing => 'Sharing',
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
