class AddVideoUrlToNews < ActiveRecord::Migration
  def self.up
    add_column :news, :video_url, :string
    add_column :news, :embed_html, :string
    add_column :news, :thumbnail_url, :string
  end

  def self.down
  end
end
