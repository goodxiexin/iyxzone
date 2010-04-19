class AddInitialGames < ActiveRecord::Migration
  def self.up
 		319.times do |i|
			Gameswithhole.create(:txtid => i+1, :sqlid => i+1, :gamename => Game.find(i+1).name )
		end
 end

  def self.down
		Gameswithhole.delete_all("id > 0")
  end
end
