class CreatePolls < ActiveRecord::Migration
  def self.up
    create_table :polls do |t|
      t.string :name
      t.integer :poster_id
      t.integer :game_id
      t.text :description
      t.text :explanation
      t.integer :max_multiple
      t.date :end_date
      t.text :summary
      t.integer :privilege, :default => 2 # 1. all 2. only friends
      t.integer :comments_count, :default => 0
			t.integer :votes_count, :default => 0 
      t.integer :voters_count, :default => 0
      t.integer :answers_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :polls
  end
end
