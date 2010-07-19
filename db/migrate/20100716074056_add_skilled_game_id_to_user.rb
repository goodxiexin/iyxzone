class AddSkilledGameIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :skilled_game_id, :integer
    # 目前只有海涛
    u = User.find 784
    u.update_attributes(:skilled_game_id => 671)
  end

  def self.down
    remove_column :users, :skilled_game_id
  end
end
