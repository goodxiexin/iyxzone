class CreateGameResources < ActiveRecord::Migration
  def self.up
    create_table :game_resources do |t|
      t.integer :game_id
      t.integer :resource_id
      t.string :resource_type
    end
  end

  def self.down
    drop_table :game_resources
  end
end
