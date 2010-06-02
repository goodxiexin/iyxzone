class AddIdolDescription < ActiveRecord::Migration
  def self.up
    add_column :users, :idol_description, :text
  end

  def self.down
  end
end
