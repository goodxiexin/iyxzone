class CreateInvalidNames < ActiveRecord::Migration
  def self.up
    create_table :invalid_names do |t|
      t.integer :user_id
      t.string :token
      t.timestamps
    end
  end

  def self.down
    drop_table :invalid_names
  end
end
