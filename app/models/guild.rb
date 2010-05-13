class Guild < ActiveRecord::Base

  named_scope :by, lambda {|user_ids| {:conditions => {:president_id => user_ids}}}

  named_scope :match, lambda {|cond| {:conditions => cond}}

  named_scope :prefetch, lambda {|opts| {:include => opts}}
  
  belongs_to :president, :class_name => 'User'

  belongs_to :president_character, :class_name => 'GameCharacter', :foreign_key => 'character_id'

	belongs_to :game

	belongs_to :game_server

  belongs_to :game_area

  named_scope :hot, :conditions => {:verified => [0,1]}, :order => '(members_count + veterans_count + 1) DESC'

  named_scope :recent, :conditions => {:verified => [0,1]}, :order => 'created_at DESC'

  has_one :forum, :dependent => :destroy

  has_one :album, :class_name => 'GuildAlbum', :foreign_key => 'owner_id', :dependent => :destroy
  
  has_many :events, :conditions => {:verified => [0,1]}, :dependent => :destroy

  has_many :gears, :dependent => :delete_all

  has_many :bosses, :dependent => :delete_all

  has_many :rules, :class_name => 'GuildRule', :dependent => :delete_all

  has_many :basic_rules, :class_name => 'GuildRule', :conditions => {:rule_type => 2}

  has_many :attendance_rules, :class_name => 'GuildRule', :conditions => {:rule_type => [0, 1]}

  has_one :absence_rule, :class_name => 'GuildRule', :conditions => {:rule_type => 0}

  has_one :presence_rule, :class_name => 'GuildRule', :conditions => {:rule_type => 1}

  has_many :memberships

  has_many :invitations, :class_name => 'Membership', :conditions => {:status => 0}

  has_many :requests, :class_name => 'Membership', :conditions => {:status => 1}

	with_options :through => :memberships, :source => 'user', :uniq => true do |guild|

    guild.has_many :invitees, :conditions => "memberships.status = 0"

		guild.has_many :requestors, :conditions => "memberships.status = 1"

		guild.has_many :veterans, :conditions => "memberships.status = 4"
    
    guild.has_many :members, :conditions => "memberships.status = 5"

    guild.has_many :people, :conditions => "memberships.status =3 or memberships.status = 4 or memberships.status = 5"

	end

  with_options :through => :memberships, :source => 'character' do |guild|

    guild.has_many :invite_characters, :conditions => "memberships.status = 0"

    guild.has_many :request_characters, :conditions => "memberships.status = 1"

    guild.has_many :veteran_characters, :conditions => "memberships.status = 4"

    guild.has_many :member_characters, :conditions => "memberships.status = 5"

    guild.has_many :characters, :conditions => "memberships.status = 3 or memberships.status = 4 or memberships.status = 5" 

    guild.has_many :all_characters

  end

  needs_verification :sensitive_columns => [:name, :description]

  acts_as_feed_recipient :delete_conditions => lambda {|user, guild| guild.president == user },
                         :categories => {
                            :blog => 'Blog',
                            :video => 'Video',
                            :poll => 'Poll',
                            :vote => 'Vote',
                            :event => 'Event',
                            :participation => 'Participation',
                            :personal_album => 'PersonalAlbum'
                          }

	acts_as_resource_feeds :recipients => lambda {|guild| [guild.president.profile, guild.game] + guild.president.friends.find_all {|f| f.application_setting.recv_guild_feed == 1} }

	acts_as_commentable :order => 'created_at DESC',
                      :delete_conditions => lambda {|user, guild, comment| guild.president == user}, 
                      :create_conditions => lambda {|user, guild| guild.has_member?(user)},
                      :view_conditions => lambda { true } # anyone can view

	searcher_column :name

  # game_id, president_id, character_id 不能改变
  attr_readonly :game_id, :game_area_id, :game_server_id, :president_id, :character_id, :name

  validates_presence_of :name, :message => "不能为空"

  validates_size_of :name, :within => 1..100, :too_long => "最长100个字节", :too_short => "最短1个字节"

  validates_size_of :description, :within => 1..10000, :too_long => "最长10000个字节", :too_short => "最短1个字节", :allow_nil => true
 
  validates_presence_of :character_id, :message => "不能为空", :on => :create

  validate_on_create :character_is_valid

	def people_count
		veterans_count + members_count + 1
	end

  def has_member? user
    memberships.exists? :user_id => user.id, :status => [3,4,5]
  end

  def has_character? character
    memberships.exists? :character_id => character.id, :status => [3,4,5]
  end

  def all_memberships_for user
    memberships.all(:conditions => {:user_id => user.id})
  end

  def memberships_for user
    memberships.all(:conditions => {:user_id => user.id, :status => [3, 4, 5]})
  end

  def requests_for user
    requests.all(:conditions => {:user_id => user.id})
  end

  def invitations_for user
    invitations.all(:conditions => {:user_id => user.id})
  end

  def all_characters_for user
    all_characters.all(:conditions => {:user_id => user.id})
  end

  def characters_for user
    characters.all(:conditions => {:user_id => user.id})
  end

  def request_characters_for user
    request_characters.all(:conditions => {:user_id => user.id})
  end

  def invite_characters_for user
    invite_characters.all(:conditions => {:user_id => user.id})
  end

  def role_for user
    memberships.find(:first, :conditions => {:user_id => user.id, :status => [3,4,5]}, :order => 'status ASC') 
  end

  def requestable_characters_for user
    user.characters.find(:all, :conditions => {:game_id => game_id, :area_id => game_area_id, :server_id => game_server_id}) -  
    all_characters.find(:all, :conditions => "memberships.user_id = #{user.id}")
  end

  def is_requestable_by? user
    !requestable_characters_for(user).blank?
  end

  def invitees= character_ids
    return if character_ids.blank?
    character_ids.each do |character_id|
      character = GameCharacter.find(character_id)
      invitations.build(:character_id => character.id, :user_id => character.user_id)
    end 
  end

  after_save :save_rules

  def new_rules= rule_attrs
    @new_rules_attrs = rule_attrs
  end

  def existing_rules= rule_attrs
    @existing_rules_attrs = rule_attrs
  end

  def del_rules= rule_ids
    @del_rules_ids = rule_ids
  end

  def save_rules
    unless @new_rules_attrs.blank?
      @new_rules_attrs.each_value do |attrs|
        basic_rules.create(attrs)
      end
    end
    @new_rules_attrs = nil
    
    unless @existing_rules_attrs.blank?
      @existing_rules_attrs.each do |id, attrs|
        rules.find(id).update_attributes(attrs)
      end
    end
    @existing_rules_attrs = nil
    
    unless @del_rules_ids.blank?
      @del_rules_ids.each do |id|
        rules.find(id).destroy
      end
    end
    @del_rules_ids = nil
  end

  after_save :save_bosses

  def new_bosses= boss_attrs
    @new_bosses_attrs = boss_attrs
  end

  def existing_bosses= boss_attrs
    @existing_bosses_attrs = boss_attrs
  end

  def del_bosses= boss_ids
    @del_bosses_ids = boss_ids
  end

  def save_bosses
    unless @new_bosses_attrs.blank?
      @new_bosses_attrs.each_value do |attrs|
        bosses.create(attrs)
      end
    end
    @new_bosses_attrs = nil

    unless @existing_bosses_attrs.blank?
      @existing_bosses_attrs.each do |id, attrs|
        bosses.find(id).update_attributes(attrs)
      end
    end
    @existing_bosses_attrs = nil

    unless @del_bosses_ids.blank?
      @del_bosses_ids.each do |id|
        bosses.find(id).destroy
      end
    end
    @del_bosses_ids = nil
  end

  after_save :save_gears

  def new_gears= gear_attrs
    @new_gears_attrs = gear_attrs
  end

  def existing_gears= gear_attrs
    @existing_gears_attrs = gear_attrs
  end

  def del_gears= gear_ids
    @del_gears_ids = gear_ids
  end

  def save_gears
    unless @new_gears_attrs.blank?
      @new_gears_attrs.each_value do |attrs|
        gears.create(attrs)
      end
    end
    @new_gears_attrs = nil

    unless @existing_gears_attrs.blank?
      @existing_gears_attrs.each do |id, attrs|
        gears.find(id).update_attributes(attrs)
      end
    end
    @existing_gears_attrs = nil

    unless @del_gears_ids.blank?
      @del_gears_ids.each do |id|
        gears.find(id).destroy
      end
    end
    @del_gears_ids = nil
  end

protected

  def character_is_valid
    return if character_id.blank?
    character = GameCharacter.find(:first, :conditions => {:id => character_id})
    errors.add(:character_id, "不存在") if character.blank?
    return if president_id.blank?
    errors.add(:character_id, "不是拥有者") if character.user_id != president_id
  end

end
