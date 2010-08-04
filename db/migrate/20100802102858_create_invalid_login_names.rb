class CreateInvalidLoginNames < ActiveRecord::Migration
  def self.up
    create_table :invalid_login_names do |t|
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :invalid_login_names
  end
end
