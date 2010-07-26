class CreateMiniTopics < ActiveRecord::Migration
  def self.up
    create_table :mini_topics do |t|
      t.string :name
      t.integer :freq, :default => 0
    end
  end

  def self.down
    drop_table :mini_topics
  end
end
