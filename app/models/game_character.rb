class GameCharacter < ActiveRecord::Base

  searcher_column :name

  belongs_to :user

  belongs_to :game, :counter_cache => :characters_count

  belongs_to :area, :class_name => 'GameArea'

  belongs_to :server, :class_name => 'GameServer'

  belongs_to :race, :class_name => 'GameRace'

  belongs_to :profession, :class_name => 'GameProfession'

	belongs_to :guild

	acts_as_resource_feeds

  validate do |character|
    character.errors.add_to_base('用户名不能为空') if character.name.blank?
    character.errors.add_to_base('等级不能为空') if character.level.blank?
    character.errors.add_to_base('游戏类型不能为空') if character.game_id.blank?
    character.errors.add_to_base('服务区不能为空') if character.game and !character.game.no_areas and character.area_id.blank?
    character.errors.add_to_base('服务器不能为空') if character.game and (character.game.servers_count > 0) and character.server_id.blank?
    character.errors.add_to_base('种族不能为空') if character.game and !character.game.no_races and character.race_id.blank?
    character.errors.add_to_base('职业不能为空') if character.game and !character.game.no_professions and character.profession_id.blank?
  end

end
