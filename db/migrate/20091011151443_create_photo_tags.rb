class CreatePhotoTags < ActiveRecord::Migration
  def self.up
    create_table :photo_tags do |t|
      t.integer :poster_id
			t.integer :photo_id
      t.integer :tagged_user_id
      t.integer :taggable_id
			t.string	:taggable_type
			t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height
      t.string :content
      t.timestamps
    end
  end

  def self.down
    drop_table :photo_tags
  end
end
