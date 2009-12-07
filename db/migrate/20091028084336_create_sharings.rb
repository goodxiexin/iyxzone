class CreateSharings < ActiveRecord::Migration
  def self.up
    create_table :sharings do |t|
			t.integer :shareable_id
			t.string	:shareable_type
			t.integer :poster_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sharings
  end
end
