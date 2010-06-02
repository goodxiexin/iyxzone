class AddIdolsCount < ActiveRecord::Migration
  def self.up
    add_column :users, :idols_count, :integer, :default => 0
  end

  def self.down
  end
end
