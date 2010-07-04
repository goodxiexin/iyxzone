class CreateMiniLinks < ActiveRecord::Migration
  def self.up
    create_table :mini_links do |t|
      t.string :url
      t.string :thumbnail_url
      t.text :embed_html
      t.integer :reference_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :mini_links
  end
end
