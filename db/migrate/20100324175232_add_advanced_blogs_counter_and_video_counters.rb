class AddAdvancedBlogsCounterAndVideoCounters < ActiveRecord::Migration
  def self.up
    add_column :users, :blogs_count1, :integer, :default => 0
    add_column :users, :blogs_count2, :integer, :default => 0
    add_column :users, :blogs_count3, :integer, :default => 0
    add_column :users, :blogs_count4, :integer, :default => 0
    add_column :users, :videos_count1, :integer, :default => 0
    add_column :users, :videos_count2, :integer, :default => 0
    add_column :users, :videos_count3, :integer, :default => 0
    add_column :users, :videos_count4, :integer, :default => 0    
  end

  def self.down
    remove_column :users, :blogs_count1
    remove_column :users, :blogs_count2
    remove_column :users, :blogs_count3
    remove_column :users, :blogs_count4
    remove_column :users, :videos_count1
    remove_column :users, :videos_count2
    remove_column :users, :videos_count3
    remove_column :users, :videos_count4
  end
end
