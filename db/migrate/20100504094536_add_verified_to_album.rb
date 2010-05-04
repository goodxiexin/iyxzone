class AddVerifiedToAlbum < ActiveRecord::Migration
  def self.up
    add_column :albums, :verified, :integer
  end

  def self.down
  end
end
