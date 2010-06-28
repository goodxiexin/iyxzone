class CreateMiniBlogTopics < ActiveRecord::Migration
  def self.up
    create_table :mini_blog_topics do |t|
      t.integer :mini_blog_id
      t.integer :mini_topic_id
    end
  end

  def self.down
    drop_table :mini_blog_topics
  end
end
