class Event < ActiveRecord::Base

  has_one :album, :class_name => 'EventAlbum', :foreign_key => 'owner_id', :dependent => :destroy

  belongs_to :poster, :class_name => 'User'

  belongs_to :poster_character, :class_name => 'GameCharacter', :foreign_key => 'character_id'

  belongs_to :game

  belongs_to :game_server

  belongs_to :game_area

  belongs_to :guild

	named_scope :hot, :conditions => ["end_time > ?", Time.now], :order => '(confirmed_count + maybe_count) DESC, created_at DESC'
	
	named_scope :recent, :conditions => ["end_time > ?", Time.now], :order => 'created_at DESC'

  named_scope :people_order, :order => '(confirmed_count + maybe_count) DESC'

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}}}

  has_many :participations

  has_many :invitations, :class_name => 'Participation', :conditions => {:status => Participation::Invitation}
  
  has_many :requests, :class_name => 'Participation', :conditions => {:status => Participation::Request}

  has_many :confirmed_participations, :class_name => 'Participation', :conditions => {:status => Participation::Confirmed}

  has_many :maybe_participations, :class_name => 'Participation', :conditions => {:status => Participation::Maybe}

  has_many :confirmed_and_maybe_participations, :class_name => 'Participation', :conditions => {:status => [Participation::Maybe, Participation::Confirmed]}

	with_options :source => 'participant', :uniq => true do |event|

		event.has_many :invitees, :through => :invitations

		event.has_many :requestors, :through => :requests

		event.has_many :confirmed_participants, :through => :confirmed_participations

		event.has_many :maybe_participants, :through => :maybe_participations

		event.has_many :participants, :through => :confirmed_and_maybe_participations

	end

  with_options :source => 'character' do |event|

    event.has_many :invite_characters, :through => :invitations

    event.has_many :request_characters, :through => :requests

    event.has_many :confirmed_characters, :through => :confirmed_participations

    event.has_many :maybe_characters, :through => :maybe_participations

    event.has_many :characters, :through => :confirmed_and_maybe_participations

    event.has_many :all_characters, :through => :participations

  end

  needs_verification :sensitive_columns => [:title, :description]

  acts_as_attentionable

  acts_as_commentable :order => 'created_at DESC', 
                      :delete_conditions => lambda {|user, event, comment| event.poster == user}, 
                      :create_conditions => lambda {|user, event| event.has_participant?(user)}, 
                      :view_conditions => lambda { true }

	acts_as_resource_feeds :recipients => lambda {|event| 
    poster = event.poster
    fans = poster.is_idol ? poster.fans : []
    friends = poster.friends.find_all {|f| f.application_setting.recv_event_feed?}
    [poster.profile, event.game] + (event.is_guild_event? ? [event.guild] : []) + friends + fans
  }

	searcher_column :title

  # poster_id, game_server_id, game_area_id, game_id 不能改
  # guild_id 不能改，如果存在的话
  attr_readonly :poster_id, :character_id, :game_server_id, :game_area_id, :game_id, :guild_id

  def started?
    start_time < Time.now && end_time > Time.now
  end

  def expired?
    end_time <= Time.now
  end

  def is_guild_event?
    !guild_id.nil?
  end

  def participants_count
    confirmed_count + maybe_count
  end

  def has_participant? user
    confirmed_and_maybe_participations.exists? :participant_id => user.id
  end

  def participant_ids
    confirmed_and_maybe_participations.map(&:participant_id).uniq
  end

  def inviteable_characters
    if is_guild_event?
      guild.characters - all_characters
    else
      GameCharacter.by(poster.friend_ids).match(:game_id => game_id, :area_id => game_area_id, :server_id => game_server_id) - all_characters
    end
  end
  
  def can_invite? user
    if is_guild_event?
      guild.has_people? user
    else
      poster.has_friend? user
    end
  end

  def invite characters
    return if characters.blank?
    characters.to_a.each do |character|
      invitations.build(:character_id => character.id, :participant_id => character.user_id)
    end
    save
  end

  def requestable_characters_for user
    if is_guild_event?
      guild.characters.by(user.id) - self.all_characters.by(user.id)
    else
      user.characters.match(:game_id => game_id, :area_id => game_area_id, :server_id => game_server_id) - self.all_characters.by(user.id)
    end
  end

  def is_requestable_by? user
    if is_guild_event?
      guild.has_people? user
    else
      poster == user || privilege == 1 || (privilege == 2 and poster.has_friend? user)
    end
  end

  validates_size_of :title, :within => 1..100

  validates_size_of :description, :within => 1..10000, :allow_blank => true

  validates_size_of :bulletin, :within => 1..50, :allow_blank => true

  validates_presence_of :start_time, :end_time

  validate :time_is_valid

  validate_on_create :guild_is_valid

  validate_on_create :character_is_valid

  validate_on_update :event_is_not_expired

  validates_inclusion_of :privilege, :in => [1, 2]
 
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
    
    if guild.blank?
      errors.add(:guild_id, "不存在")
    elsif !guild.can_create_event?(poster_character)
      errors.add(:guild_id, "没有权限")
    end
  end

  def character_is_valid
    errors.add(:character_id, "不存在") if poster_character.blank?
  end

  def event_is_not_expired
    if start_time_changed? or end_time_changed?
      errors.add(:event_id, "已经过期") if expired?
    end
  end

end
