class CreateHotWords < ActiveRecord::Migration
  def self.up
    create_table :hot_words do |t|
      t.string :name
      t.text :keywords
      t.timestamps
    end
  end

  def self.down
    drop_table :hot_words
  end
end
