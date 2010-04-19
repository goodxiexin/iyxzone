class AddAbstractToStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :content_abstract, :text
  end

  def self.down
  end
end
