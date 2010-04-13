class AddCompletenessToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :completeness, :integer, :default => 0
  end

  def self.down
    remove_column :profiles, :completeness
  end
end
