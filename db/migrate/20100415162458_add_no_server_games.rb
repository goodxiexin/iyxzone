class AddNoServerGames < ActiveRecord::Migration
  def self.up
    no_servers = Game.create(
    :name => "fuck your ass hole",
    :sale_date => "2009-5-1",
    :company => "blizzard",
    :no_areas => true,
    :no_servers => true,
    :description => "best online game ever")
  end

  def self.down
  end
end
