class AddViewingsCountToForum < ActiveRecord::Migration
  def self.up
    add_column :topics, :viewings_count, :integer, :default => 0
  end

  def self.down
    remove_column :topics, :viewings_count
  end
end
