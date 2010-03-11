class AddSkinIdToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :skin_id, :integer, :default => 1
  end

  def self.down
    remove_column:profiles, :skin_id
  end
end
