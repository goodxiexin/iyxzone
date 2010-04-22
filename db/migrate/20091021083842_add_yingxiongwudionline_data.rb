class AddYingxiongwudionlineData < ActiveRecord::Migration
  def self.up
GameProfession.create(
        :name => "人类",
        :game_id => 64)
GameProfession.create(
        :name => "精灵",
        :game_id => 64)
GameProfession.create(
        :name => "塔楼",
        :game_id => 64)
GameProfession.create(
        :name => "地狱",
        :game_id => 64)
GameProfession.create(
        :name => "亡灵",
        :game_id => 64)
GameProfession.create(
        :name => "野蛮",
        :game_id => 64)
GameProfession.create(
        :name => "沼泽",
        :game_id => 64)
GameProfession.create(
        :name => "地下城",
        :game_id => 64)
  end

  def self.down
  end
end
