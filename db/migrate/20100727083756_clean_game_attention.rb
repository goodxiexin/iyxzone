class GameAttention < ActiveRecord::Base

  belongs_to :user

  belongs_to :game, :counter_cache => :attentions_count

end

class CleanGameAttention < ActiveRecord::Migration
  def self.up
    GameAttention.all.each do |a|
      a.user.mini_topic_attentions.create :topic_name => a.game.name
    end
    drop_table :game_attentions
  end

  def self.down
  end
end
