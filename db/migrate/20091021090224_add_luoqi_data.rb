class AddLuoqiData < ActiveRecord::Migration
  def self.up
GameProfession.create(
        :name => "人类",
        :game_id => 66)
GameProfession.create(
        :name => "精灵",
        :game_id => 66)
GameProfession.create(
        :name => "巨人",
        :game_id => 66)
  end

  def self.down
  end
end
