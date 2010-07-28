class CreateInvalidUsers < ActiveRecord::Migration
  def self.up
    create_table :invalid_users do |t|
      t.integer :user_id
    end
  end

  def self.down
    drop_table :invalid_users
  end
end
