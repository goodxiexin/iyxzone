class CreateMiniBlogMetaDatas < ActiveRecord::Migration
  def self.up
    create_table :mini_blog_meta_datas do |t|
      t.text :random_ids
      t.string :today_topic #今日话题
      t.string :today_topic_desc # 话题的描述
    end
  end

  def self.down
    drop_table :mini_blog_meta_datas
  end
end
