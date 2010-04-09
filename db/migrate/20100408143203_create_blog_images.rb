class CreateBlogImages < ActiveRecord::Migration
  def self.up
    create_table :blog_images do |t|
      t.integer :blog_id # 如果为空，肯定是不需要的照片，如果不为空，则要比较timestamp
      # attachment_fu fields
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.string :thumbnail
      t.integer :size
      t.integer :width
      t.integer :height
      t.datetime :updated_at # 用来和blog的timestamp比较看是否是不需要的，被删除的图片
    end
  end

  def self.down
    drop_table :blog_images
  end
end
