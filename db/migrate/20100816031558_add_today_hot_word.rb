class AddTodayHotWord < ActiveRecord::Migration
  def self.up
    remove_column :mini_blog_meta_datas, :today_topic, :today_topic_desc
    add_column :mini_blog_meta_datas, :today_hot_word_id, :integer
  end

  def self.down
  end
end
