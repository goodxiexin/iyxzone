class Event < ActiveRecord::Base

  named_scope :people_order, :order => '(confirmed_count + maybe_count) DESC'

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}}}

  has_one :album, :class_name => 'EventAlbum', :foreign_key => 'owner_id', :dependent => :destroy

  belongs_to :poster, :class_name => 'User'

  belongs_to :poster_character, :class_name => 'GameCharacter', :foreign_key => 'character_id'

  belongs_to :game

  belongs_to :game_server

  belongs_to :game_area

  belongs_to :guild

	named_scope :hot, :conditions => ["end_time > ? AND verified IN (0,1)", Time.now], :order => 'confirmed_count DESC'
	
	named_scope :recent, :conditions => ["end_time > ? AND verified IN (0,1)", Time.now], :order => 'start_time DESC'

  has_many :participations # 没有dependent, 由于我们无法控制observer里的before_destroy先调用，还是destroy participation先调用

  has_many :confirmed_participations, :class_name => 'Participation', :conditions => {:status => Participation::Confirmed}

  has_many :maybe_participations, :class_name => 'Participation', :conditions => {:status => Participation::Maybe}

  has_many :invitations, :class_name => 'Participation', :conditions => {:status => Participation::Invitation}
  
  has_many :requests, :class_name => 'Participation', :conditions => {:status => Participation::Request}

	with_options :source => 'participant', :uniq => true do |event|

		event.has_many :invitees, :through => :invitations

		event.has_many :requestors, :through => :requests

		event.has_many :confirmed_participants, :through => :confirmed_participations

		event.has_many :maybe_participants, :through => :maybe_participations

		event.has_many :participants, :through => :participations, :conditions => "participations.status = 3 or participations.status = 4"

	end

  with_options :source => 'character' do |event|

    event.has_many :invite_characters, :through => :invitations

    event.has_many :request_characters, :through => :requests

    event.has_many :confirmed_characters, :through => :confirmed_participations

      event.has_many :maybe_characters, :through => :maybe_participations

    event.has_many :characters, :through => :participations, :conditions => "participations.status = 3 or participations.status = 4"

    event.has_many :all_characters, :through => :participations

  end

  needs_verification :sensitive_columns => [:title, :description]

  acts_as_commentable :order => 'created_at DESC',
                      :delete_conditions => lambda {|user, event, comment| event.poster == user}, 
                      :create_conditions => lambda {|user, event| event.has_participant?(user)},
                      :view_conditions => lambda { true } # this means anyone can view

	acts_as_resource_feeds :recipients => lambda {|event| [event.poster.profile, event.game] + event.poster.guilds + event.poster.friends.find_all {|f| f.application_setting.recv_event_feed == 1} }

	searcher_column :title

  # poster_id, game_server_id, game_area_id, game_id 不能改
  # guild_id 不能改，如果存在的话
  attr_readonly :poster_id, :character_id, :game_server_id, :game_area_id, :game_id, :guild_id

  def expired?
    end_time < Time.now
  end

  def participants_count
    confirmed_count + maybe_count
  end

  def has_participant? user
    participations.exists? :status => [3,4], :participant_id => user.id
  end

  def has_character? character
    participations.exists? :status => [3,4], :character_id => character.id
  end

  def participations_for user
    participations.all(:conditions => {:participant_id => user.id})
  end

  def confirmed_and_maybe_participations_for user
    participation.all(:conditions => {:status => [Participation::Confirmed, Participation::Maybe], :participant_id => user.id})
  end

  def requests_for user
    requests.all(:conditions => {:participant_id => user.id})
  end

  def invitations_for user
    invitations.all(:conditions => {:participant_id => user.id})
  end

  def characters_for user
    all_characters.all(:conditions => {:user_id => user.id})  
  end

  def confirmed_and_maybe_characters_for user
    characters.all(:conditions => {:user_id => user.id})
  end

  def request_characters_for user
    request_characters.all(:conditions => {:user_id => user.id})
  end

  def invite_characters_for user
    invite_characters.all(:conditions => {:user_id => user.id})
  end

  def is_guild_event?
    !guild_id.nil?
  end

  def was_guild_event?
    !guild_id_was.nil?
  end

  def time_changed?
    start_time_changed? || end_time_changed?
  end

  def requestable_characters_for user
    user.characters.find(:all, :conditions => {:game_id => game_id, :area_id => game_area_id, :server_id => game_server_id}) - characters_for(user)
  end

  def is_requestable_by? user
    return -3 if expired? 
    return -1 if requestable_characters_for(user).blank? 

    if is_guild_event?
      return 1 if guild.has_member?(user)
      return -2
    else
      return 1 if poster == user || privilege == 1 || (privilege == 2 and poster.has_friend? user)
      return 0
    end
  end

  def invitees= character_ids
    return if character_ids.blank?
    character_ids.each do |character_id|
      character = GameCharacter.find(character_id)
      invitations.build(:character_id => character.id, :participant_id => character.user_id)
    end
  end

  validates_presence_of :poster_id, :message => "不能为空", :on => :create

  validates_presence_of :title, :message => "不能为空"

  validates_size_of :title, :within => 1..100, :too_long => "最长100字节", :too_short => "最短1字节"

  validates_presence_of :description, :message => "不能为空"

  validates_size_of :description, :within => 1..10000, :too_long => "最长10000字节", :too_short => "最短1字节"

  validates_presence_of :start_time, :end_time, :message => "不能为空"

  validate :time_is_valid

  validate_on_create :guild_is_valid

  validates_presence_of :character_id, :message => "不能为空", :on => :create

  validate_on_create :character_is_valid

  validate_on_update :event_is_not_expired

  validates_inclusion_of :privilege, :message => "只能是1,2", :in => [1, 2]
 
protected

  def time_is_valid
    return if start_time.blank? or end_time.blank? or expired?

    if self.new_record?
      # 创建的时候开始时间不能比现在早
      errors.add(:start_time, "不能比现在早") if start_time <= Time.now
      errors.add(:end_time, "不能比开始时间早") if end_time <= start_time
    else
      # 更新的时候要求活动还没过期，就是结束时间还没到
      errors.add(:end_time, "不能比现在早") if end_time <= Time.now
      errors.add(:end_time, "不能比开始时间早") if end_time <= start_time
    end      
  end

  def guild_is_valid
    return if guild_id.blank?
    guild = Guild.find(:first, :conditions => {:id => guild_id})
    if guild.blank?
      errors.add(:guild_id, "不存在")
    elsif poster_id
      role = guild.role_for(poster)
      errors.add(:guild_id, "没有权限") if role == Membership::President or role == Membership::Veteran
    end
  end

  def character_is_valid
    return if character_id.blank?
    character = GameCharacter.find(:first, :conditions => {:id => character_id})
    errors.add(:character_id, "不存在") if character.blank?
    return if poster_id.blank?
    errors.add(:character_id, "不是拥有者") if character.user_id != poster_id
  end

  def event_is_not_expired
    return if self.verified_changed?
    errors.add(:event_id, "已经过期") if expired?
  end

end
