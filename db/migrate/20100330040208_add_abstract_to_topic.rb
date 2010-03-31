class AddAbstractToTopic < ActiveRecord::Migration

  def self.up
    add_column :topics, :content_abstract, :text
  end

  def self.down
  end
end
