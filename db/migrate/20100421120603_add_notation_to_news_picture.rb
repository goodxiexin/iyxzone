class AddNotationToNewsPicture < ActiveRecord::Migration
  def self.up
    add_column :news_pictures, :notation, :string
  end

  def self.down
  end
end
