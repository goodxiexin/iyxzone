class AddGameCharacterData < ActiveRecord::Migration
  def self.up
		add_column :game_characters, :data, :text
  end

  def self.down
		remove_column :game_characters, :data
  end
end
