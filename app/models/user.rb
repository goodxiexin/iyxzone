require 'digest/sha1'

class User < ActiveRecord::Base

  acts_as_pinyin :login => "pinyin"

	searcher_column :pinyin, :login

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

  def is_mailable_by? user
    p = privacy_setting.mail
    p == 1 || has_friend?(user) || (p == 2 and has_same_game_with?(user))
  end

  def interested_in_game? game
		!game_attentions.find_by_game_id(game.id).nil?
  end

  has_many :game_attentions

	has_many :interested_games, :through => :game_attentions, :source => :game, :order => 'sale_date DESC'

	# notifications
	has_many :notifications, :order => 'created_at DESC'

	has_many :notices, :order => 'created_at DESC' # comment, tag notices

	# pokes
	has_many :poke_deliveries, :foreign_key => 'recipient_id', :order => 'created_at DESC'

  def is_pokeable_by? user
    p = privacy_setting.poke
    p == 1 || has_friend?(user) || (p == 3 and has_same_game_with?(user))
  end

	# status
  has_many :statuses, :foreign_key => 'poster_id', :order => 'created_at DESC', :dependent => :destroy

	has_one :latest_status, :foreign_key => 'poster_id', :class_name => 'Status', :order => 'created_at DESC'

  def friend_statuses
    Status.find(:all, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = statuses.poster_id", :order => 'created_at desc')
  end

  # friend
	has_many :all_friendships, :class_name => 'Friendship'

  has_many :friendships, :dependent => :destroy, :conditions => {:status => 1}

	has_many :friends, :through => :friendships, :source => 'friend', :order => 'pinyin ASC'

  def has_friend? user
    user_id = (user.is_a? Integer)? user : user.id
		!friendships.find_by_friend_id(user_id).blank? 
  end

  def wait_for? user
		all_friendships.find_by_friend_id_and_status(user.id, 0) 
  end

	def common_friends_with user
    if self == user
      friends
    else
		  friends & user.friends
    end
	end

  def is_friendable_by? user
    p = privacy_setting.add_me_as_friend
    p == 1 || (p == 2 and has_same_game_with?(user))
  end

  # settings
	has_setting :application_setting

	has_setting :privacy_setting

	has_setting :mail_setting

  # game
  has_many :characters, :class_name => 'GameCharacter', :dependent => :destroy

  has_many :currently_playing_game_characters, :class_name => 'GameCharacter', :conditions => { :playing => true }, :order => 'created_at DESC' 

  has_many :games, :through => :characters, :uniq => true

	has_many :servers, :through => :characters, :uniq => true

  def friend_characters opts={}
    game_cond = ActiveRecord::Base.send(:sanitize_sql_hash_for_conditions, opts, "game_characters")
    game_cond = "AND #{game_cond}" unless game_cond.blank?
    GameCharacter.find(:all, :joins => "INNER JOIN friendships on friendships.user_id = #{id} AND friendships.friend_id = game_characters.user_id #{game_cond}")
  end

  def friend_games
    game_ids = GameCharacter.find(:all, :select => :game_id, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = game_characters.user_id").map(&:game_id).uniq
    Game.find(game_ids, :order => 'pinyin ASC')
  end

	def interested_in_game? game
    !game_attentions.find_by_game_id(game.id).nil?
  end

	def has_same_game_with? user
		!(user.characters.map(&:game_id) & characters.map(&:game_id)).blank?
	end

  # album
  belongs_to :avatar

  has_one :avatar_album, :foreign_key => 'owner_id'

  # 为了保证avatar album一定在最后一个，我们不在这里加上avatar album
  has_many :albums, :class_name => 'PersonalAlbum', :foreign_key => 'owner_id', :order => 'created_at DESC'

  has_many :active_albums, :class_name => 'Album', :foreign_key => 'owner_id', :order => 'uploaded_at DESC', :conditions => "uploaded_at IS NOT NULL AND (type = 'AvatarAlbum' OR type = 'PersonalAlbum')"

  def friend_albums
    PersonalAlbum.find(:all, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = albums.poster_id", :conditions => "privilege != 4 AND photos_count != 0", :order => 'uploaded_at desc')
  end

  def albums_count relationship='owner'
    # dont forget avatar album which is not accessible to none-friend
    case relationship
    when 'owner'
      albums_count1 + albums_count2 + albums_count3 + albums_count4 + 1
    when 'friend'
      albums_count1 + albums_count2 + albums_count3 + 1
    when 'same_game'
      albums_count1 + albums_count2 + 1
    when 'stranger'
      albums_count1
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

  def friend_blogs
    Blog.find(:all, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = blogs.poster_id", :conditions => "privilege != 4 AND draft != 1", :order => 'created_at desc')
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

  def friend_videos
    Video.find(:all, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = videos.poster_id", :conditions => "privilege != 4", :order => 'created_at desc')
  end

  # events
  has_many :participations, :foreign_key => 'participant_id', :conditions => {:status => [3,4,5]} 

  has_many :events, :foreign_key => 'poster_id', :order => 'created_at DESC', :conditions => ["end_time >= ?", Time.now.to_s(:db)]

	with_options :order =>  'created_at DESC', :through => :participations, :source => :event do |user|

		user.has_many :all_events

    # 不包括我发起的，这样的都在events里
		user.has_many :upcoming_events, :conditions => ['events.poster_id != #{id} AND events.start_time >= ?', Time.now.to_s(:db)]

		user.has_many :participated_events, :conditions => ["events.end_time < ?", Time.now.to_s(:db)]

	end

  def friend_events
    event_ids = Participation.find(:all, :select => :event_id, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = participations.participant_id", :conditions => "participations.status != 0 AND participations.status != 1").map(&:event_id).uniq
    Event.find(event_ids)
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

    user.has_many :poll_sharings, :conditions => {:shareable_type => 'Poll'}

    user.has_many :game_sharings, :conditions => {:shareable_type => 'Game'}

    user.has_many :profile_sharings, :conditions => {:shareable_type => 'Profile'}

    user.has_many :topic_sharings, :conditions => {:shareable_type => 'Topic'}
  
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

  end

  def friend_sharings type=nil
    cond = type.nil? ? {} : {:shareable_type => type}
    Sharing.find(:all, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = sharings.poster_id", :conditions => cond, :order => 'created_at desc')
  end

  # polls
  has_many :votes, :foreign_key => 'voter_id'

  has_many :polls, :foreign_key => 'poster_id', :order => 'created_at DESC'

  has_many :participated_polls, :through => :votes, :uniq => true, :source => 'poll', :order => 'created_at DESC', :conditions => 'poster_id != #{id}'

  def friend_votes
    Vote.find(:all, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = votes.voter_id")
  end

  def friend_polls
    poll_ids = Vote.find(:all, :select => :poll_id, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = votes.voter_id").map(&:poll_id).uniq
    participated = Poll.find(poll_ids)
    posted = Poll.find(:all, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = polls.poster_id", :order => 'created_at desc')
    participated.concat(posted).uniq.sort {|p1, p2| p2.created_at <=> p1.created_at }
  end

	# guilds
	has_many :memberships

  has_many :guilds, :foreign_key => 'president_id'

	with_options :through => :memberships, :source => :guild, :order => 'guilds.created_at DESC' do |user|

    user.has_many :all_guilds, :conditions => "memberships.status IN (3,4,5)"

    user.has_many :privileged_guilds, :conditions => "memberships.status = 3 or memberships.status = 4"

		user.has_many :participated_guilds, :conditions => "memberships.status = 4 or memberships.status = 5"

	end

  def friend_memberships
    Membership.find(:all, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = memberships.user_id", :conditions => "memberships.status != 0 AND memberships.status != 1") 
  end

  def friend_guilds
    guild_ids = Membership.find(:all, :select => :guild_id, :joins => "inner join friendships on friendships.user_id = #{id} and friendships.friend_id = memberships.user_id", :conditions => "memberships.status != 0 AND memberships.status != 1").map(&:guild_id).uniq
    Guild.find(guild_ids, :order => 'created_at desc')
  end

	def common_guilds_with user
    all_guilds & user.all_guilds
	end

	# invitation and requests
	has_many :event_requests, :through => :events, :source => :requests

	has_many :event_invitations, :class_name => 'Participation', :foreign_key => 'participant_id', :conditions => {:status => 0}

	has_many :poll_invitations 

	has_many :guild_requests, :through => :guilds, :source => :requests 

	has_many :guild_invitations, :class_name => 'Membership',:conditions => {:status => 0}

	has_many :friend_requests, :class_name => 'Friendship', :foreign_key => 'friend_id', :conditions => {:status => 0}

  def invitations_count
    guild_invitations_count + event_invitations_count + poll_invitations_count
  end

  def requests_count
    friend_requests_count + guild_requests_count + event_requests_count
  end

	# tags
	has_many :friend_tags, :foreign_key => 'tagged_user_id'

	has_many :relative_blogs, :through => :friend_tags, :source => 'blog', :conditions => "privilege != 4 AND draft != 1"

	has_many :relative_videos, :through => :friend_tags, :source => 'video', :conditions => "privilege != 4"

	has_many :photo_tags, :foreign_key => 'tagged_user_id'

	has_many :relative_photos, :through => :photo_tags, :source => 'photo', :conditions => "privilege != 4"

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

  def add_role name
    role = Role.find_by_name(name)
    role_users.create(:role_id => role.id) unless role.nil?
  end

  def relationship_with user
    if self == user
      'owner'
    elsif has_friend?(user) or wait_for?(user)
      'friend'
    elsif has_same_game_with? user
      'same_game'
    else
      'stranger'
    end
  end

  # messages
  has_many :messages, :foreign_key => 'recipient_id'

  has_many :unread_messages, :class_name => 'Message', :foreign_key => 'recipient_id', :conditions => {:read => 0}

  def messages_with friend
    Message.all(:conditions => "(recipient_id = #{id} AND poster_id = #{friend.id}) OR (recipient_id = #{friend.id} AND poster_id = #{id})", :order => 'created_at DESC')
  end
  
  # invitation
  has_many :signup_invitations, :class_name => 'SignupInvitation', :foreign_key => 'sender_id'

  include UserAuthentication 

  include FriendSuggestor

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :password, :password_confirmation, :gender, :avatar_id

  def validate_on_create
    # check login
    if login.blank?
      errors.add_to_base("昵称不能为空")
      return
    elsif login.length < 4 or login.length > 16
      errors.add_to_base("昵称长度不对")
      return
    elsif /^\d/.match(login)
      errors.add_to_base("昵称不能以数字开头")
      return
    end

    # check gender
    if gender.blank?
      errors.add_to_base("性别为空")
      return
    elsif gender != 'male' and gender != 'female'
      errors.add_to_base("未知的性别")
      return
    end

    # check email
    if email.blank?
      errors.add_to_base("邮件为空")
      return 
    elsif !/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/.match(email)
      errors.add_to_base("邮件格式不对")
      return
    elsif !User.find_by_email(email.downcase).blank?
      errors.add_to_base("邮件已经被注册了")
      return
    end
  end

end
