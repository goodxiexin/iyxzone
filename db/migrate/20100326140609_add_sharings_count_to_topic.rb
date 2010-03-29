class AddSharingsCountToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :sharings_count, :integer, :default => 0
  end


  def self.down
    remove_column :topics, :sharings_count
  end
end
