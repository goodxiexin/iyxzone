class CreateGuildRules < ActiveRecord::Migration
  def self.up
		create_table "guild_rules", :force => true do |t|
			t.string :reason
			t.integer :outcome
			t.string :rule_type
			t.integer :guild_id
		end
  end

  def self.down
		drop_table "guild_rules"
  end
end
