class AddHotTopicToMiniBlogMetaData < ActiveRecord::Migration

  def self.up
    add_column :mini_blog_meta_datas, :hot_topics, :text
  end

  def self.down
  end

end
