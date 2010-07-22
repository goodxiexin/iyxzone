class CreateFanships < ActiveRecord::Migration
  def self.up
    create_table :fanships, :force => true do |t|
      t.integer :fan_id
      t.integer :idol_id
    end
    add_column :users, :is_idol, :boolean, :default => false
    add_column :users, :idol_description, :text
    add_column :users, :fans_count, :integer, :default => 0
  end

  def self.down
    drop_table :fanships
  end
end
