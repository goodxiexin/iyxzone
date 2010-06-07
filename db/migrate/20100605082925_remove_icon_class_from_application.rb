class RemoveIconClassFromApplication < ActiveRecord::Migration
  def self.up
    remove_column :applications, :icon_class
  end

  def self.down
  end
end
