class GameCharacter < ActiveRecord::Base

  def has_event?
    !Event.first(:conditions => {:character_id => id}).blank?
  end

  def has_guild?
    !Guild.first(:conditions => {:character_id => id}).blank?
  end

  def is_locked?
    has_event? or has_guild?
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

	acts_as_resource_feeds

  attr_readonly :game_id, :area_id, :server_id, :race_id, :profession_id

  validates_presence_of :user_id, :message => "不能为空"

  validates_presence_of :level, :message => "不能为空"

  validates_presence_of :name, :message => "不能为空"

  validate_on_create :game_is_valid

  validate_on_create :area_is_valid

  validate_on_create :server_is_valid

  validate_on_create :race_is_valid
  
  validate_on_create :profession_is_valid

protected

  def game_is_valid
    return if game_id.blank?
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
      errors.add(:server_id, "该游戏没有服务器")
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
