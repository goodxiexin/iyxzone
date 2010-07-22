class AddBulletin < ActiveRecord::Migration
  def self.up
    add_column :events, :bulletin, :string
    add_column :games, :bulletin, :string
    add_column :guilds, :bulletin, :string
  end

  def self.down
    remove_column :events, :bulletin
    remove_column :guilds, :bulletin
    remove_column :games, :bulletin
  end
end
