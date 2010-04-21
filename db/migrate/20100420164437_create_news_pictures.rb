class CreateNewsPictures < ActiveRecord::Migration
  def self.up
    create_table :news_pictures do |t|
      t.integer :news_id
      # attachment_fu fields
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.string :thumbnail
      t.integer :size
      t.integer :width
      t.integer :height
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :news_pictures
  end
end
