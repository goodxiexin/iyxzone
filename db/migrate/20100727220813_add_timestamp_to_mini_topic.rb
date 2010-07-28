class AddTimestampToMiniTopic < ActiveRecord::Migration
  def self.up
    add_column :mini_topics, :created_at, :datetime
  end

  def self.down
    remove_column :mini_topics, :created_at
  end
end
