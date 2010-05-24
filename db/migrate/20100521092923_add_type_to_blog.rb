class AddTypeToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :type, :string
    add_column :blogs, :orig_link, :string
		Blog.reset_column_information
		Blog.update_all("type='Blog'", true)
  end

  def self.down
    remove_column :blogs, :orig_link
    remove_column :blogs, :type
  end
end
