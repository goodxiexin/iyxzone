class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
			t.text :data
			t.integer :user_id
			t.string :notifier_type
			t.integer :notifier_id
			t.boolean :read, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
