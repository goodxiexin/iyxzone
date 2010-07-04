class CreateMiniTopics < ActiveRecord::Migration
  def self.up
    create_table :mini_topics do |t|
      t.string :name
      t.integer :reference_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :mini_topics
  end
end
