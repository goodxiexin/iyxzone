class CreateShares < ActiveRecord::Migration
  
  def self.up
    create_table :shares do |t|
      t.integer :shareable_id
      t.string :shareable_type
      t.integer :digs_count, :default => 0
      t.integer :sharings_count, :default => 0
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end

end
