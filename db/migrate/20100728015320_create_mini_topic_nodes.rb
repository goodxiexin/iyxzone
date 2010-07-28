class CreateMiniTopicNodes < ActiveRecord::Migration
  def self.up
    create_table :mini_topic_nodes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mini_topic_nodes
  end
end
