class RemoveMiniTopicFreqNode < ActiveRecord::Migration
  def self.up
    drop_table :mini_topic_freq_nodes
    drop_table :mini_topics
  end

  def self.down
  end
end
