class CreateMiniLinks < ActiveRecord::Migration
  def self.up
    create_table :mini_links do |t|
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :mini_links
  end
end
