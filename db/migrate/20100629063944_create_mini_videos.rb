class CreateMiniVideos < ActiveRecord::Migration
  def self.up
    create_table :mini_videos do |t|
      t.integer :mini_blog_id
      t.string :video_url
      t.string :embed_html
      t.string :thumbnail_url
    end
  end

  def self.down
    drop_table :mini_videos
  end
end
