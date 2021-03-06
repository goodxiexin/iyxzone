class CreateMiniImages < ActiveRecord::Migration
  def self.up
    create_table :mini_images do |t|
      t.integer :poster_id
      t.integer :mini_blog_id
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.string :thumbnail
      t.integer :size
      t.integer :width
      t.integer :height
      t.timestamps
    end
  end

  def self.down
    drop_table :mini_images
  end
end
