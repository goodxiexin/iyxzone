class CreateFanships < ActiveRecord::Migration
  def self.up
    create_table :fanships do |t|
      t.integer :fan_id
      t.integer :idol_id
    end
    add_column :users, :is_star, :boolean, :default => false
  end

  def self.down
    drop_table :fanships
  end
end
