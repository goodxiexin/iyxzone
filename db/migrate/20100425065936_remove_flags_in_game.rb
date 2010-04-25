class RemoveFlagsInGame < ActiveRecord::Migration
  def self.up
    remove_column :games, :no_areas
    remove_column :games, :no_servers
    remove_column :games, :no_races
    remove_column :games, :no_professions    
  end

  def self.down
  end
end
