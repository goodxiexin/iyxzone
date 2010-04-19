class AddInitialGames < ActiveRecord::Migration
  def self.up
		allgames = Game.find(:all)
		allgames.each do |game|
			Gameswithhole.create(:txtid => game.id, :sqlid => game.id, :gamename => game.name)
 		end
 end

  def self.down
		Gameswithhole.delete_all("id > 0")
  end
end
