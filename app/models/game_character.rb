class GameCharacter < ActiveRecord::Base

  named_scope :by, lambda {|user_ids| {:conditions => {:user_id => user_ids}}}
	
	serialize :data
  
  has_index :query_step => 20000,
            :select_fields => [:id, :name, :game_id, :server_id, :area_id],
            :writer => {:max_buffer_memory => 32, :max_buffered_docs => 20000},
            :field_infos => {
              :id => {:store => :yes, :index => :no, :term_vector => :no}, 
              :name => {:store => :yes, :index => :yes, :term_vector => :yes},
              :game_id => {:store => :yes, :index => :yes, :term_vector => :no},
              :area_id => {:store => :yes, :index => :yes, :term_vector => :no},
              :server_id => {:store => :yes, :index => :yes, :term_vector => :no}              
            }

  # required by has_index
  def to_doc
    doc = Ferret::Document.new
    
    doc[:id] = id
    doc[:name] = name
    doc[:game_id] = game_id
    doc[:area_id] = area_id
    doc[:server_id] = server_id

    doc
  end
  
  acts_as_random

  acts_as_pinyin :name => 'pinyin'

  searcher_column :name, :pinyin

  belongs_to :user

  belongs_to :game

  belongs_to :area, :class_name => 'GameArea'

  belongs_to :server, :class_name => 'GameServer'

  belongs_to :race, :class_name => 'GameRace'

  belongs_to :profession, :class_name => 'GameProfession'

	belongs_to :guild

  has_many :memberships, :foreign_key => 'character_id'

  has_many :president_or_veteran_or_member_memberships, :foreign_key => 'character_id', :class_name => 'Membership', :conditions => {:status => [Membership::President, Membership::Veteran, Membership::Member]}

  has_many :guilds, :through => :president_or_veteran_or_member_memberships

  has_many :participations, :foreign_key => 'character_id'

  has_many :confirmed_or_maybe_participations, :foreign_key => 'character_id', :class_name => 'Participation', :conditions => {:status => [Participation::Confirmed, Participation::Maybe]}

  has_many :events, :through => :confirmed_or_maybe_participations

	acts_as_resource_feeds :recipients => lambda {|character|
    [character.user.profile, character.game] + character.user.friends.all(:select => "id")
  }

  attr_readonly :game_id, :area_id, :server_id, :race_id, :profession_id

  validates_presence_of :user_id

	validates_numericality_of :level, :only_integer => true

  validates_size_of :name, :within => 1..100

  validate_on_create :game_is_valid

  validate_on_create :area_is_valid

  validate_on_create :server_is_valid

  validate_on_create :race_is_valid
  
  validate_on_create :profession_is_valid

  def has_event?
    !confirmed_or_maybe_participations.blank?
  end

  def has_guild?
    !president_or_veteran_or_member_memberships.blank?
  end

  def is_locked?
    !memberships.blank? or !participations.blank?
  end

  def name_with_game_and_server
    "#{name}(#{game.name}-#{server.name})"
  end

  def game_info
    {:game_id => game_id, :area_id => area_id, :server_id => server_id, :race_id => race_id, :profession_id => profession_id}
  end

protected

  def game_is_valid
    errors.add(:game_id, "不存在") unless Game.exists? game_id
  end

  def area_is_valid
    return if game.blank?
    if game.no_areas
      errors.add(:area_id, "该游戏没有服务区") unless area_id.blank?
    else
      errors.add(:area_id, "该服务区不存在") unless GameArea.exists? :game_id => game_id, :id => area_id
    end
  end

  def server_is_valid
    return if game.blank?
    if game.no_servers
      errors.add(:server_id, "该游戏没有服务器") unless server_id.blank?
    else
      if game.no_areas
        errors.add(:server_id, "该服务器不存在") unless GameServer.exists? :game_id => game_id, :id => server_id
      else
        errors.add(:server_id, "该服务器不存在") unless GameServer.exists? :game_id => game.id, :id => server_id, :area_id => area_id
      end
    end
  end

  def race_is_valid
    return if game.blank?
    if game.no_races
      errors.add(:race_id, "该游戏没有种族") unless race_id.blank?
    else
      errors.add(:race_id, "该种族不存在") unless GameRace.exists? :game_id => game_id, :id => race_id
    end
  end

  def profession_is_valid
    return if game.blank?
    if game.no_professions
      errors.add(:profession_id, "该游戏没有职业") unless profession_id.blank?
    else
      errors.add(:profession_id, "该职业不存在") unless GameProfession.exists? :game_id => game_id, :id => profession_id
    end
  end

end
