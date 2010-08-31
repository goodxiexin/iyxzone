class GameResource < ActiveRecord::Base

  belongs_to :game

  belongs_to :resource, :polymorphic => true

  belongs_to :blog, :foreign_key => :resource_id

  belongs_to :video, :foreign_key => :resource_id

  belongs_to :album, :foreign_key => :resource_id

  validates_uniqueness_of :game_id, :scope => [:resource_id, :resource_type]
  
  validate :game_is_valid

protected

  def game_is_valid
    if game_id.blank?
      errors.add(:game_id, "游戏id不存在")
    else
      errors.add(:game_id, "游戏不存在") if !Game.exists?(game_id)
    end
  end

end
