class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.string :title
      t.string :type
      t.string :origin_url
      t.text :data
      t.integer :viewings_count, :default => 0
      t.integer :sharings_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :digs_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
