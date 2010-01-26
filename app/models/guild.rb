class Guild < ActiveRecord::Base
  
  belongs_to :game

  belongs_to :president, :class_name => 'User'

  belongs_to :president_character, :class_name => 'GameCharacter', :foreign_key => 'character_id'

  named_scope :hot, :order => '(members_count + veterans_count + 1) DESC'

  named_scope :recent, :order => 'created_at DESC'

  has_one :forum

  has_one :album, :class_name => 'GuildAlbum', :foreign_key => 'owner_id', :dependent => :destroy

  has_many :events

  has_many :gears

  has_many :bosses

  has_many :rules, :class_name => 'GuildRule'

  has_many :basic_rules, :class_name => 'GuildRule', :conditions => {:rule_type => 2}

  has_many :attendance_rules, :class_name => 'GuildRule', :conditions => {:rule_type => [0, 1]}

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

	acts_as_resource_feeds

	acts_as_commentable :order => 'created_at DESC',
                      :delete_conditions => lambda {|user, guild, comment| guild.president == user}, 
                      :create_conditions => lambda {|user, guild| guild.has_member?(user)},
                      :view_conditions => lambda { true } # anyone can view

	searcher_column :name

	def people_count
		veterans_count + members_count + 1
	end

  def has_member? user
    !memberships.find(:first, :conditions => {:user_id => user.id, :status => [3,4,5]}).blank? 
  end

  def has_character? character
    !memberships.find(:first, :conditions => {:character_id => character.id, :status => [3,4,5]}).blank?
  end

  def has_only_one_character_for? user
    memberships.find(:all, :conditions => {:user_id => user.id, :status => [3,4,5]}).count == 1
  end

  def memberships_for user
    memberships.find(:all, :conditions => {:user_id => user.id})
  end

  def characters_for user
    characters.find(:all, :conditions => {:user_id => user.id})
  end

  def role_for user
    memberships.find(:first, :conditions => {:user_id => user.id, :status => [3,4,5]}, :order => 'status ASC') 
  end

  def is_requestable_by? user
    !user.characters.find(:first, :conditions => {:game_id => game_id, :area_id => game_area_id, :server_id => game_server_id}).blank?
  end

  def invitations= invitation_attrs
    return if invitation_attrs.blank?
    invitation_attrs.each do |attrs|
      invitations.build(attrs)
    end 
  end

  after_save :save_rules

  def new_rules= rule_attrs
    @new_rules_attrs = rule_attrs
  end

  def existing_rules= rule_attrs
    @existing_rules_attrs = rule_attrs
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
  end

  after_save :save_bosses

  def new_bosses= boss_attrs
    @new_bosses_attrs = boss_attrs
  end

  def existing_bosses= boss_attrs
    @existing_bosses_attrs = boss_attrs
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
  end

  after_save :save_gears

  def new_gears= gear_attrs
    @new_gears_attrs = gear_attrs
  end

  def existing_gears= gear_attrs
    @existing_gears_attrs = gear_attrs
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
  end

  # game_id, president_id, character_id 不能改变
  
  def validate
    # check name
    if name.blank?
      errors.add_to_base('名字不能为空')
      return
    elsif name.length > 100
      errors.add_to_base('名字最长100个字符')
      return
    end

    # check description
    if description.blank?
      errors.add_to_base('描述不能为空')
      return
    elsif description.length > 10000
      errors.add_to_base('描述最长10000个字符')
      return
    end
  end
 
  def validate_on_create
    return unless errors.on_base.blank?

    # game_id, server_id, area_id 被自动赋值
  
    # president_id 是由 current_user 赋值的，无须检查  
  
    # check character
    if character_id.blank?
      errors.add_to_base("没有游戏角色")
      return
    elsif GameCharacter.find(:first, :conditions => {:id => character_id, :user_id => president_id}).blank?
      errors.add_to_base("游戏角色不存在")
      return
    end
  end

  def validate_on_update
    return unless errors.on_base.blank?

    if game_id_changed?
      errors.add_to_base("不能修改game_id")
    elsif character_id_changed?
      errors.add_to_base("不能修改character_id")
    elsif president_id_changed?
      errors.add_to_base("不能修改president_id")
    end
  end

end
