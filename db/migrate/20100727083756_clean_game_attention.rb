class GameAttention < ActiveRecord::Base

  belongs_to :user

  belongs_to :game, :counter_cache => :attentions_count

end

class CleanGameAttention < ActiveRecord::Migration
  def self.up
    Game.update_all("attentions_count = 0")
    User.update_all("game_attentions_count = 0")
    GameAttention.all.each do |a|
      a.game.follow_by a.user
    end
    drop_table :game_attentions
  end

  def self.down
  end
end
