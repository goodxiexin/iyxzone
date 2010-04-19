class CreateGameswithholes < ActiveRecord::Migration
  def self.up
    create_table :gameswithholes do |t|
			t.integer :txtid
			t.integer :sqlid
			t.string	:gamename

      t.timestamps
    end
  end

  def self.down
    drop_table :gameswithholes
  end
end
