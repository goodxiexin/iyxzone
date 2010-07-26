class Guild < ActiveRecord::Base

  belongs_to :president, :class_name => 'User'

  belongs_to :president_character, :class_name => 'GameCharacter', :foreign_key => 'character_id'

	belongs_to :game

	belongs_to :game_server

  belongs_to :game_area

  named_scope :hot, :order => '(members_count + veterans_count + 1) DESC, created_at DESC'

  named_scope :recent, :order => 'created_at DESC'

  named_scope :people_order, :order => '(members_count + veterans_count) DESC'

  named_scope :by, lambda {|user_ids| {:conditions => {:president_id => user_ids}}}

  has_one :forum, :dependent => :destroy

  has_one :album, :class_name => 'GuildAlbum', :foreign_key => 'owner_id', :dependent => :destroy
  
  has_many :events, :dependent => :destroy

  has_many :memberships

  with_options :class_name => 'Membership', :order => 'created_at DESC' do |guild|
    
    guild.has_many :invitations, :conditions => {:status => Membership::Invitation}

    guild.has_many :requests, :conditions => {:status => Membership::Request}

    guild.has_many :veteran_memberships, :conditions => {:status => Membership::Veteran}

    guild.has_many :member_memberships, :conditions => {:status => Membership::Member}

    guild.has_many :member_and_veteran_memberships, :conditions => {:status => [Membership::Veteran, Membership::Member]}

    guild.has_many :president_and_veteran_memberships, :conditions => {:status => [Membership::President, Membership::Veteran]}

    guild.has_many :people_memberships, :conditions => {:status => [Membership::President, Membership::Veteran, Membership::Member]}
  end

	with_options :source => 'user', :uniq => true do |guild|

    guild.has_many :invitees, :through => :invitations

		guild.has_many :requestors, :through => :requests

		guild.has_many :veterans, :through => :veteran_memberships
    
    guild.has_many :members, :through => :member_memberships

    guild.has_many :members_and_veterans, :through => :member_and_veteran_memberships

    guild.has_many :president_and_veterans, :through => :president_and_veteran_memberships

    guild.has_many :people, :through => :people_memberships

	end

  with_options :source => 'character' do |guild|

    guild.has_many :invite_characters, :through => :invitations

    guild.has_many :request_characters, :through => :requests

    guild.has_many :veteran_characters, :through => :veteran_memberships

    guild.has_many :member_characters, :through => :member_memberships

    guild.has_many :member_and_veteran_characters, :through => :member_and_veteran_memberships

    guild.has_many :president_and_veteran_characters, :through => :president_and_veteran_memberships

    guild.has_many :characters, :through => :people_memberships

    guild.has_many :all_characters, :through => :memberships

  end

  needs_verification :sensitive_columns => [:name, :description]

  acts_as_feed_recipient :delete_conditions => lambda {|user, guild| guild.president == user },
                         :categories => {
                            :blog => 'Blog',
                            :video => 'Video',
                            :poll => 'Poll',
                            :vote => 'Vote',
                            :event => 'Event',
                            :participation => 'Participation'
                          }

	acts_as_resource_feeds :recipients => lambda {|guild| 
    president = guild.president
    friends = president.friends.find_all {|f| f.application_setting.recv_guild_feed?}
    [president.profile, guild.game] + friends + (president.is_idol ? president.fans : [])
  }

  acts_as_attentionable

	acts_as_commentable :order => 'created_at DESC',
                      :delete_conditions => lambda {|user, guild, comment| guild.president == user}
                      :create_conditions => lambda {|user, guild| guild.has_people?(user)},
                      :view_conditions => lambda { true } # anyone can view

	searcher_column :name

	def people_count
		veterans_count + members_count + 1
	end

  def people_ids
    people_memberships.map(&:user_id).uniq
  end

  def has_people? user
    people_memberships.exists? :user_id => user.id
  end

  # 一个玩家可能有多个游戏角色在这个工会里
  def role_for user
    people_memberships.by(user.id).order('status ASC').first
  end

  def can_create_event? character
    president_and_veteran_characters.include?(character)
  end

  def inviteable_characters
    GameCharacter.by(president.friend_ids).match(:game_id => game_id, :area_id => game_area_id, :server_id => game_server_id) - all_characters
  end

  def can_invite? user
    president.has_friend? user
  end

  def invite characters
    return if characters.blank?
    characters.to_a.each do |character|
      invitations.build(:character_id => character.id, :user_id => character.user_id)
    end
    save
  end

  def requestable_characters_for user
    user.characters.match(:game_id => game_id, :area_id => game_area_id, :server_id => game_server_id) - all_characters.by(user.id)
  end

  def is_requestable_by? user
    true
  end

  # game_id, president_id, character_id 不能改变
  attr_readonly :game_id, :game_area_id, :game_server_id, :president_id, :character_id, :name

  validates_size_of :name, :within => 1..100

  validates_size_of :description, :within => 1..10000, :allow_blank => true

  validates_size_of :bulletin, :within => 1..40, :allow_blank => true

  validate_on_create :character_is_valid

protected

  def character_is_valid
    errors.add(:character_id, "不存在") if president_character.blank?
  end

end
