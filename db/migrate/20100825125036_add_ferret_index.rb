class AddFerretIndex < ActiveRecord::Migration
  def self.up
    add_column :users, :index_state, :integer, :default => 0
    add_column :game_characters, :index_state, :integer, :default => 0
  end

  def self.down
  end
end
