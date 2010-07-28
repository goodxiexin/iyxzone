class AddNodesToMiniTopic < ActiveRecord::Migration
  def self.up
    add_column :mini_topics, :nodes, :text
  end

  def self.down
    remove_column :mini_topics, :nodes
  end
end
