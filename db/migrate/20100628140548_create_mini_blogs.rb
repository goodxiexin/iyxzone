class CreateMiniBlogs < ActiveRecord::Migration
  def self.up
    create_table :mini_blogs do |t|
      t.integer :poster_id
      t.integer :initiator_id
      t.text :forwarder_ids
      t.string :content # 140字以内
      t.string :category
      t.timestamps
    end
  end

  def self.down
    drop_table :mini_blogs
  end
end
