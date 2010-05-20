class AddVerifiedToAlbum < ActiveRecord::Migration
  def self.up
    add_column :albums, :verified, :integer, :default => 0
  end

  def self.down
		remove_column :albums, :verified
  end
end
