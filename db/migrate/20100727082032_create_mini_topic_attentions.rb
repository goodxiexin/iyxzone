class CreateMiniTopicAttentions < ActiveRecord::Migration
  def self.up
    create_table :mini_topic_attentions do |t|
      t.string :topic_name
      t.integer :user_id 
      t.timestamps
    end
  end

  def self.down
    drop_table :mini_topic_attentions
  end
end
