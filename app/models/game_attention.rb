class GameAttention < ActiveRecord::Base

  belongs_to :user

  belongs_to :game, :counter_cache => :attentions_count

  attr_readonly :user_id, :game_id

  validates_presence_of :user_id, :on => :create

  validate_on_create :game_is_valid
 
protected

  def game_is_valid 
    if game.blank? 
      errors.add(:game_id, "不存在")
    elsif user_id and game.attentions.find_by_user_id(user_id)
      errors.add(:user_id, "已经关注了")
    end
	end

end
