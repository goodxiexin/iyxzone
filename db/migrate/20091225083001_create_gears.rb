class CreateGears < ActiveRecord::Migration
  def self.up
		create_table "gears", :force => true do |t|
			t.string :name
			t.string :type
			t.integer :boss_id
			t.integer :guild_id
			t.integer :cost
		end
  end

  def self.down
		drop_table "gears"
  end
end
