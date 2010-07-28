class CreateMiniTopicNodes < ActiveRecord::Migration
  def self.up
    create_table :mini_topic_nodes do |t|
      t.integer :mini_topic_id
      t.integer :freq
      t.datetime :created_at 
    end
  end

  def self.down
    drop_table :mini_topic_nodes
  end
end
