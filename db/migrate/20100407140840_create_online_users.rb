class CreateOnlineUsers < ActiveRecord::Migration
  def self.up
    create_table :online_users do |t|
      t.integer :user_id
      t.string :session_id
      t.integer :status, :default => 0 # ONLINE
    end
  end

  def self.down
    drop_table :online_users
  end
end
