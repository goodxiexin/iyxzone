class CreateMiniBlogs < ActiveRecord::Migration
  def self.up
    create_table :mini_blogs do |t|
      t.integer :poster_id
      t.integer :root_id
      t.integer :parent_id
      t.string :content
      t.text :nodes
      t.boolean :deleted, :default => false
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
