class AddShareableTypeToSharing < ActiveRecord::Migration
  def self.up
    add_column :sharings, :shareable_type, :string
  end

  def self.down
    remove_column :sharings, :shareable_type
  end
end
