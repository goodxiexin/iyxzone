class AddIndexToUser < ActiveRecord::Migration
  def self.up
    add_index :users, [:login, :pinyin]
    add_index :game_characters, [:name, :pinyin]
  end

  def self.down
  end
end
