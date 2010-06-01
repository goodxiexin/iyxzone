class AddFansCount < ActiveRecord::Migration
  def self.up
    add_column :users, :fans_count, :integer, :default => 0
    remove_column :users, :is_star
    add_column :users, :is_idol, :boolean, :default => false
  end

  def self.down
  end
end
