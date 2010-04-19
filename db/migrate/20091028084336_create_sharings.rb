class CreateSharings < ActiveRecord::Migration
  def self.up
    create_table :sharings do |t|
      t.string  :title
      t.text    :reason # 分享理由
      t.string :shareable_type # a cache to improve performance
      t.integer :share_id
			t.integer :poster_id
      t.integer :comments_count, :default => 0
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :sharings
  end
end
