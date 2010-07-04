class CreateMiniBlogs < ActiveRecord::Migration
  def self.up
    create_table :mini_blogs do |t|
      t.integer :poster_id
      t.string :poster_type
      t.integer :initiator_id
      t.string :initiator_type
      t.string :content
      t.text :nodes
      t.text :forwarder_ids
      t.integer :images_count, :default => 0
      t.integer :videos_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :forwards_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :mini_blogs
  end
end
