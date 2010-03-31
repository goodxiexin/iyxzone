class AddAbstracts < ActiveRecord::Migration
  def self.up
    add_column :blogs, :content_abstract, :text
    add_column :news, :content_abstract, :text
  end

  def self.down
    remove_column :blogs, :content_abstract
    remove_column :news, :content_abstract
  end
end
