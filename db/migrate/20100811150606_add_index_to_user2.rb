class AddIndexToUser2 < ActiveRecord::Migration
  def self.up
    add_index :users, [:id]
  end

  def self.down
    remove_index :users, [:id] 
  end
end
