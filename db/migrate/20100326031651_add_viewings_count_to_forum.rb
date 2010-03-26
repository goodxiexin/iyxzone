class AddViewingsCountToForum < ActiveRecord::Migration
  def self.up
    add_column :forums, :viewings_count, :integer, :default => 0
  end

  def self.down
    remove_column :forums, :viewings_count
  end
end
