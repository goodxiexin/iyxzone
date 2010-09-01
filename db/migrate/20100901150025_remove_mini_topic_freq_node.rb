class RemoveMiniTopicFreqNode < ActiveRecord::Migration
  def self.up
    drop_table :mini_topic_freq_nodes
    remove_column :mini_topics, :freq
  end

  def self.down
  end
end
