class CreateBosses < ActiveRecord::Migration
  def self.up
		create_table "bosses", :force => true  do |t|
			t.string :name
			t.integer :game_id
			t.integer :guild_id
			t.integer :reward
		end
  end

  def self.down
		drop_table "users"
  end
end
