class AddSkilledGameIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :skilled_game_id, :integer
  end

  def self.down
    remove_column :users, :skilled_game_id
  end
end
