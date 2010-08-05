class CreateMiniTopicFreqNodes < ActiveRecord::Migration
  def self.up
    create_table :mini_topic_freq_nodes do |t|
      t.integer :mini_topic_id
      t.integer :freq
      t.integer :rank
      t.datetime :created_at
    end
    remove_column :mini_topics, :freq
    remove_column :mini_topics, :nodes
  end

  def self.down
    drop_table :mini_topic_freq_nodes
  end
end
